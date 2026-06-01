import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/bill_totals_data.dart';
import 'package:hdocumentos/src/provider/provider.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

/// Panel de totales responsive (landscape y portrait)
class BillTotalsPanel extends StatelessWidget {
  final VoidCallback onSave;

  const BillTotalsPanel({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Selector anidado: primero BillStateProvider para canSave
    return Selector<BillStateProvider, bool>(
      selector: (_, stateProvider) => stateProvider.canSave,
      builder: (context, canSave, _) {
        // Segundo Selector: BillCalculationProvider para totales
        return Selector<BillCalculationProvider, BillTotalsData>(
          selector: (_, calcProvider) => BillTotalsData(
            subtotal: calcProvider.subtotal,
            customerDiscount: calcProvider.customerDiscount,
            itemDiscount: calcProvider.discountItem,
            discountTotal: calcProvider.discountTotal,
            totalTax: calcProvider.totalTax,
            total: calcProvider.total,
            isCalculating: calcProvider.isCalculating,
            canSave: canSave,
            customerDiscountLabel: calcProvider.customerDiscountInfo != null
                ? AppLocalizations.of(context).labelDiscountValue(calcProvider
                    .customerDiscountInfo!.percentage
                    .toStringAsFixed(0))
                : null,
          ),
          builder: (context, totalsData, _) {
            final widget = TotalsPanelWidget(
              subtotal: totalsData.subtotal,
              customerDiscount: totalsData.customerDiscount,
              itemDiscount: totalsData.itemDiscount,
              discountTotal: totalsData.discountTotal,
              totalTax: totalsData.totalTax,
              total: totalsData.total,
              isCalculating: totalsData.isCalculating,
              canSave: totalsData.canSave,
              onSave: onSave,
              customerDiscountLabel: totalsData.customerDiscountLabel,
            );

            return isLandscape ? SizedBox(width: 300, child: widget) : widget;
          },
        );
      },
    );
  }
}
