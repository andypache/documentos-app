import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/provider/app_init_provider.dart';
import 'package:hdocumentos/src/service/company_service.dart';
import 'package:hdocumentos/src/service/notification_service.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'config_back_button.dart';
import 'config_step_counter.dart';
import 'config_next_button.dart';
import 'config_save_step_button.dart';

/// Botones de navegación del wizard (Anterior/Siguiente/Guardar)
class ConfigNavigationButtons extends StatelessWidget {
  final bool isEditing;
  final CompanyService service;

  const ConfigNavigationButtons({
    Key? key,
    required this.isEditing,
    required this.service,
  }) : super(key: key);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConfigBackButton(
                provider: provider,
                busy: busy,
                iconSize: iconSize,
                fontSize: fontSize,
                btnPadding: btnPadding,
              ),
              ConfigStepCounter(
                provider: provider,
                counterFontSize: counterFontSize,
                isLandscape: isLandscape,
              ),
              ConfigNextButton(
                provider: provider,
                isEditing: isEditing,
                busy: busy,
                iconSize: iconSize,
                fontSize: fontSize,
                btnPadding: btnPadding,
                isLandscape: isLandscape,
                onSave: () => _handleSave(context, provider, l10n),
              ),
            ],
          ),
          if (isEditing) ...[
            SizedBox(height: AppDimens.spaceS),
            ConfigSaveStepButton(
              provider: provider,
              busy: busy,
              iconSize: iconSize,
              fontSize: fontSize,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleSave(
    BuildContext context,
    CompanyFormProvider provider,
    AppLocalizations l10n,
  ) async {
    if (!provider.isValidCurrentStep()) {
      NotificationService.showSnackbarError(l10n.msgRequiredFields);
      return;
    }

    provider.isLoading = true;

    try {
      final company = await service
          .createCompany(context, provider.buildCompanyModel())
          .timeout(const Duration(seconds: 20000));

      if (context.mounted) {
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
