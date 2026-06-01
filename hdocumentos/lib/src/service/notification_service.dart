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

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

  /// @deprecated Usa [showWarning] en código nuevo.
  static void showSnackbarWarning(String message) => showWarning(message);

  // ── Motor interno ──────────────────────────────────────────────────────────

  static OverlayEntry? _currentOverlay;

  static void _show({
    required String message,
    required String title,
    required NotificationType type,
    required Duration duration,
  }) {
    // Pequeño delay para asegurar que la navegación terminó
    // y el Overlay del destino esté montado
    Future.delayed(const Duration(milliseconds: 100), () {
      _insertOverlay(
        message: message,
        title: title,
        type: type,
        duration: duration,
      );
    });
  }

  static void _insertOverlay({
    required String message,
    required String title,
    required NotificationType type,
    required Duration duration,
  }) {
    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    final config = _configFor(type);

    // Cerrar notificación anterior si existe
    try {
      _currentOverlay?.remove();
    } catch (_) {}
    _currentOverlay = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Material(
          color: AppTheme.transparent,
          child: _NotificationCard(
            title: title,
            message: message,
            accentColor: config.accentColor,
            backgroundColor: config.backgroundColor,
            icon: config.icon,
            onDismiss: () {
              try {
                entry.remove();
              } catch (_) {}
              if (_currentOverlay == entry) _currentOverlay = null;
            },
          ),
        ),
      ),
    );

    _currentOverlay = entry;
    overlay.insert(entry);

    // Auto-cerrar tras la duración
    Future.delayed(duration, () {
      if (_currentOverlay == entry) {
        try {
          entry.remove();
        } catch (_) {}
        _currentOverlay = null;
      }
    });
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
