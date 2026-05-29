import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/provider.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:hdocumentos/src/screen/customer/customer_wizard_screen.dart';

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

    return ChangeNotifierProvider(
      create: (_) => BillFormProvider()..initialize(context),
      child: Scaffold(
        body: Stack(
          children: [
            const BrackgroundWidget(),
            if (isLandscape)
              Row(
                children: [
                  const Expanded(child: _BillScreenBody()),
                  Consumer<BillFormProvider>(
                    builder: (context, provider, _) {
                      return SizedBox(
                        width: 300,
                        child: TotalsPanelWidget(
                          subtotal: provider.subtotal,
                          customerDiscount: provider.customerDiscount,
                          itemDiscount: provider.discountItem,
                          discountTotal: provider.discountTotal,
                          totalTax: provider.totalTax,
                          total: provider.total,
                          isCalculating: provider.isCalculating,
                          canSave: provider.canSave,
                          onSave: () => _saveBill(context, provider),
                          customerDiscountLabel:
                              provider.customerDiscountInfo != null
                                  ? AppLocalizations.of(context)
                                      .labelDiscountValue(provider
                                          .customerDiscountInfo!.percentage
                                          .toStringAsFixed(0))
                                  : null,
                        ),
                      );
                    },
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Expanded(child: _BillScreenBody()),
                  Consumer<BillFormProvider>(
                    builder: (context, provider, _) {
                      return TotalsPanelWidget(
                        subtotal: provider.subtotal,
                        customerDiscount: provider.customerDiscount,
                        itemDiscount: provider.discountItem,
                        discountTotal: provider.discountTotal,
                        totalTax: provider.totalTax,
                        total: provider.total,
                        isCalculating: provider.isCalculating,
                        canSave: provider.canSave,
                        onSave: () => _saveBill(context, provider),
                        customerDiscountLabel: provider.customerDiscountInfo !=
                                null
                            ? AppLocalizations.of(context).labelDiscountValue(
                                provider.customerDiscountInfo!.percentage
                                    .toStringAsFixed(0))
                            : null,
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBill(
      BuildContext context, BillFormProvider provider) async {
    // Mostrar diálogo de confirmación
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        return AlertDialog(
          backgroundColor: AppTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.billConfirmTitle,
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.billConfirmCustomer(
                    provider.selectedCustomer?.getDisplayName() ?? 'N/A'),
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.billConfirmProducts(provider.itemCount),
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.billConfirmTotal(provider.total.toStringAsFixed(2)),
                style: const TextStyle(
                  color: AppTheme.primaryButton,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx, false),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
                side: const BorderSide(color: AppTheme.dialogBorder),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(l10n.btnCancel),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(ctx, true),
              icon: const Icon(Icons.save_rounded, size: 18),
              label: Text(l10n.btnSave),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.actionSave,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        );
      },
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

    final result = await provider.saveBill(context);

    // Cerrar loading
    if (context.mounted) {
      Navigator.pop(context);
    }

    if (result && context.mounted) {
      // Mostrar diálogo de éxito con animación
      await showDialog(
        context: context,
        builder: (ctx) {
          final l10n = AppLocalizations.of(ctx);
          return AlertDialog(
            backgroundColor: AppTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.actionSave.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppTheme.actionSave,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.billSavedTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.billSavedMsg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryButton,
                    foregroundColor: AppTheme.secondary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    l10n.btnAccept,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}

/// Body de la pantalla con scroll
class _BillScreenBody extends StatelessWidget {
  const _BillScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Widget de información del usuario
          const UserSessionTitle(),
          // Header con título y botón de cerrar
          Container(
            padding: EdgeInsets.only(
              top: 0,
              left: size.width * 0.05,
              right: size.width * 0.05,
              bottom: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PageTitleWidget(title: l10n.billTitle),
                ),
                IconButton(
                  icon: Icon(Icons.close,
                      color: Colors.white, size: size.width * 0.07),
                  onPressed: () => _confirmExit(context),
                  tooltip: 'Cerrar',
                ),
              ],
            ),
          ),
          // Resto del contenido
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 80 // Altura del panel de totales
                        : 16,
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.01),
                  Consumer<BillFormProvider>(
                    builder: (context, provider, _) {
                      return Column(
                        children: [
                          // Selección de cliente
                          CustomerSelectionWidget(
                            selectedCustomer: provider.selectedCustomer,
                            onSelectCustomer: () =>
                                _showCustomerSearch(context),
                            onCreateCustomer: () => _createNewCustomer(context),
                            onRemoveCustomer: () => provider.removeCustomer(),
                            onAssignConsumerFinal: () =>
                                provider.assignConsumerFinal(),
                          ),
                          SizedBox(height: size.height * 0.02),

                          // Lista de productos
                          ProductListWidget(
                            billItems: provider.billItems,
                            provider: provider,
                            onRemoveItem: (index) => provider.removeItem(index),
                            onUpdateItem: (index, updatedItem) {
                              provider.updateItem(
                                index,
                                quantity: updatedItem.quantity,
                                unitPrice: updatedItem.unitPrice,
                                discount: updatedItem.discount,
                              );
                            },
                            onAddProduct: provider.isCalculating
                                ? null
                                : () => _showProductSearch(context),
                          ),
                          SizedBox(height: size.height * 0.02),

                          // Método de pago
                          PaymentMethodWidget(
                            paymentMethods: provider.paymentMethods,
                            selectedMethod: provider.selectedPaymentMethod,
                            onMethodSelected: (method) {
                              provider.selectPaymentMethod(method);
                            },
                            isLoading: provider.isLoading,
                          ),

                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ), // Column
    ); // SafeArea
  }

  Future<void> _confirmExit(BuildContext context) async {
    final provider = Provider.of<BillFormProvider>(context, listen: false);

    // Si no hay datos, salir directamente
    if (!provider.hasCustomer && !provider.hasItems) {
      Navigator.pop(context);
      return;
    }

    // Confirmar si hay datos sin guardar
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        return AlertDialog(
          backgroundColor: AppTheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            l10n.billExitTitle,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            l10n.billExitMsg,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx, false),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
                side: const BorderSide(color: AppTheme.dialogBorder),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(l10n.btnCancel),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(ctx, true),
              icon: const Icon(Icons.exit_to_app_rounded, size: 18),
              label: Text(l10n.btnExit),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.actionDanger,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _showCustomerSearch(BuildContext context) async {
    final provider = Provider.of<BillFormProvider>(context, listen: false);

    final selectedCustomer = await showDialog<CustomerModel>(
      context: context,
      builder: (context) => const CustomerSearchDialog(),
    );

    if (selectedCustomer != null) {
      provider.selectCustomer(selectedCustomer);
      if (provider.billItems.isNotEmpty) {
        // Recalcular con el nuevo cliente
        provider.calculateBill(context);
      }
    }
  }

  Future<void> _createNewCustomer(BuildContext context) async {
    final provider = Provider.of<BillFormProvider>(context, listen: false);

    final newCustomer = await Navigator.push<CustomerModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomerWizardScreen(),
      ),
    );

    if (newCustomer != null) {
      provider.selectCustomer(newCustomer);
      if (provider.billItems.isNotEmpty) {
        // Recalcular con el nuevo cliente
        provider.calculateBill(context);
      }
    }
  }

  Future<void> _showProductSearch(BuildContext context) async {
    final provider = Provider.of<BillFormProvider>(context, listen: false);

    // No permitir agregar productos si está calculando
    if (provider.isCalculating) {
      return;
    }

    final selectedItem = await showDialog<ItemModel>(
      context: context,
      builder: (context) => const ProductSearchDialog(),
    );

    if (selectedItem != null) {
      // Esperar a que termine el cálculo antes de permitir agregar otro
      await provider.addItem(selectedItem);
    }
  }
}
