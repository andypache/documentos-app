import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

/// Botón para guardar paso actual (modo edición)
class ConfigSaveStepButton extends StatelessWidget {
  final CompanyFormProvider provider;
  final bool busy;
  final double iconSize;
  final double fontSize;

  const ConfigSaveStepButton({
    Key? key,
    required this.provider,
    required this.busy,
    required this.iconSize,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: busy ? null : () => provider.saveStep(context),
        icon: provider.isSavingStep
            ? ButtonLoadingIndicator(size: iconSize)
            : Icon(Icons.save_outlined, size: iconSize),
        label: Text(
          provider.isSavingStep ? l10n.btnSaving : l10n.btnSaveStep,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.actionSaveDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
        ),
      ),
    );
  }
}
