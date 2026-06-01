import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/provider/provider.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:hdocumentos/src/screen/customer/customer_wizard_screen.dart';
import 'package:hdocumentos/src/screen/bill/widgets/widgets.dart';

/// Body de la pantalla de facturación con scroll
class BillScreenBody extends StatelessWidget {
  const BillScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const UserSessionTitle(),
          BillScreenHeader(
            onClose: () => _confirmExit(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 80
                        : 16,
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.01),
                  // Sección de cliente
                  Selector<BillCustomerProvider, CustomerModel?>(
                    selector: (_, provider) => provider.selectedCustomer,
                    builder: (context, selectedCustomer, _) {
                      final customerProvider =
                          context.read<BillCustomerProvider>();
                      return CustomerSelectionWidget(
                        selectedCustomer: selectedCustomer,
                        onSelectCustomer: () => _showCustomerSearch(context),
                        onCreateCustomer: () => _createNewCustomer(context),
                        onRemoveCustomer: () =>
                            customerProvider.removeCustomer(),
                        onAssignConsumerFinal: () =>
                            customerProvider.assignConsumerFinal(),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Lista de productos
                  Selector<BillCalculationProvider, bool>(
                    selector: (_, provider) => provider.isCalculating,
                    builder: (context, isCalculating, _) {
                      final itemsProvider = context.read<BillItemsProvider>();
                      final calculationProvider =
                          context.read<BillCalculationProvider>();
                      return ProductListWidget(
                        billItems: itemsProvider.billItems,
                        provider: calculationProvider,
                        onRemoveItem: (index) =>
                            itemsProvider.removeItem(index),
                        onUpdateItem: (index, updatedItem) {
                          itemsProvider.updateItem(
                            index,
                            quantity: updatedItem.quantity,
                            unitPrice: updatedItem.unitPrice,
                            discount: updatedItem.discount,
                          );
                        },
                        onAddProduct: isCalculating
                            ? null
                            : () => _showProductSearch(context),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Método de pago
                  Consumer2<BillPaymentProvider, BillStateProvider>(
                    builder: (context, paymentProvider, stateProvider, _) {
                      return PaymentMethodWidget(
                        paymentMethods: paymentProvider.paymentMethods,
                        selectedMethod: paymentProvider.selectedPaymentMethod,
                        onMethodSelected: (method) {
                          paymentProvider.selectPaymentMethod(method);
                        },
                        isLoading: stateProvider.isLoading,
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmExit(BuildContext context) async {
    final customerProvider =
        Provider.of<BillCustomerProvider>(context, listen: false);
    final itemsProvider =
        Provider.of<BillItemsProvider>(context, listen: false);

    // Si no hay datos, salir directamente
    if (!customerProvider.hasCustomer && !itemsProvider.hasItems) {
      Navigator.pop(context);
      return;
    }

    // Confirmar si hay datos sin guardar
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => const BillExitConfirmationDialog(),
    );

    if (confirmed == true && context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _showCustomerSearch(BuildContext context) async {
    final customerProvider =
        Provider.of<BillCustomerProvider>(context, listen: false);

    final selectedCustomer = await showDialog<CustomerModel>(
      context: context,
      builder: (context) => const CustomerSearchDialog(),
    );

    if (selectedCustomer != null) {
      customerProvider.selectCustomer(selectedCustomer);
    }
  }

  Future<void> _createNewCustomer(BuildContext context) async {
    final customerProvider =
        Provider.of<BillCustomerProvider>(context, listen: false);

    final newCustomer = await Navigator.push<CustomerModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomerWizardScreen(),
      ),
    );

    if (newCustomer != null) {
      customerProvider.selectCustomer(newCustomer);
    }
  }

  Future<void> _showProductSearch(BuildContext context) async {
    final calculationProvider =
        Provider.of<BillCalculationProvider>(context, listen: false);
    final itemsProvider =
        Provider.of<BillItemsProvider>(context, listen: false);

    // No permitir agregar productos si está calculando
    if (calculationProvider.isCalculating) {
      return;
    }

    final selectedItem = await showDialog<ItemModel>(
      context: context,
      builder: (context) => const ProductSearchDialog(),
    );

    if (selectedItem != null) {
      // Agregar item usando el provider de items
      itemsProvider.addItem(selectedItem);
    }
  }
}
