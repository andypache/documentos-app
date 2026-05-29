import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/constant/constant.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/service.dart';

/// Servicio para manejar operaciones relacionadas con facturas
class BillService {
  /// Calcula la venta usando la API real del servicio de ventas
  ///
  /// Endpoint: GET {apiSaleCalculate}
  static Future<SaleCalculateResponseModel?> calculateSale({
    required BuildContext context,
    required SaleCalculateRequestModel request,
  }) async {
    try {
      print('DEBUG: BillService.calculateSale - Enviando request...');
      print('DEBUG: URL: $apiSaleCalculate');
      print('DEBUG: Body: ${request.toJson()}');

      ServiceResponseModel response = await postFetch(
        context: context,
        url: apiSaleCalculate,
        body: request.toJson(),
      );

      print('DEBUG: Response recibido:');
      print('  - statusHttp: ${response.statusHttp}');
      print('  - body es null: ${response.body == null}');
      if (response.body != null) {
        print('  - body: ${response.body}');
      }

      if (response.statusHttp == 201 && response.body != null) {
        // Extraer el objeto 'response' del body
        final bodyMap = response.body as Map<String, dynamic>;
        final responseData = bodyMap['response'] as Map<String, dynamic>?;

        if (responseData == null) {
          print('DEBUG: ERROR - No se encontró el campo "response" en el body');
          return null;
        }

        final result = SaleCalculateResponseModel.fromJson(responseData);
        print('DEBUG: Modelo parseado exitosamente');
        print('  - detailCalculate.length: ${result.detailCalculate.length}');
        print('  - totalCalculate.total: ${result.totalCalculate.total}');
        return result;
      } else {
        NotificationService.showSnackbarError(
          await _parseResponseError(response),
        );
        return null;
      }
    } catch (e) {
      if (context.mounted) {
        NotificationService.showSnackbarError(
          AppLocalizations.of(context).errorCalculatingSale(e.toString()),
        );
      }
      return null;
    }
  }

  /// Calcula los totales de una factura enviando los datos al servidor
  ///
  /// Envía la lista de items y el cliente (opcional) al endpoint de cálculo
  /// y retorna los totales calculados incluyendo impuestos y descuentos
  static Future<BillCalculationResponseModel?> calculateBill({
    required BuildContext context,
    required BillCalculationRequestModel request,
  }) async {
    try {
      ServiceResponseModel response = await postFetch(
        context: context,
        url: '${apiCompany}bill/calculate',
        body: request.toJson(),
      );

      if (response.statusHttp == 200 && response.body != null) {
        return BillCalculationResponseModel.fromJson(
          response.body as Map<String, dynamic>,
        );
      } else {
        NotificationService.showSnackbarError(
          response.message,
        );
        return null;
      }
    } catch (e) {
      NotificationService.showSnackbarError(
        'Error inesperado al calcular: ${e.toString()}',
      );
      return null;
    }
  }

  /// Obtiene la lista de métodos de pago disponibles
  ///
  /// Consulta al servidor los métodos de pago activos que se pueden
  /// usar para procesar facturas
  static Future<List<PaymentMethodModel>> getPaymentMethods({
    required BuildContext context,
  }) async {
    try {
      ServiceResponseModel response = await postFetch(
        context: context,
        url: '${apiCompany}payment-methods',
        body: {},
      );

      if (response.statusHttp == 200 && response.body != null) {
        final List<dynamic> data = response.body as List<dynamic>;
        return data
            .map((json) =>
                PaymentMethodModel.fromJson(json as Map<String, dynamic>))
            .where((method) => method.isActive)
            .toList();
      } else {
        NotificationService.showSnackbarError(
          response.message,
        );
        return [];
      }
    } catch (e) {
      NotificationService.showSnackbarError(
        'Error inesperado al cargar métodos de pago: ${e.toString()}',
      );
      return [];
    }
  }

  /// Guarda una factura en el servidor
  ///
  /// Envía los datos completos de la factura incluyendo cliente, items,
  /// método de pago y totales para su registro definitivo
  static Future<bool> saveBill({
    required BuildContext context,
    required Map<String, dynamic> billData,
  }) async {
    try {
      ServiceResponseModel response = await postFetch(
        context: context,
        url: '${apiCompany}bill/save',
        body: billData,
      );

      if (response.statusHttp == 200 && response.body != null) {
        NotificationService.showSnackbarSuccess(
          'Factura guardada exitosamente',
        );
        return true;
      } else {
        NotificationService.showSnackbarError(
          response.message,
        );
        return false;
      }
    } catch (e) {
      NotificationService.showSnackbarError(
        'Error inesperado al guardar: ${e.toString()}',
      );
      return false;
    }
  }

  static Future<String> _parseResponseError(
      ServiceResponseModel response) async {
    try {
      final responseModel = response.createDataResponse();
      final data = responseModel.response;
      if (data is Map<String, dynamic> && data.containsKey('error')) {
        return data['error'] as String;
      }
    } catch (_) {
      // Ignorar errores de parsing y retornar mensaje genérico
    }
    return 'Error al procesar la operación de cálculo de factura';
  }
}
