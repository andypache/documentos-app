import 'dart:typed_data';

import 'package:hdocumentos/src/model/model.dart';

class ItemMediaModel {
  String? id;
  String? itemId;
  Uint8List? image;
  ItemMediaModel({this.id, this.itemId, this.image});
  factory ItemMediaModel.fromJson(Map<String, dynamic> json) => ItemMediaModel(
        id: json["id"],
        itemId: json["item_id"],
        image: json["image"] != null ? Uint8List.fromList(json["image"]) : null,
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "image": image != null ? image!.toList() : null,
      };
}

class ItemStockModel {
  String? id;
  String? itemId;
  int? stock;
  String? location; // 'A' (Active) or 'I' (Inactive)
  ItemStockModel({this.id, this.itemId, this.stock, this.location});
  factory ItemStockModel.fromJson(Map<String, dynamic> json) => ItemStockModel(
        id: json["id"],
        itemId: json["item_id"],
        stock: json["stock"],
        location: json["location"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "stock": stock,
        "location": location,
      };
}

class ItemPricingModel {
  String? id;
  String? itemId;
  double? price;
  double? cost;
  double? discount;
  ItemPricingModel(
      {this.id, this.itemId, this.price, this.cost, this.discount});
  factory ItemPricingModel.fromJson(Map<String, dynamic> json) =>
      ItemPricingModel(
        id: json["id"],
        itemId: json["item_id"],
        price: json["price"]?.toDouble(),
        cost: json["cost"]?.toDouble(),
        discount: json["discount"]?.toDouble(),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "price": price,
        "cost": cost,
        "discount": discount,
      };
}

class ItemTaxModel {
  String? iteTaxId;
  String? idCompanySaleParameter;
  CompanySaleParameterModel? companySaleParameter;

  //Constructor class
  ItemTaxModel({
    this.iteTaxId,
    this.idCompanySaleParameter,
    this.companySaleParameter,
  });

  //Create empty item tax
  factory ItemTaxModel.createEmpty() {
    return ItemTaxModel();
  }

  //Load from json response
  factory ItemTaxModel.fromJson(Map<String, dynamic> json) => ItemTaxModel(
        iteTaxId: json["ite_tax_id"],
        idCompanySaleParameter: json["id_company_sale_parameter"],
        companySaleParameter: json["company_sale_parameter"] != null
            ? CompanySaleParameterModel.fromJson(json["company_sale_parameter"])
            : null,
      );

  //Create object map with property to json
  Map<String, dynamic> toJson() => {
        "ite_tax_id": iteTaxId,
        "id_company_sale_parameter": idCompanySaleParameter,
        "company_sale_parameter": companySaleParameter?.toJson(),
      };

  // Helper methods para acceder a los datos del impuesto
  String get name => companySaleParameter?.saleParameter?.name ?? 'Impuesto';

  double get percentage =>
      companySaleParameter?.saleParameter?.numberParameter ?? 0.0;
}

///Class to represent Item into bill
class ItemModel {
  String? id;
  String? companyId;
  String name;
  String? description;
  String? searchKey;
  String? isService; // 'Y' or 'N'
  String? barCode;
  String? qrCode;
  String? state;
  DateTime? createdAt;
  DateTime? updatedAt;
  ItemMediaModel? media;
  ItemStockModel? stock;
  ItemPricingModel? pricing;
  List<ItemTaxModel>? itemTaxes;

  //Constructor class
  ItemModel({
    this.id,
    this.companyId,
    required this.name,
    this.description,
    this.searchKey,
    this.isService,
    this.barCode,
    this.qrCode,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.media,
    this.stock,
    this.pricing,
    this.itemTaxes,
  });

  //Create empty item
  factory ItemModel.createEmpty() {
    return ItemModel(
      name: "",
      state: 'A',
      isService: 'N',
      pricing: ItemPricingModel(price: 0.0, cost: 0.0, discount: 0),
      stock: ItemStockModel(stock: 1),
    );
  }

  //Load from json response
  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json["id"],
        companyId: json["company_id"],
        name: json["name"],
        description: json["description"],
        searchKey: json["search_key"],
        isService: json["is_service"] == true ? 'Y' : 'N',
        barCode: json["bar_code"],
        qrCode: json["qr_code"],
        state: json["state"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        media: json["media"] != null
            ? ItemMediaModel.fromJson(json["media"])
            : null,
        stock: json["stock"] != null
            ? ItemStockModel.fromJson(json["stock"])
            : null,
        pricing: json["pricing"] != null
            ? ItemPricingModel.fromJson(json["pricing"])
            : null,
        itemTaxes: json["item_tax_list"] != null
            ? List<ItemTaxModel>.from(
                json["item_tax_list"].map((x) => ItemTaxModel.fromJson(x)))
            : null,
      );

  //Create object map with property to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "name": name,
        "description": description,
        "search_key": searchKey,
        "is_service": isService,
        "bar_code": barCode,
        "qr_code": qrCode,
        "state": state,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "media": media?.toJson(),
        "stock": stock?.toJson(),
        "pricing": pricing?.toJson(),
        "item_tax_list": itemTaxes != null
            ? List<dynamic>.from(itemTaxes!.map((x) => x.toJson()))
            : null,
      };
}
