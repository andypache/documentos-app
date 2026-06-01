import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';

/// Botón "Anterior" o "Cancelar" del wizard de configuración
class ConfigBackButton extends StatelessWidget {
  final CompanyFormProvider provider;
  final bool busy;
  final double iconSize;
  final double fontSize;
  final EdgeInsets btnPadding;

  const ConfigBackButton({
    Key? key,
    required this.provider,
    required this.busy,
    required this.iconSize,
    required this.fontSize,
    required this.btnPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ElevatedButton.icon(
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
        provider.currentStep > 0 ? Icons.arrow_back : Icons.close_rounded,
        size: iconSize,
      ),
      label: Text(
        provider.currentStep > 0 ? l10n.btnPrevious : l10n.btnCancel,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: btnPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
        ),
      ),
    );
  }
}
