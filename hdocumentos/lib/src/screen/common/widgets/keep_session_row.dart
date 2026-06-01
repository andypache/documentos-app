import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/form/login_form_provider.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Fila con checkbox para mantener sesión iniciada
class KeepSessionRow extends StatelessWidget {
  final LoginFormProvider loginForm;

  const KeepSessionRow({
    Key? key,
    required this.loginForm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => loginForm.keepSession = !loginForm.keepSession,
      child: Row(
        children: [
          SizedBox(
            width: AppDimens.iconM,
            height: AppDimens.iconM,
            child: Checkbox(
              value: loginForm.keepSession,
              onChanged: (v) => loginForm.keepSession = v ?? false,
              activeColor: AppTheme.primaryButton,
              checkColor: AppTheme.secondary,
              side: const BorderSide(
                color: AppTheme.loginInputBorder,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusXS),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceS),
          Text(
            l10n.loginKeepSession,
            style: TextStyle(
              color: AppTheme.white.withOpacity(0.65),
              fontSize: AppDimens.fontSmall,
            ),
          ),
        ],
      ),
    );
  }
}
