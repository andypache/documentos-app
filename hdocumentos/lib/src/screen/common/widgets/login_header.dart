import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

/// Header del login con selector de idioma, ícono y títulos
class LoginHeader extends StatelessWidget {
  const LoginHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.paddingXL,
          AppDimens.paddingL, AppDimens.paddingXL, AppDimens.paddingL),
      child: Column(
        children: [
          // ── Selector de idioma alineado a la derecha ──────────────────────
          const Align(
            alignment: Alignment.centerRight,
            child: LanguageSelectorWidget(),
          ),
          const SizedBox(height: AppDimens.spaceL),
          // ── Ícono de acceso ───────────────────────────────────────────────
          Container(
            width: AppDimens.iconXL,
            height: AppDimens.iconXL,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
              border: Border.all(
                color: AppTheme.primaryButton.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: AppTheme.primaryButton,
              size: AppDimens.iconM,
            ),
          ),
          const SizedBox(height: AppDimens.spaceM),
          Text(
            l10n.loginTitle,
            style: const TextStyle(
              color: AppTheme.white,
              fontSize: AppDimens.fontTitle,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            l10n.loginSubtitle,
            style: TextStyle(
              color: AppTheme.white.withOpacity(0.55),
              fontSize: AppDimens.fontSmall,
            ),
          ),
        ],
      ),
    );
  }
}
