import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/service/company_service.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

// ─── Estado de carga ─────────────────────────────────────────────────────────

enum _LoadStatus { loading, ready, error }

/// Pantalla wizard para crear y editar la compañia.
/// Carga los datos actuales desde el API antes de montar el wizard.
class ConfigurationWizardScreen extends StatefulWidget {
  const ConfigurationWizardScreen({Key? key}) : super(key: key);

  @override
  State<ConfigurationWizardScreen> createState() =>
      _ConfigurationWizardScreenState();
}

class _ConfigurationWizardScreenState extends State<ConfigurationWizardScreen> {
  final _service = CompanyService();

  _LoadStatus _status = _LoadStatus.loading;
  CompanyModel? _company;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _status = _LoadStatus.loading);
    try {
      final company = await _service.getCompany(context);
      if (!mounted) return;
      setState(() {
        // Si el API devuelve datos úsalos; si no (empresa nueva) arranca vacío
        _company = company ?? CompanyModel.empty();
        _status = _LoadStatus.ready;
      });
    } catch (_) {
      if (mounted) setState(() => _status = _LoadStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    switch (_status) {
      case _LoadStatus.loading:
        return const Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              BrackgroundWidget(),
              Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ],
          ),
        );

      case _LoadStatus.error:
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              const BrackgroundWidget(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off_rounded,
                        color: Colors.white54, size: size.width * 0.15),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'No se pudo cargar la información',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.015),
                    ElevatedButton.icon(
                      onPressed: _load,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryButton,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar',
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: size.width * 0.034)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case _LoadStatus.ready:
        final company = _company!;
        final isEditing = company.businessName?.isNotEmpty == true;

        return ChangeNotifierProvider(
          create: (_) => CompanyFormProvider(company, isEditing: isEditing),
          child: _ConfigurationWizardBody(isEditing: isEditing),
        );
    }
  }
}

class _ConfigurationWizardBody extends StatelessWidget {
  final bool isEditing;
  const _ConfigurationWizardBody({Key? key, required this.isEditing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);

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
                              isEditing
                                  ? l10n.configEditTitle
                                  : l10n.configNewTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.052,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              isEditing
                                  ? l10n.configEditSubtitle
                                  : l10n.configNewSubtitle,
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
                _CompanyNavigationButtons(isEditing: isEditing),
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

  static const List<IconData> _stepIcons = [
    Icons.business,
    Icons.image_outlined,
    Icons.security_outlined,
    Icons.mail_outline,
    Icons.point_of_sale_outlined,
    Icons.receipt_long_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final current = provider.currentStep;
    final l10n = AppLocalizations.of(context);
    final stepLabels = [
      l10n.stepCompany,
      l10n.stepLogo,
      l10n.stepCert,
      l10n.stepMail,
      l10n.stepEmission,
      'Impuestos',
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      child: Row(
        children: List.generate(_stepIcons.length * 2 - 1, (i) {
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

          return Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: size.width * 0.065,
                  height: size.width * 0.065,
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
                        : Icon(_stepIcons[stepIndex],
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            size: size.width * 0.04),
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  stepLabels[stepIndex],
                  style: TextStyle(
                    color: isActive || isCompleted
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    fontSize: size.width * 0.021,
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
      case 5:
        return const CompanyWizardStep6Widget();
      default:
        return const CompanyWizardStep1Widget();
    }
  }
}

class _CompanyNavigationButtons extends StatelessWidget {
  final bool isEditing;
  const _CompanyNavigationButtons({Key? key, required this.isEditing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final l10n = AppLocalizations.of(context);
    final bool busy = provider.isLoading || provider.isSavingStep;

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Fila principal: Anterior/Cancelar · Contador · Siguiente/Guardar todo ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Anterior / Cancelar
              ElevatedButton.icon(
                onPressed: busy
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
                  provider.currentStep > 0 ? l10n.btnPrevious : l10n.btnCancel,
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

              // Indicador de paso
              Text(
                l10n.stepCounter(provider.currentStep + 1, 6),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: size.width * 0.032,
                ),
              ),

              // Siguiente (todos los modos) / Guardar todo (solo nuevo, paso final)
              provider.currentStep < 5
                  ? ElevatedButton.icon(
                      onPressed: busy
                          ? null
                          : () {
                              if (!provider.nextStep()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(l10n.msgRequiredFields),
                                  backgroundColor: Colors.red.shade700,
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            },
                      icon: Icon(Icons.arrow_forward_rounded,
                          size: size.width * 0.045),
                      label: Text(l10n.btnNext,
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
                  // Paso final: solo mostrar "Guardar todo" cuando es NUEVO
                  : !isEditing
                      ? ElevatedButton.icon(
                          onPressed: busy
                              ? null
                              : () => _handleSave(context, provider),
                          icon: busy
                              ? SizedBox(
                                  width: size.width * 0.045,
                                  height: size.width * 0.045,
                                  child: const CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : Icon(Icons.save_rounded,
                                  size: size.width * 0.045),
                          label: Text(
                            busy ? l10n.btnSaving : l10n.btnSave,
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
                        )
                      // Paso final en edición: placeholder invisible para mantener layout
                      : SizedBox(width: size.width * 0.28),
            ],
          ),

          // ── Botón guardar paso (solo edición) ──────────────────────────────
          if (isEditing) ...[
            SizedBox(height: size.height * 0.01),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: busy ? null : () => provider.saveStep(context),
                icon: provider.isSavingStep
                    ? SizedBox(
                        width: size.width * 0.042,
                        height: size.width * 0.042,
                        child: const CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(Icons.save_outlined, size: size.width * 0.042),
                label: Text(
                  provider.isSavingStep ? l10n.btnSaving : 'Guardar este paso',
                  style: TextStyle(
                      fontSize: size.width * 0.034,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.013),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleSave(
      BuildContext context, CompanyFormProvider provider) async {
    final l10n = AppLocalizations.of(context);
    if (!provider.isValidCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.msgRequiredFields),
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
          content: Text(l10n.companySavedSuccess(company.businessName ?? '')),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ));
        Navigator.pop(context, company);
      }
    } catch (e) {
      provider.isLoading = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.saveError(e.toString())),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }
}
