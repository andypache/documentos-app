import 'package:hdocumentos/src/util/retry_http_client.dart';
import 'package:hdocumentos/src/config/environment_config.dart';

/// Cliente HTTP global con retry policy
///
/// Uso:
/// ```dart
/// import 'package:hdocumentos/src/service/http_client_provider.dart';
///
/// final response = await httpClient.get(Uri.parse('https://api.example.com'));
/// ```
final RetryHttpClient httpClient = RetryHttpClient(
  config: EnvironmentConfig.current,
);

/// Inicializar cliente HTTP con configuración específica
/// Útil para testing o configuraciones personalizadas
RetryHttpClient createHttpClient({EnvironmentConfig? config}) {
  return RetryHttpClient(config: config ?? EnvironmentConfig.current);
}
