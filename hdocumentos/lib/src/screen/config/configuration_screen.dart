import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/share/preference.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/config/company_wizard_step1_widget.dart';
import 'package:hdocumentos/src/widgets/config/company_wizard_step2_widget.dart';
import 'package:hdocumentos/src/widgets/config/company_wizard_step3_widget.dart';
import 'package:hdocumentos/src/widgets/config/company_wizard_step4_widget.dart';
import 'package:hdocumentos/src/widgets/config/company_wizard_step5_widget.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Pantalla wizard para crear y editar la compañia
class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userSession = Preferences.userSession;
    final hasCompany = userSession.hasCompany;
    final company = hasCompany
        ? CompanyModel.fromSession(userSession.toJson())
        : CompanyModel.empty();

    return ChangeNotifierProvider(
      create: (_) => CompanyFormProvider(company),
      child: _ConfigurationWizardBody(isEditing: hasCompany),
    );
  }
}

class _ConfigurationWizardBody extends StatelessWidget {
  final bool isEditing;
  const _ConfigurationWizardBody({Key? key, required this.isEditing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          SafeArea(
            child: Column(
              children: [
                UserSessionTitle(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.01,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing ? 'Editar Compañia' : 'Nueva Compañia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.052,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              isEditing
                                  ? 'Actualiza la información de tu empresa'
                                  : 'Configura tu empresa paso a paso',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: size.width * 0.032,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withOpacity(0.8),
                          size: size.width * 0.07,
                        ),
                      ),
                    ],
                  ),
                ),
                const _CompanyStepperIndicator(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.015,
                    ),
                    child: const _CompanyWizardContent(),
                  ),
                ),
                const _CompanyNavigationButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyStepperIndicator extends StatelessWidget {
  const _CompanyStepperIndicator({Key? key}) : super(key: key);

  static const List<Map<String, dynamic>> _steps = [
    {'icon': Icons.business, 'label': 'Empresa'},
    {'icon': Icons.image_outlined, 'label': 'Logo'},
    {'icon': Icons.security_outlined, 'label': 'Cert.'},
    {'icon': Icons.mail_outline, 'label': 'Correo'},
    {'icon': Icons.point_of_sale_outlined, 'label': 'Emisión'},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final current = provider.currentStep;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                margin: EdgeInsets.only(bottom: size.height * 0.03),
                decoration: BoxDecoration(
                  color: stepIndex < current
                      ? AppTheme.primaryButton
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final isActive = stepIndex == current;
          final isCompleted = stepIndex < current;
          final step = _steps[stepIndex];

          return Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: size.width * 0.1,
                  height: size.width * 0.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive || isCompleted
                        ? AppTheme.primaryButton
                        : Colors.white.withOpacity(0.12),
                    border: Border.all(
                      color: isActive || isCompleted
                          ? AppTheme.primaryButton
                          : Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryButton.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(Icons.check_rounded,
                            color: Colors.white, size: size.width * 0.04)
                        : Icon(step['icon'] as IconData,
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            size: size.width * 0.04),
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  step['label'] as String,
                  style: TextStyle(
                    color: isActive || isCompleted
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    fontSize: size.width * 0.025,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _CompanyWizardContent extends StatelessWidget {
  const _CompanyWizardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyFormProvider>(context);
    switch (provider.currentStep) {
      case 0:
        return const CompanyWizardStep1Widget();
      case 1:
        return const CompanyWizardStep2Widget();
      case 2:
        return const CompanyWizardStep3Widget();
      case 3:
        return const CompanyWizardStep4Widget();
      case 4:
        return const CompanyWizardStep5Widget();
      default:
        return const CompanyWizardStep1Widget();
    }
  }
}

class _CompanyNavigationButtons extends StatelessWidget {
  const _CompanyNavigationButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Anterior / Cancelar
          ElevatedButton.icon(
            onPressed: provider.isLoading
                ? null
                : () {
                    if (provider.currentStep > 0) {
                      provider.previousStep();
                    } else {
                      Navigator.pop(context);
                    }
                  },
            icon: Icon(
              provider.currentStep > 0
                  ? Icons.arrow_back_rounded
                  : Icons.close_rounded,
              size: size.width * 0.045,
            ),
            label: Text(
              provider.currentStep > 0 ? 'Anterior' : 'Cancelar',
              style: TextStyle(fontSize: size.width * 0.034),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  provider.currentStep > 0 ? AppTheme.grey : Colors.red,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.012,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),

          // Indicador
          Text(
            '${provider.currentStep + 1} de 5',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: size.width * 0.032,
            ),
          ),

          // Siguiente / Guardar
          provider.currentStep < 4
              ? ElevatedButton.icon(
                  onPressed: provider.isLoading
                      ? null
                      : () {
                          if (!provider.nextStep()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Completa los campos requeridos'),
                              backgroundColor: Colors.red.shade700,
                              behavior: SnackBarBehavior.floating,
                            ));
                          }
                        },
                  icon: Icon(Icons.arrow_forward_rounded,
                      size: size.width * 0.045),
                  label: Text('Siguiente',
                      style: TextStyle(
                          fontSize: size.width * 0.034,
                          fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryButton,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.012,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: provider.isLoading
                      ? null
                      : () => _handleSave(context, provider),
                  icon: provider.isLoading
                      ? SizedBox(
                          width: size.width * 0.045,
                          height: size.width * 0.045,
                          child: const CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(Icons.save_rounded, size: size.width * 0.045),
                  label: Text(
                    provider.isLoading ? 'Guardando...' : 'Guardar',
                    style: TextStyle(
                        fontSize: size.width * 0.034,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.012,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> _handleSave(
      BuildContext context, CompanyFormProvider provider) async {
    if (!provider.isValidCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Completa los campos requeridos'),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    provider.isLoading = true;

    try {
      final company = provider.buildCompanyModel();

      // TODO: Enviar al backend via service
      await Future.delayed(const Duration(seconds: 1));

      provider.isLoading = false;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Compañia "${company.businessName ?? ''}" guardada exitosamente',
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ));
        Navigator.pop(context, company);
      }
    } catch (e) {
      provider.isLoading = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }
}
