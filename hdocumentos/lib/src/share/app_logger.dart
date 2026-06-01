// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart';

/// Sistema de logging profesional para la aplicación
/// Uso:
/// - AppLogger.debug('Mensaje de debug')
/// - AppLogger.info('Información general')
/// - AppLogger.warning('Advertencia')
/// - AppLogger.error('Error crítico', error, stackTrace)
class AppLogger {
  // Colores ANSI para terminal
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _gray = '\x1B[90m';
  static const String _green = '\x1B[32m';

  /// Log nivel DEBUG - Solo visible en modo debug
  /// Usar para información detallada de desarrollo
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      final tagStr = tag != null ? '[$tag] ' : '';
      print('$_gray$timestamp [DEBUG] $tagStr$message$_reset');
    }
  }

  /// Log nivel INFO - Información general
  /// Usar para eventos importantes de flujo normal
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      final tagStr = tag != null ? '[$tag] ' : '';
      print('$_blue$timestamp [INFO] $tagStr$message$_reset');
    }
  }

  /// Log nivel WARNING - Advertencias
  /// Usar para situaciones anormales pero manejables
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      final tagStr = tag != null ? '[$tag] ' : '';
      print('$_yellow$timestamp [WARNING] $tagStr$message$_reset');
    }
  }

  /// Log nivel ERROR - Errores críticos
  /// Usar para errores que afectan funcionalidad
  static void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    final timestamp = _getTimestamp();
    final tagStr = tag != null ? '[$tag] ' : '';
    print('$_red$timestamp [ERROR] $tagStr$message$_reset');

    if (error != null) {
      print('$_red  └─ Error: $error$_reset');
    }

    if (stackTrace != null && kDebugMode) {
      print('$_gray  └─ StackTrace:\n$stackTrace$_reset');
    }
  }

  /// Log nivel SUCCESS - Operaciones exitosas
  /// Usar para confirmaciones importantes
  static void success(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      final tagStr = tag != null ? '[$tag] ' : '';
      print('$_green$timestamp [SUCCESS] $tagStr$message$_reset');
    }
  }

  /// Separador visual para secciones
  static void separator([String? title]) {
    if (kDebugMode) {
      if (title != null) {
        print('$_gray━━━━━━━━━ $title ━━━━━━━━━$_reset');
      } else {
        print('$_gray━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$_reset');
      }
    }
  }

  /// Obtiene timestamp formateado
  static String _getTimestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';
  }

  /// Log de objeto JSON formateado
  static void json(dynamic object, {String? tag}) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      final tagStr = tag != null ? '[$tag] ' : '';
      print('$_blue$timestamp [JSON] $tagStr$_reset');
      print('$_gray$object$_reset');
    }
  }

  /// Log de request HTTP
  static void request({
    required String method,
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    if (kDebugMode) {
      separator('HTTP REQUEST');
      info('$method $url', tag: 'HTTP');
      if (headers != null && headers.isNotEmpty) {
        debug('Headers: $headers', tag: 'HTTP');
      }
      if (body != null && body.isNotEmpty) {
        json(body, tag: 'HTTP BODY');
      }
    }
  }

  /// Log de response HTTP
  static void response({
    required int statusCode,
    required String url,
    dynamic body,
    Duration? duration,
  }) {
    if (kDebugMode) {
      final durationStr =
          duration != null ? ' (${duration.inMilliseconds}ms)' : '';
      if (statusCode >= 200 && statusCode < 300) {
        success('$statusCode $url$durationStr', tag: 'HTTP');
      } else if (statusCode >= 400) {
        error('$statusCode $url$durationStr', tag: 'HTTP');
      } else {
        info('$statusCode $url$durationStr', tag: 'HTTP');
      }
      if (body != null) {
        json(body, tag: 'HTTP RESPONSE');
      }
      separator();
    }
  }
}
