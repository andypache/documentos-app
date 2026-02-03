import 'dart:typed_data';
import 'package:hdocumentos/src/model/item/item_tax_model.dart';

///Class to represent Item into bill
class ItemModel {
  String? itemId;
  String? companyId;
  DateTime? createdAt;
  String name;
  String? description;
  String? searchKey;
  String? isService; // 'Y' or 'N'
  String? barCode;
  String? qrCode;
  double? price;
  double? cost;
  int? discount;
  int? stock;
  Uint8List? image;
  String? imageName;
  String? state; // 'A' (Active) or 'I' (Inactive)
  List<ItemTaxModel>? itemTaxList;

  //Constructor class
  ItemModel({
    this.itemId,
    this.companyId,
    this.createdAt,
    required this.name,
    this.description,
    this.searchKey,
    this.isService,
    this.barCode,
    this.qrCode,
    this.price,
    this.cost,
    this.discount,
    this.stock,
    this.image,
    this.imageName,
    this.state,
    this.itemTaxList,
  });

  //Create empty item
  factory ItemModel.createEmpty() {
    return ItemModel(
      name: "",
      state: 'A',
      isService: 'N',
      price: 0.0,
      cost: 0.0,
      discount: 0,
      stock: 0,
    );
  }

  //Load from json response
  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        itemId: json["item_id"],
        companyId: json["company_id"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        name: json["name"] ?? "",
        description: json["description"],
        searchKey: json["search_key"],
        isService: json["is_service"],
        barCode: json["bar_code"],
        qrCode: json["qr_code"],
        price: json["price"]?.toDouble(),
        cost: json["cost"]?.toDouble(),
        discount: json["discount"],
        stock: json["stock"],
        imageName: json["image_name"],
        state: json["state"],
        itemTaxList: json["item_tax_list"] != null
            ? List<ItemTaxModel>.from(
                json["item_tax_list"].map((x) => ItemTaxModel.fromJson(x)))
            : null,
      );

  //Create object map with property to json
  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "company_id": companyId,
        "created_at": createdAt?.toIso8601String(),
        "name": name,
        "description": description,
        "search_key": searchKey,
        "is_service": isService,
        "bar_code": barCode,
        "qr_code": qrCode,
        "price": price,
        "cost": cost,
        "discount": discount,
        "stock": stock,
        "image_name": imageName,
        "state": state,
        "item_tax_list": itemTaxList?.map((x) => x.toJson()).toList(),
      };
}
