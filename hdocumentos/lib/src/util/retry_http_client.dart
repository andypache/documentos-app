import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hdocumentos/src/config/environment_config.dart';
import 'package:hdocumentos/src/exception/app_exceptions.dart';
import 'package:hdocumentos/src/share/app_logger.dart';

/// Cliente HTTP con retry policy y manejo de errores
class RetryHttpClient extends http.BaseClient {
  final http.Client _inner;
  final EnvironmentConfig config;

  RetryHttpClient({
    http.Client? client,
    EnvironmentConfig? config,
  })  : _inner = client ?? http.Client(),
        config = config ?? EnvironmentConfig.current;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return _sendWithRetry(request, 0);
  }

  Future<http.StreamedResponse> _sendWithRetry(
    http.BaseRequest request,
    int attemptNumber,
  ) async {
    try {
      AppLogger.debug(
        'HTTP Request [Attempt ${attemptNumber + 1}]: ${request.method} ${request.url}',
        tag: 'RetryHttpClient',
      );

      // Agregar timeout
      final response = await _inner
          .send(request)
          .timeout(Duration(seconds: config.apiTimeout));

      AppLogger.debug(
        'HTTP Response: ${response.statusCode} ${request.method} ${request.url}',
        tag: 'RetryHttpClient',
      );

      // Verificar si se debe reintentar basado en el código de estado
      if (_shouldRetry(response.statusCode, attemptNumber)) {
        final delay = config.getExponentialBackoffDelay(attemptNumber + 1);

        AppLogger.warning(
          'Retrying request after ${delay}ms (attempt ${attemptNumber + 2}/${config.maxRetries + 1})',
          tag: 'RetryHttpClient',
        );

        await Future.delayed(Duration(milliseconds: delay));

        // Crear nueva request (la original ya fue consumida)
        final newRequest = _copyRequest(request);
        return _sendWithRetry(newRequest, attemptNumber + 1);
      }

      return response;
    } on SocketException catch (e, stackTrace) {
      AppLogger.error(
        'SocketException: ${e.message}',
        error: e,
        stackTrace: stackTrace,
        tag: 'RetryHttpClient',
      );

      if (_canRetry(attemptNumber)) {
        final delay = config.getExponentialBackoffDelay(attemptNumber + 1);
        AppLogger.warning(
          'Retrying after connection error (attempt ${attemptNumber + 2}/${config.maxRetries + 1})',
          tag: 'RetryHttpClient',
        );

        await Future.delayed(Duration(milliseconds: delay));
        final newRequest = _copyRequest(request);
        return _sendWithRetry(newRequest, attemptNumber + 1);
      }

      throw NetworkException.noInternet();
    } on TimeoutException catch (e, stackTrace) {
      AppLogger.error(
        'TimeoutException after ${config.apiTimeout}s',
        error: e,
        stackTrace: stackTrace,
        tag: 'RetryHttpClient',
      );

      if (_canRetry(attemptNumber)) {
        final delay = config.getExponentialBackoffDelay(attemptNumber + 1);
        AppLogger.warning(
          'Retrying after timeout (attempt ${attemptNumber + 2}/${config.maxRetries + 1})',
          tag: 'RetryHttpClient',
        );

        await Future.delayed(Duration(milliseconds: delay));
        final newRequest = _copyRequest(request);
        return _sendWithRetry(newRequest, attemptNumber + 1);
      }

      throw NetworkException.timeout();
    } on HttpException catch (e, stackTrace) {
      AppLogger.error(
        'HttpException: ${e.message}',
        error: e,
        stackTrace: stackTrace,
        tag: 'RetryHttpClient',
      );

      if (_canRetry(attemptNumber)) {
        final delay = config.getExponentialBackoffDelay(attemptNumber + 1);
        await Future.delayed(Duration(milliseconds: delay));
        final newRequest = _copyRequest(request);
        return _sendWithRetry(newRequest, attemptNumber + 1);
      }

      throw NetworkException(
        message: 'Error HTTP: ${e.message}',
        code: 'HTTP_ERROR',
        originalError: e,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in HTTP request',
        error: e,
        stackTrace: stackTrace,
        tag: 'RetryHttpClient',
      );

      throw NetworkException(
        message: 'Error inesperado en la solicitud: ${e.toString()}',
        code: 'UNKNOWN_ERROR',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Verificar si se debe reintentar basado en el código de estado
  bool _shouldRetry(int statusCode, int attemptNumber) {
    return config.shouldRetry(statusCode) && _canRetry(attemptNumber);
  }

  /// Verificar si aún se pueden hacer reintentos
  bool _canRetry(int attemptNumber) {
    return config.enableRetry && attemptNumber < config.maxRetries;
  }

  /// Copiar request para reintento (necesario porque BaseRequest es de un solo uso)
  http.BaseRequest _copyRequest(http.BaseRequest request) {
    http.BaseRequest newRequest;

    if (request is http.Request) {
      newRequest = http.Request(request.method, request.url)
        ..encoding = request.encoding
        ..bodyBytes = request.bodyBytes;
    } else if (request is http.MultipartRequest) {
      newRequest = http.MultipartRequest(request.method, request.url)
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);
    } else if (request is http.StreamedRequest) {
      throw UnsupportedError(
        'StreamedRequest cannot be retried. Use Request or MultipartRequest instead.',
      );
    } else {
      throw UnsupportedError(
        'Unknown request type: ${request.runtimeType}',
      );
    }

    newRequest.headers.addAll(request.headers);
    return newRequest;
  }

  @override
  void close() {
    _inner.close();
  }
}

/// Extension para facilitar el uso con response
extension HttpResponseExtension on http.Response {
  /// Verificar si la respuesta fue exitosa (200-299)
  bool get isSuccessful => statusCode >= 200 && statusCode < 300;

  /// Verificar si es error de cliente (400-499)
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Verificar si es error de servidor (500-599)
  bool get isServerError => statusCode >= 500 && statusCode < 600;
}
