import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/provider.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:hdocumentos/src/screen/bill/widgets/widgets.dart';

/// Pantalla principal de facturación
class BillScreen extends StatefulWidget {
  const BillScreen({Key? key}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return BillProvidersWrapper(
      child: Scaffold(
        body: Stack(
          children: [
            const BrackgroundWidget(),
            if (isLandscape)
              Row(
                children: [
                  const Expanded(child: BillScreenBody()),
                  BillTotalsPanel(
                    onSave: () => _saveBill(context),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Expanded(child: BillScreenBody()),
                  BillTotalsPanel(
                    onSave: () => _saveBill(context),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBill(BuildContext context) async {
    final stateProvider = context.read<BillStateProvider>();
    // Obtener providers necesarios para mostrar info
    final customerProvider = context.read<BillCustomerProvider>();
    final itemsProvider = context.read<BillItemsProvider>();
    final calculationProvider = context.read<BillCalculationProvider>();

    // Mostrar diálogo de confirmación
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => BillSaveConfirmDialog(
        customerName:
            customerProvider.selectedCustomer?.getDisplayName() ?? 'N/A',
        itemCount: itemsProvider.itemCount,
        total: calculationProvider.total,
      ),
    );

    if (confirmed != true) return;

    // Mostrar loading
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: Card(
              color: AppTheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                child: ContentLoadingWidget(
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final result = await stateProvider.saveBill(context);

    // Cerrar loading
    if (context.mounted) {
      Navigator.pop(context);
    }

    if (result && context.mounted) {
      // Mostrar diálogo de éxito con animación
      await showDialog(
        context: context,
        builder: (ctx) => BillSavedSuccessDialog(
          onAccept: () {
            Navigator.pop(ctx);
            Navigator.pop(context);
          },
        ),
      );
    }
  }
}
