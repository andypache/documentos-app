import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Tipos de notificación empresarial.
enum NotificationType { error, success, warning, info }

/// Servicio centralizado de notificaciones con UX empresarial.
///
/// Uso:
/// ```dart
/// NotificationService.showError('Mensaje de error', title: 'Error');
/// NotificationService.showSuccess('Guardado correctamente');
/// NotificationService.showWarning('Revise los datos');
/// NotificationService.showInfo('Versión actualizada');
/// ```
class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Obtiene [AppLocalizations] usando el context del messengerKey global.
  /// Retorna null si el messenger aún no está montado.
  static AppLocalizations? get l10n {
    final context = messengerKey.currentContext;
    if (context == null) return null;
    return AppLocalizations.of(context);
  }

  // ── API pública ────────────────────────────────────────────────────────────

  static void showError(String message, {String? title}) => _show(
        message: message,
        title: title ?? 'Error',
        type: NotificationType.error,
        duration: const Duration(seconds: 5),
      );

  static void showSuccess(String message, {String? title}) => _show(
        message: message,
        title: title ?? 'Éxito',
        type: NotificationType.success,
        duration: const Duration(seconds: 3),
      );

  static void showWarning(String message, {String? title}) => _show(
        message: message,
        title: title ?? 'Advertencia',
        type: NotificationType.warning,
        duration: const Duration(seconds: 4),
      );

  static void showInfo(String message, {String? title}) => _show(
        message: message,
        title: title ?? 'Información',
        type: NotificationType.info,
        duration: const Duration(seconds: 4),
      );

  // ── Aliases retrocompatibles ───────────────────────────────────────────────

  /// @deprecated Usa [showError] en código nuevo.
  static void showSnackbarError(String message) => showError(message);

  /// @deprecated Usa [showSuccess] en código nuevo.
  static void showSnackbarSuccess(String message) => showSuccess(message);

  // ── Motor interno ──────────────────────────────────────────────────────────

  static void _show({
    required String message,
    required String title,
    required NotificationType type,
    required Duration duration,
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return; // null-safe: sin crash si no está montado

    final config = _configFor(type);

    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.transparent,
          elevation: 0,
          duration: duration,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: EdgeInsets.zero,
          content: _NotificationCard(
            title: title,
            message: message,
            accentColor: config.accentColor,
            backgroundColor: config.backgroundColor,
            icon: config.icon,
            onDismiss: () => messenger.hideCurrentSnackBar(),
          ),
        ),
      );
  }

  static _NotificationConfig _configFor(NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return const _NotificationConfig(
          accentColor: AppTheme.red,
          backgroundColor: AppTheme.notificationErrorBg,
          icon: Icons.error_outline_rounded,
        );
      case NotificationType.success:
        return const _NotificationConfig(
          accentColor: AppTheme.secondaryButton,
          backgroundColor: AppTheme.notificationSuccessBg,
          icon: Icons.check_circle_outline_rounded,
        );
      case NotificationType.warning:
        return const _NotificationConfig(
          accentColor: AppTheme.notificationWarning,
          backgroundColor: AppTheme.notificationWarningBg,
          icon: Icons.warning_amber_rounded,
        );
      case NotificationType.info:
        return const _NotificationConfig(
          accentColor: AppTheme.blue,
          backgroundColor: AppTheme.notificationInfoBg,
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

// ── Modelos internos ──────────────────────────────────────────────────────────

class _NotificationConfig {
  const _NotificationConfig({
    required this.accentColor,
    required this.backgroundColor,
    required this.icon,
  });

  final Color accentColor;
  final Color backgroundColor;
  final IconData icon;
}

// ── Widget de tarjeta empresarial ─────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.title,
    required this.message,
    required this.accentColor,
    required this.backgroundColor,
    required this.icon,
    required this.onDismiss,
  });

  final String title;
  final String message;
  final Color accentColor;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor.withOpacity(0.35), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barra de acento izquierda (patrón enterprise)
            Container(width: 4, color: accentColor),
            // Icono del tipo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            // Jerarquía tipográfica: título + mensaje
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: TextStyle(
                        color: AppTheme.white.withOpacity(0.78),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Botón cerrar (×)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(
                Icons.close_rounded,
                size: 18,
                color: AppTheme.white.withOpacity(0.55),
              ),
              splashRadius: 16,
              padding: const EdgeInsets.all(10),
              tooltip: 'Cerrar',
            ),
          ],
        ),
      ),
    );
  }
}
