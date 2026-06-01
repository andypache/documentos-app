/// Excepción base para todas las excepciones personalizadas de la app
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    if (code != null) {
      return 'AppException [$code]: $message';
    }
    return 'AppException: $message';
  }
}

/// Excepciones relacionadas con la red
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory NetworkException.noInternet() {
    return const NetworkException(
      message: 'No hay conexión a Internet. Verifica tu conexión.',
      code: 'NO_INTERNET',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'La solicitud ha excedido el tiempo de espera.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.serverUnavailable() {
    return const NetworkException(
      message: 'El servidor no está disponible. Intenta más tarde.',
      code: 'SERVER_UNAVAILABLE',
    );
  }

  @override
  String toString() =>
      'NetworkException${code != null ? ' [$code]' : ''}: $message';
}

/// Excepciones relacionadas con autenticación
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AuthException.unauthorized() {
    return const AuthException(
      message: 'No autorizado. Inicia sesión nuevamente.',
      code: 'UNAUTHORIZED',
    );
  }

  factory AuthException.forbidden() {
    return const AuthException(
      message: 'No tienes permisos para realizar esta acción.',
      code: 'FORBIDDEN',
    );
  }

  factory AuthException.sessionExpired() {
    return const AuthException(
      message: 'Tu sesión ha expirado. Inicia sesión nuevamente.',
      code: 'SESSION_EXPIRED',
    );
  }

  @override
  String toString() =>
      'AuthException${code != null ? ' [$code]' : ''}: $message';
}

/// Excepciones relacionadas con validación de datos
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });

  factory ValidationException.invalidData(String field, String error) {
    return ValidationException(
      message: 'Datos inválidos en el campo: $field',
      code: 'INVALID_DATA',
      fieldErrors: {field: error},
    );
  }

  factory ValidationException.requiredField(String field) {
    return ValidationException(
      message: 'El campo $field es requerido.',
      code: 'REQUIRED_FIELD',
      fieldErrors: {field: 'Campo requerido'},
    );
  }

  @override
  String toString() {
    String baseMessage =
        'ValidationException${code != null ? ' [$code]' : ''}: $message';
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      baseMessage +=
          '\nErrores: ${fieldErrors!.entries.map((e) => '${e.key}: ${e.value}').join(', ')}';
    }
    return baseMessage;
  }
}

/// Excepciones relacionadas con el servidor/API
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required super.message,
    super.code,
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });

  factory ServerException.badRequest(String message) {
    return ServerException(
      message: message,
      code: 'BAD_REQUEST',
      statusCode: 400,
    );
  }

  factory ServerException.notFound(String resource) {
    return ServerException(
      message: 'No se encontró: $resource',
      code: 'NOT_FOUND',
      statusCode: 404,
    );
  }

  factory ServerException.internalError() {
    return const ServerException(
      message: 'Error interno del servidor. Intenta más tarde.',
      code: 'INTERNAL_ERROR',
      statusCode: 500,
    );
  }

  factory ServerException.serviceUnavailable() {
    return const ServerException(
      message: 'Servicio no disponible temporalmente.',
      code: 'SERVICE_UNAVAILABLE',
      statusCode: 503,
    );
  }

  @override
  String toString() {
    String baseMessage = 'ServerException';
    if (statusCode != null) {
      baseMessage += ' [$statusCode]';
    }
    if (code != null) {
      baseMessage += ' [$code]';
    }
    return '$baseMessage: $message';
  }
}

/// Excepciones relacionadas con la lógica de negocio
class BusinessException extends AppException {
  const BusinessException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory BusinessException.stockInsufficient(String itemName, int available) {
    return BusinessException(
      message: 'Stock insuficiente para $itemName. Disponible: $available',
      code: 'INSUFFICIENT_STOCK',
    );
  }

  factory BusinessException.invalidOperation(String operation) {
    return BusinessException(
      message: 'Operación no válida: $operation',
      code: 'INVALID_OPERATION',
    );
  }

  @override
  String toString() =>
      'BusinessException${code != null ? ' [$code]' : ''}: $message';
}

/// Excepciones relacionadas con caché o almacenamiento local
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory CacheException.notFound(String key) {
    return CacheException(
      message: 'No se encontró el dato en caché: $key',
      code: 'CACHE_NOT_FOUND',
    );
  }

  factory CacheException.writeError() {
    return const CacheException(
      message: 'Error al escribir en caché.',
      code: 'CACHE_WRITE_ERROR',
    );
  }

  @override
  String toString() =>
      'CacheException${code != null ? ' [$code]' : ''}: $message';
}
