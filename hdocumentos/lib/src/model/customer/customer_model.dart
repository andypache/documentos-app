import 'package:hdocumentos/src/model/customer/customer_discount_model.dart';
import 'package:hdocumentos/src/model/customer/identification_type_model.dart';

///Class to represent Customer
class CustomerModel {
  String? customerId;
  String? identificationTypeId;
  IdentificationTypeModel? identificationType;
  String? identification;
  String? firstName;
  String? lastName;
  String? businessName;
  String? email;
  String? phoneNumber;
  String? address;
  String? customerDiscountId;
  CustomerDiscountModel? customerDiscount;
  String? status; // 'A' or 'I'

  //Constructor class
  CustomerModel({
    this.customerId,
    this.identificationTypeId,
    this.identificationType,
    this.identification,
    this.firstName,
    this.lastName,
    this.businessName,
    this.email,
    this.phoneNumber,
    this.address,
    this.customerDiscountId,
    this.customerDiscount,
    this.status,
  });

  //Create empty customer
  factory CustomerModel.createEmpty() {
    return CustomerModel(
      status: 'A',
    );
  }

  //Load from json response
  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        customerId: json["customer_id"],
        identificationTypeId: json["identification_type_id"],
        identificationType: json["identification_type"] != null
            ? IdentificationTypeModel.fromJson(json["identification_type"])
            : null,
        identification: json["identification"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        businessName: json["business_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        customerDiscountId: json["customer_discount_id"],
        customerDiscount: json["customer_discount"] != null
            ? CustomerDiscountModel.fromJson(json["customer_discount"])
            : null,
        status: json["status"],
      );

  //Create object map with property to json
  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "identification_type_id": identificationTypeId,
        "identification_type": identificationType?.toJson(),
        "identification": identification,
        "first_name": firstName,
        "business_name": businessName,
        "email": email,
        "phone_number": phoneNumber,
        "address": address,
        "customer_discount_id": customerDiscountId,
        "customer_discount": customerDiscount?.toJson(),
        "status": status,
      };

  // Helper method to get display name
  String getDisplayName() {
    if (businessName != null && businessName!.isNotEmpty) {
      return businessName!;
    }
    final parts = <String>[];
    if (firstName != null && firstName!.isNotEmpty) parts.add(firstName!);
    if (lastName != null && lastName!.isNotEmpty) parts.add(lastName!);
    return parts.isNotEmpty ? parts.join(' ') : 'Sin nombre';
  }

  // Helper method to check if it's a company
  bool isCompany() {
    return businessName != null && businessName!.isNotEmpty;
  }
}
