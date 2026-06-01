import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/exception/app_exceptions.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/share/app_logger.dart';

/// Handler centralizado para manejo de errores en toda la aplicación
class ErrorHandler {
  /// Procesar excepción y convertirla a un mensaje amigable
  static String getErrorMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    }

    if (error is SocketException) {
      return 'No hay conexión a Internet. Verifica tu conexión.';
    }

    if (error is HttpException) {
      return 'Error de comunicación con el servidor.';
    }

    if (error is FormatException) {
      return 'Error en el formato de datos recibidos.';
    }

    if (error is TimeoutException) {
      return 'La solicitud ha excedido el tiempo de espera.';
    }

    // Error genérico
    return 'Ha ocurrido un error inesperado. Intenta nuevamente.';
  }

  /// Manejar error y mostrar notificación al usuario
  static void handleError(
    dynamic error, {
    BuildContext? context,
    String? customMessage,
    bool showNotification = true,
    VoidCallback? onRetry,
  }) {
    // Loguear el error
    if (error is AppException) {
      AppLogger.error(
        'AppException: ${error.message}',
        error: error.originalError,
        stackTrace: error.stackTrace,
        tag: 'ErrorHandler',
      );
    } else {
      AppLogger.error(
        'Unhandled error: ${error.toString()}',
        error: error,
        tag: 'ErrorHandler',
      );
    }

    // Mostrar notificación si está habilitado
    if (showNotification) {
      final message = customMessage ?? getErrorMessage(error);

      // Mostrar según tipo de error
      if (error is AuthException) {
        NotificationService.showSnackbarWarning(message);
      } else if (error is ValidationException) {
        NotificationService.showSnackbarWarning(message);
      } else if (error is NetworkException) {
        NotificationService.showSnackbarError(message);
      } else {
        NotificationService.showSnackbarError(message);
      }
    }
  }

  /// Convertir error HTTP en excepción específica
  static AppException fromHttpError(int statusCode, String? message) {
    final errorMessage = message ?? 'Error en la solicitud';

    switch (statusCode) {
      case 400:
        return ServerException.badRequest(errorMessage);
      case 401:
        return AuthException.unauthorized();
      case 403:
        return AuthException.forbidden();
      case 404:
        return ServerException.notFound(errorMessage);
      case 408:
        return NetworkException.timeout();
      case 429:
        return const ServerException(
          message: 'Demasiadas solicitudes. Intenta más tarde.',
          code: 'TOO_MANY_REQUESTS',
          statusCode: 429,
        );
      case 500:
        return ServerException.internalError();
      case 502:
      case 503:
        return ServerException.serviceUnavailable();
      case 504:
        return NetworkException.timeout();
      default:
        if (statusCode >= 500) {
          return ServerException(
            message: 'Error del servidor ($statusCode)',
            code: 'SERVER_ERROR',
            statusCode: statusCode,
          );
        } else if (statusCode >= 400) {
          return ServerException(
            message: errorMessage,
            code: 'CLIENT_ERROR',
            statusCode: statusCode,
          );
        }
        return ServerException(
          message: errorMessage,
          statusCode: statusCode,
        );
    }
  }

  /// Ejecutar función con manejo automático de errores
  static Future<T?> tryExecute<T>({
    required Future<T> Function() action,
    BuildContext? context,
    String? errorMessage,
    bool showNotification = true,
    T? defaultValue,
  }) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      handleError(
        error,
        context: context,
        customMessage: errorMessage,
        showNotification: showNotification,
      );

      if (error is! AppException) {
        AppLogger.error(
          'Unexpected error in tryExecute',
          error: error,
          stackTrace: stackTrace,
          tag: 'ErrorHandler',
        );
      }

      return defaultValue;
    }
  }

  /// Ejecutar función sincrónica con manejo de errores
  static T? tryExecuteSync<T>({
    required T Function() action,
    BuildContext? context,
    String? errorMessage,
    bool showNotification = true,
    T? defaultValue,
  }) {
    try {
      return action();
    } catch (error, stackTrace) {
      handleError(
        error,
        context: context,
        customMessage: errorMessage,
        showNotification: showNotification,
      );

      AppLogger.error(
        'Error in tryExecuteSync',
        error: error,
        stackTrace: stackTrace,
        tag: 'ErrorHandler',
      );

      return defaultValue;
    }
  }
}

/// Excepción de timeout personalizada
class TimeoutException extends NetworkException {
  const TimeoutException()
      : super(
          message: 'La solicitud ha excedido el tiempo de espera.',
          code: 'TIMEOUT',
        );
}
