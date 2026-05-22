import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';
import 'package:hdocumentos/src/provider/app_init_provider.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/service/company_service.dart';
import 'package:hdocumentos/src/service/notification_service.dart';
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
  _LoadStatus _status = _LoadStatus.loading;
  CompanyModel? _company;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _status = _LoadStatus.loading);
    try {
      // Leer la empresa desde la sesión (AppInitProvider) sin llamar al API.
      // El refresco desde API sólo ocurre con el botón de refresh de la barra.
      final company = context.read<AppInitProvider>().company;
      if (!mounted) return;
      setState(() {
        _company = company ?? CompanyModel.empty();
        // Calculado UNA SOLA VEZ desde el company original (antes de ediciones del usuario)
        _isEditing = company?.businessName?.isNotEmpty == true;
        _status = _LoadStatus.ready;
      });
    } catch (_) {
      if (mounted) setState(() => _status = _LoadStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _LoadStatus.loading:
        return const Scaffold(
          backgroundColor: AppTheme.transparent,
          body: Stack(
            children: [
              BrackgroundWidget(),
              AppLoadingWidget(
                overlay: true,
                color: AppTheme.white,
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
                child: Builder(builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  final size = MediaQuery.of(context).size;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_off_rounded,
                          color: Colors.white54, size: size.width * 0.15),
                      const SizedBox(height: 16),
                      Text(
                        l10n.couldNotLoadInfo,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(l10n.btnRetry),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryButton,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.btnCancel,
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: size.width * 0.034)),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        );

      case _LoadStatus.ready:
        return ChangeNotifierProvider(
          create: (_) => CompanyFormProvider(_company!, isEditing: _isEditing),
          child: _ConfigurationWizardBody(isEditing: _isEditing),
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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          SafeArea(
            child: Column(
              children: [
                if (!isLandscape) const UserSessionTitle(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05, vertical: 8),
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
                      vertical: 12,
                    ),
                    child: const _CompanyWizardContent(),
                  ),
                ),
                _CompanyNavigationButtons(
                    isEditing: isEditing, service: CompanyService()),
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
      l10n.stepTaxes,
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 8),
      child: Row(
        children: List.generate(_stepIcons.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 24),
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
                SizedBox(height: 4),
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
  final CompanyService _service;
  const _CompanyNavigationButtons(
      {Key? key, required this.isEditing, required CompanyService service})
      : _service = service,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final l10n = AppLocalizations.of(context);
    final bool busy = provider.isLoading || provider.isSavingStep;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final double iconSize = isLandscape ? 18.0 : size.width * 0.045;
    final double fontSize = isLandscape ? 13.0 : size.width * 0.034;
    final double counterFontSize = isLandscape ? 12.0 : size.width * 0.032;
    final EdgeInsets btnPadding = EdgeInsets.symmetric(
      horizontal: isLandscape ? 16.0 : size.width * 0.05,
      vertical: 10,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: 12,
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
                  size: iconSize,
                ),
                label: Text(
                  provider.currentStep > 0 ? l10n.btnPrevious : l10n.btnCancel,
                  style: TextStyle(fontSize: fontSize),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: provider.currentStep > 0
                      ? AppTheme.grey
                      : AppTheme.actionDanger,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: btnPadding,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),

              // Indicador de paso
              Text(
                l10n.stepCounter(provider.currentStep + 1, 6),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: counterFontSize,
                ),
              ),

              // Siguiente (todos los modos) / Guardar todo (solo nuevo, paso final)
              provider.currentStep < 5
                  ? ElevatedButton.icon(
                      onPressed: busy
                          ? null
                          : () {
                              if (!provider.nextStep()) {
                                NotificationService.showSnackbarError(
                                    l10n.msgRequiredFields);
                              }
                            },
                      icon: Icon(Icons.arrow_forward_rounded, size: iconSize),
                      label: Text(l10n.btnNext,
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryButton,
                        foregroundColor: AppTheme.secondary,
                        elevation: 0,
                        padding: btnPadding,
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
                              ? ButtonLoadingIndicator(size: iconSize)
                              : Icon(Icons.save_rounded, size: iconSize),
                          label: Text(
                            busy ? l10n.btnSaving : l10n.btnSave,
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.actionSave,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: btnPadding,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        )
                      // Paso final en edición: placeholder invisible
                      : SizedBox(width: isLandscape ? 80.0 : size.width * 0.28),
            ],
          ),

          // ── Botón guardar paso (solo edición) ──────────────────────────────
          if (isEditing) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: busy ? null : () => provider.saveStep(context),
                icon: provider.isSavingStep
                    ? ButtonLoadingIndicator(size: iconSize)
                    : Icon(Icons.save_outlined, size: iconSize),
                label: Text(
                  provider.isSavingStep ? l10n.btnSaving : l10n.btnSaveStep,
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.actionSaveDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 10),
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
      NotificationService.showSnackbarError(l10n.msgRequiredFields);
      return;
    }

    provider.isLoading = true;

    try {
      final company = await _service
          .createCompany(context, provider.buildCompanyModel())
          .timeout(const Duration(seconds: 20000));

      if (context.mounted) {
        // Sincronizar el companyId y datos devueltos por el servidor en sesión
        await context.read<AppInitProvider>().updateCompany(company);
        if (!context.mounted) return;
        provider.isLoading = false;
        NotificationService.showSnackbarSuccess(
            l10n.companySavedSuccess(company.businessName ?? ''));
        Navigator.pop(context, company);
      }
    } catch (e) {
      if (context.mounted) {
        provider.isLoading = false;
        NotificationService.showSnackbarError(l10n.saveError(e.toString()));
      }
    }
  }
}
