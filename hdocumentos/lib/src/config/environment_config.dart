/// Configuración de ambientes de la aplicación
/// Define parámetros para dev, staging y producción
class EnvironmentConfig {
  final String name;
  final String baseUrl;
  final int apiTimeout; // en segundos
  final int maxRetries;
  final int retryDelay; // en milisegundos
  final bool enableLogs;
  final String logLevel; // 'debug', 'info', 'warning', 'error'
  final bool enableRetry;
  final List<int> retryStatusCodes; // Códigos HTTP que disparan retry

  const EnvironmentConfig({
    required this.name,
    required this.baseUrl,
    required this.apiTimeout,
    required this.maxRetries,
    required this.retryDelay,
    required this.enableLogs,
    required this.logLevel,
    required this.enableRetry,
    required this.retryStatusCodes,
  });

  /// Ambiente de desarrollo
  static const EnvironmentConfig development = EnvironmentConfig(
    name: 'development',
    baseUrl: 'https://dev-api.example.com',
    apiTimeout: 30,
    maxRetries: 3,
    retryDelay: 1000, // 1 segundo
    enableLogs: true,
    logLevel: 'debug',
    enableRetry: true,
    retryStatusCodes: [408, 429, 500, 502, 503, 504],
  );

  /// Ambiente de staging/pruebas
  static const EnvironmentConfig staging = EnvironmentConfig(
    name: 'staging',
    baseUrl: 'https://staging-api.example.com',
    apiTimeout: 25,
    maxRetries: 2,
    retryDelay: 1500, // 1.5 segundos
    enableLogs: true,
    logLevel: 'info',
    enableRetry: true,
    retryStatusCodes: [408, 429, 500, 502, 503, 504],
  );

  /// Ambiente de producción
  static const EnvironmentConfig production = EnvironmentConfig(
    name: 'production',
    baseUrl: 'https://api.example.com',
    apiTimeout: 20,
    maxRetries: 2,
    retryDelay: 2000, // 2 segundos
    enableLogs: false,
    logLevel: 'error',
    enableRetry: true,
    retryStatusCodes: [408, 500, 502, 503, 504],
  );

  /// Obtener el ambiente actual (por defecto development)
  /// Se puede configurar con --dart-define=ENVIRONMENT=staging
  static EnvironmentConfig get current {
    const environment =
        String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');

    switch (environment) {
      case 'staging':
        return staging;
      case 'production':
        return production;
      case 'development':
      default:
        return development;
    }
  }

  /// Calcular delay con exponential backoff
  /// attemptNumber: 1, 2, 3, etc.
  int getExponentialBackoffDelay(int attemptNumber) {
    // Formula: baseDelay * 2^(attemptNumber - 1)
    // Ejemplo con retryDelay=1000ms:
    // Intento 1: 1000ms
    // Intento 2: 2000ms
    // Intento 3: 4000ms
    return retryDelay * (1 << (attemptNumber - 1));
  }

  /// Verificar si un código de estado debe reintentar
  bool shouldRetry(int statusCode) {
    return enableRetry && retryStatusCodes.contains(statusCode);
  }

  @override
  String toString() {
    return 'EnvironmentConfig(name: $name, baseUrl: $baseUrl, timeout: ${apiTimeout}s, maxRetries: $maxRetries)';
  }
}
