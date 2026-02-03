import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/form/customer_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/customer/customer_wizard_step1_widget.dart';
import 'package:hdocumentos/src/widgets/customer/customer_wizard_step3_widget.dart';
import 'package:hdocumentos/src/widgets/customer/customer_wizard_discount_widget.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

///Pantalla de wizard para crear/editar clientes
class CustomerWizardScreen extends StatelessWidget {
  final CustomerModel? customerToEdit;

  const CustomerWizardScreen({Key? key, this.customerToEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = CustomerFormProvider();
        if (customerToEdit != null) {
          provider.loadCustomer(customerToEdit!);
        }
        return provider;
      },
      child: _CustomerWizardBody(isEditing: customerToEdit != null),
    );
  }
}

///Cuerpo del wizard
class _CustomerWizardBody extends StatelessWidget {
  final bool isEditing;

  const _CustomerWizardBody({Key? key, required this.isEditing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 45),
                PageTitleWidget(
                  title: isEditing ? 'Editar Cliente' : 'Nuevo Cliente',
                ),
                const SizedBox(height: 55),
                const _CustomerWizardContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///Container principal del wizard
class _CustomerWizardContainer extends StatelessWidget {
  const _CustomerWizardContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerForm = Provider.of<CustomerFormProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _StepperIndicator(currentStep: customerForm.currentStep),
          const SizedBox(height: 30),
          _WizardContent(currentStep: customerForm.currentStep),
          const SizedBox(height: 30),
          const _NavigationButtons(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

///Indicador de pasos
class _StepperIndicator extends StatelessWidget {
  final int currentStep;

  const _StepperIndicator({Key? key, required this.currentStep})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          _buildStep(context, 0, 'Datos', currentStep),
          _buildConnector(0, currentStep),
          _buildStep(context, 1, 'Contacto', currentStep),
          _buildConnector(1, currentStep),
          _buildStep(context, 2, 'Descuento', currentStep),
        ],
      ),
    );
  }

  Widget _buildStep(
      BuildContext context, int stepNumber, String label, int currentStep) {
    final isActive = stepNumber == currentStep;
    final isCompleted = stepNumber < currentStep;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive || isCompleted
                  ? AppTheme.primaryButton
                  : Colors.white.withOpacity(0.2),
              border: Border.all(
                color: isActive || isCompleted
                    ? AppTheme.primaryButton
                    : Colors.white.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      '${stepNumber + 1}',
                      style: TextStyle(
                        color: isActive || isCompleted
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isActive || isCompleted
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(int stepNumber, int currentStep) {
    final isCompleted = stepNumber < currentStep;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 25),
        color: isCompleted
            ? AppTheme.primaryButton
            : Colors.white.withOpacity(0.2),
      ),
    );
  }
}

///Contenido dinámico del wizard
class _WizardContent extends StatelessWidget {
  final int currentStep;

  const _WizardContent({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 0:
        return const CustomerWizardStep1Widget();
      case 1:
        return const CustomerWizardStep2Widget();
      case 2:
        return const CustomerWizardDiscountWidget();
      default:
        return const CustomerWizardStep1Widget();
    }
  }
}

///Botones de navegación
class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerForm = Provider.of<CustomerFormProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón Anterior/Cancelar
        if (customerForm.currentStep > 0)
          ElevatedButton.icon(
            onPressed: customerForm.isLoading
                ? null
                : () => customerForm.previousStep(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Anterior'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.grey,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          )
        else
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: const Text('Cancelar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),

        // Botón Siguiente/Guardar
        if (customerForm.currentStep < 2)
          ElevatedButton.icon(
            onPressed: customerForm.isLoading
                ? null
                : () {
                    if (customerForm.nextStep()) {
                      // Paso validado y avanzado
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Por favor complete los campos requeridos'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Siguiente'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryButton,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          )
        else
          ElevatedButton.icon(
            onPressed: customerForm.isLoading
                ? null
                : () => _handleSaveCustomer(context, customerForm),
            icon: customerForm.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(customerForm.isLoading ? 'Guardando...' : 'Guardar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryButton,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
      ],
    );
  }

  Future<void> _handleSaveCustomer(
      BuildContext context, CustomerFormProvider customerForm) async {
    // Validar paso actual
    if (!customerForm.isValidCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete los campos requeridos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    customerForm.isLoading = true;

    try {
      final customer = customerForm.buildCustomerModel();

      // TODO: Implementar guardado en el servicio
      await Future.delayed(const Duration(seconds: 1));

      customerForm.isLoading = false;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              customer.customerId != null
                  ? 'Cliente actualizado exitosamente'
                  : 'Cliente creado exitosamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, customer);
      }
    } catch (e) {
      customerForm.isLoading = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
