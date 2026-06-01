import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';
import 'package:hdocumentos/src/provider/app_init_provider.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/service/company_service.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:hdocumentos/src/screen/config/widgets/widgets.dart';
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
                      SizedBox(height: AppDimens.paddingM),
                      Text(
                        l10n.couldNotLoadInfo,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: AppDimens.spaceM),
                      ElevatedButton.icon(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(l10n.btnRetry),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryButton,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimens.radiusM)),
                        ),
                      ),
                      SizedBox(height: AppDimens.spaceS),
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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final provider = Provider.of<CompanyFormProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          SafeArea(
            child: Column(
              children: [
                if (!isLandscape) const UserSessionTitle(),
                ConfigWizardHeader(
                  isEditing: isEditing,
                  onClose: () => Navigator.pop(context),
                ),
                ConfigStepperIndicator(currentStep: provider.currentStep),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: 12,
                    ),
                    child: const _CompanyWizardContent(),
                  ),
                ),
                ConfigNavigationButtons(
                  isEditing: isEditing,
                  service: CompanyService(),
                ),
              ],
            ),
          ),
        ],
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
