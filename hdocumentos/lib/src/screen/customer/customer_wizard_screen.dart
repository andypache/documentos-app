import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.02),
                  PageTitleWidget(
                    title: isEditing
                        ? AppLocalizations.of(context).customerEditTitle
                        : AppLocalizations.of(context).customerCreateTitle,
                  ),
                  SizedBox(height: size.height * 0.025),
                  const _CustomerWizardContainer(),
                ],
              ),
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
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          _StepperIndicator(currentStep: customerForm.currentStep),
          SizedBox(height: size.height * 0.025),
          _WizardContent(currentStep: customerForm.currentStep),
          SizedBox(height: size.height * 0.025),
          const _NavigationButtons(),
          SizedBox(height: size.height * 0.06),
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
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04, vertical: size.height * 0.012),
      child: Row(
        children: [
          _buildStep(context, 0, AppLocalizations.of(context).stepCustomerData,
              currentStep),
          _buildConnector(0, currentStep),
          _buildStep(context, 1,
              AppLocalizations.of(context).stepCustomerContact, currentStep),
          _buildConnector(1, currentStep),
          _buildStep(context, 2, AppLocalizations.of(context).labelDiscount,
              currentStep),
        ],
      ),
    );
  }

  Widget _buildStep(
      BuildContext context, int stepNumber, String label, int currentStep) {
    final isActive = stepNumber == currentStep;
    final isCompleted = stepNumber < currentStep;
    final size = MediaQuery.of(context).size;
    final circleSize = size.shortestSide * 0.1;
    final iconSize = size.shortestSide * 0.05;
    final labelFontSize = size.shortestSide * 0.028;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: circleSize,
            height: circleSize,
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
                  ? Icon(Icons.check, color: Colors.white, size: iconSize)
                  : Text(
                      '${stepNumber + 1}',
                      style: TextStyle(
                        color: isActive || isCompleted
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: iconSize * 0.8,
                      ),
                    ),
            ),
          ),
          SizedBox(height: size.height * 0.005),
          Text(
            label,
            style: TextStyle(
              color: isActive || isCompleted
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
              fontSize: labelFontSize,
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
        return const CustomerWizardStep3Widget();
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
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);
    final btnPadding = EdgeInsets.symmetric(
      horizontal: size.width * 0.05,
      vertical: size.height * 0.015,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón Anterior / Cancelar
        if (customerForm.currentStep > 0)
          ElevatedButton.icon(
            onPressed: customerForm.isLoading
                ? null
                : () => customerForm.previousStep(),
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text(l10n.btnPrevious),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.grey,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: btnPadding,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          )
        else
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            label: Text(l10n.btnCancel),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.actionDanger,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: btnPadding,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),

        // Botón Siguiente / Guardar
        if (customerForm.currentStep < 2)
          ElevatedButton.icon(
            onPressed: customerForm.isLoading
                ? null
                : () {
                    if (customerForm.nextStep()) {
                      // Paso validado y avanzado
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.msgRequiredFields),
                          backgroundColor: AppTheme.actionDanger,
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(l10n.btnNext),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryButton,
              foregroundColor: AppTheme.secondary,
              elevation: 0,
              padding: btnPadding,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          )
        else
          ElevatedButton.icon(
            onPressed: customerForm.isLoading
                ? null
                : () => _handleSaveCustomer(context, customerForm),
            icon: customerForm.isLoading
                ? const ButtonLoadingIndicator()
                : const Icon(Icons.save_rounded),
            label: Text(customerForm.isLoading ? l10n.btnSaving : l10n.btnSave),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.actionSave,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: btnPadding,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
        SnackBar(
          content: Text(AppLocalizations.of(context).msgRequiredFields),
          backgroundColor: AppTheme.actionDanger,
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
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              customer.customerId != null
                  ? l10n.customerUpdatedSuccess
                  : l10n.customerCreatedSuccess,
            ),
            backgroundColor: AppTheme.actionSave,
          ),
        );
        Navigator.pop(context, customer);
      }
    } catch (e) {
      customerForm.isLoading = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).saveError(e.toString())),
            backgroundColor: AppTheme.actionDanger,
          ),
        );
      }
    }
  }
}
