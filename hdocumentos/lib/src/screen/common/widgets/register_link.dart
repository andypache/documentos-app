import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Enlace para navegar a la pantalla de registro
class RegisterLink extends StatelessWidget {
  const RegisterLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.primaryButton,
      ),
      child: Text(
        l10n.loginRegisterLink,
        style: const TextStyle(
          fontSize: AppDimens.fontSmall,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
