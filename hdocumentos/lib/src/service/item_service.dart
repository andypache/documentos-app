import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/constant.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/form/item_form_provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/share/preference.dart';

/// Servicio para operaciones CRUD de items
class ItemService {
  /// Construye el payload de creación según el contrato del API:
  /// POST /document-service/item-service/items/create
  static Map<String, dynamic> _buildCreatePayload(ItemFormProvider form) {
    final companyId = Preferences.userSession.company?.companyId ?? '';

    return {
      "company_id": companyId,
      "name": form.name,
      "description": form.description.isEmpty ? null : form.description,
      "search_key": form.searchKey.isEmpty ? null : form.searchKey,
      "is_service": form.isService,
      "stock": {
        "quantity": form.isService ? 1 : form.stock,
      },
      if (form.image != null)
        "media": {
          "image":
              form.image != null ? base64Encode(form.image as Uint8List) : "",
        },
      "pricing": {
        "price": form.price,
        if (form.cost > 0) "cost": form.cost,
        if (form.discount > 0) "discount": form.discount,
      },
      if (form.itemTaxList.isNotEmpty)
        "item_taxes": form.itemTaxList
            .map((tax) => {
                  "company_sale_parameter_id": tax.idCompanySaleParameter ?? "",
                })
            .toList(),
    };
  }

  /// Crea un nuevo item.
  /// Retorna el [ItemModel] creado o lanza excepción.
  static Future<ItemModel> createItem(
      BuildContext context, ItemFormProvider form) async {
    final payload = _buildCreatePayload(form);

    final response = await postFetch(
      context: context,
      url: apiItemCreate,
      body: payload,
    );

    if (response.statusHttp == 200 || response.statusHttp == 201) {
      final data = response.createDataResponse();
      return ItemModel.fromJson(data.response);
    }

    throw Exception(await _parseResponseError(response));
  }

  /// Actualiza un item existente.
  static Future<ItemModel> updateItem(
      BuildContext context, ItemFormProvider form) async {
    final companyId = Preferences.userSession.company?.companyId ?? '';

    final payload = {
      "company_id": companyId,
      "item_id": form.item.id,
      "name": form.name,
      "description": form.description.isEmpty ? null : form.description,
      "search_key": form.searchKey.isEmpty ? null : form.searchKey,
      "is_service": form.isService,
      "stock": {
        "quantity": form.isService ? 0 : form.stock,
      },
      if (form.image != null)
        "media": {
          "image":
              form.image != null ? base64Encode(form.image as Uint8List) : "",
        },
      "pricing": {
        "price": form.price,
        if (form.cost > 0) "cost": form.cost,
        if (form.discount > 0) "discount": form.discount,
      },
      if (form.itemTaxList.isNotEmpty)
        "item_taxes": form.itemTaxList
            .map((tax) => {
                  "company_sale_parameter_id": tax.idCompanySaleParameter ?? "",
                })
            .toList(),
    };

    final response = await putFetch(
      context: context,
      url: apiItemUpdate,
      body: payload,
    );

    if (response.statusHttp == 200 || response.statusHttp == 201) {
      final data = response.createDataResponse();
      return ItemModel.fromJson(data.response);
    }

    throw Exception(await _parseResponseError(response));
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
    return NotificationService.l10n?.itemDataProcessError ??
        'Error al procesar la operación de item';
  }
}
