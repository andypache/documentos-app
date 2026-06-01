import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

/// Botón "Siguiente" o "Guardar" del wizard de configuración
class ConfigNextButton extends StatelessWidget {
  final CompanyFormProvider provider;
  final bool isEditing;
  final bool busy;
  final double iconSize;
  final double fontSize;
  final EdgeInsets btnPadding;
  final bool isLandscape;
  final VoidCallback onSave;

  const ConfigNextButton({
    Key? key,
    required this.provider,
    required this.isEditing,
    required this.busy,
    required this.iconSize,
    required this.fontSize,
    required this.btnPadding,
    required this.isLandscape,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);

    if (provider.currentStep < 5) {
      return ElevatedButton.icon(
        onPressed: busy ? null : () => provider.nextStep(),
        icon: Icon(Icons.arrow_forward, size: iconSize),
        label: Text(
          l10n.btnNext,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryButton,
          foregroundColor: AppTheme.secondary,
          elevation: 0,
          padding: btnPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
        ),
      );
    } else if (!isEditing) {
      return ElevatedButton.icon(
        onPressed: busy ? null : onSave,
        icon: busy
            ? ButtonLoadingIndicator(size: iconSize)
            : Icon(Icons.save_rounded, size: iconSize),
        label: Text(
          busy ? l10n.btnSaving : l10n.btnSave,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.actionSave,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: btnPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
        ),
      );
    } else {
      return SizedBox(width: isLandscape ? 80.0 : size.width * 0.28);
    }
  }
}
