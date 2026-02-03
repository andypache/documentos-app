import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider(
      create: (_) => BillFormProvider()..initialize(context),
      child: Scaffold(
        body: Stack(
          children: [
            const BrackgroundWidget(),
            Column(
              children: [
                const Expanded(child: _BillScreenBody()),
                Consumer<BillFormProvider>(
                  builder: (context, provider, _) {
                    return TotalsPanelWidget(
                      subtotal: provider.subtotal,
                      customerDiscount: provider.customerDiscount,
                      totalTax: provider.totalTax,
                      total: provider.total,
                      isCalculating: provider.isCalculating,
                      canSave: provider.canSave,
                      onSave: () => _saveBill(context, provider),
                      customerDiscountLabel: provider.customerDiscountInfo !=
                              null
                          ? 'Descuento ${provider.customerDiscountInfo!.percentage.toStringAsFixed(0)}%'
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
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.primary,
        title: const Text(
          '¿Guardar Factura?',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cliente: ${provider.selectedCustomer?.getDisplayName() ?? 'N/A'}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Productos: ${provider.itemCount}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Total: \$${provider.total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryButton,
            ),
            child: const Text('Guardar'),
          ),
        ],
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
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Guardando factura...'),
                  ],
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
        builder: (context) => AlertDialog(
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
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.greenAccent,
                  size: 64,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Factura Guardada!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'La factura se guardó',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'exitosamente',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar diálogo
                  Navigator.pop(context); // Cerrar pantalla de factura
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryButton,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

/// Body de la pantalla con scroll
class _BillScreenBody extends StatelessWidget {
  const _BillScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header con título y botón de cerrar
        Container(
          padding:
              const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: PageTitleWidget(title: 'Facturar'),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => _confirmExit(context),
                tooltip: 'Cerrar',
              ),
            ],
          ),
        ),
        // Resto del contenido
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Consumer<BillFormProvider>(
                  builder: (context, provider, _) {
                    return Column(
                      children: [
                        // Selección de cliente
                        CustomerSelectionWidget(
                          selectedCustomer: provider.selectedCustomer,
                          onSelectCustomer: () => _showCustomerSearch(context),
                          onCreateCustomer: () => _createNewCustomer(context),
                          onRemoveCustomer: () => provider.removeCustomer(),
                          onAssignConsumerFinal: () =>
                              provider.assignConsumerFinal(),
                        ),
                        const SizedBox(height: 16),

                        // Lista de productos
                        ProductListWidget(
                          billItems: provider.billItems,
                          onRemoveItem: (index) => provider.removeItem(index),
                          onUpdateItem: (index, updatedItem) {
                            provider.updateItem(
                              index,
                              quantity: updatedItem.quantity,
                              unitPrice: updatedItem.unitPrice,
                              discount: updatedItem.discount,
                            );
                          },
                          onAddProduct: () => _showProductSearch(context),
                        ),
                        const SizedBox(height: 16),

                        // Método de pago
                        PaymentMethodWidget(
                          paymentMethods: provider.paymentMethods,
                          selectedMethod: provider.selectedPaymentMethod,
                          onMethodSelected: (method) {
                            provider.selectPaymentMethod(method);
                          },
                          isLoading: provider.isLoading,
                        ),

                        // Espacio para el panel de totales
                        const SizedBox(height: 300),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.primary,
        title: const Text(
          '¿Salir sin guardar?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Hay datos sin guardar que se perderán.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Salir'),
          ),
        ],
      ),
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

    final selectedItem = await showDialog<ItemModel>(
      context: context,
      builder: (context) => const ProductSearchDialog(),
    );

    if (selectedItem != null) {
      provider.addItem(selectedItem);
      // El recálculo se dispara automáticamente en addItem
      provider.calculateBill(context);
    }
  }
}
