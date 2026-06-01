import 'package:flutter/material.dart';
import 'package:hdocumentos/src/provider/locale_provider.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:provider/provider.dart';

/// Widget selector de idioma (ES / EN) para mostrar junto al header de sesión
class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isSpanish = localeProvider.isSpanish;

    return GestureDetector(
      onTap: () => localeProvider.toggleLanguage(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          border: Border.all(
            color: AppTheme.primaryButton.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bandera / emoji
            Text(
              isSpanish ? '🇪🇸' : '🇺🇸',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            // Código del idioma activo
            Text(
              isSpanish ? 'ES' : 'EN',
              style: const TextStyle(
                color: AppTheme.primaryButton,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.expand_more_rounded,
              color: AppTheme.primaryButton.withOpacity(0.7),
              size: 13,
            ),
          ],
        ),
      ),
    );
  }
}
