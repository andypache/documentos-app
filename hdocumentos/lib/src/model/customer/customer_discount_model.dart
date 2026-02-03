///Class to represent Customer Discount configuration
class CustomerDiscountModel {
  String? customerDiscountId;
  DateTime? startDate;
  DateTime? endDate;
  String? isVariable; // 'Y' or 'N'
  int? discountValue;
  String? status; // 'A' or 'I'

  //Constructor class
  CustomerDiscountModel({
    this.customerDiscountId,
    this.startDate,
    this.endDate,
    this.isVariable,
    this.discountValue,
    this.status,
  });

  //Create empty customer discount
  factory CustomerDiscountModel.createEmpty() {
    return CustomerDiscountModel(
      isVariable: 'N',
      discountValue: 0,
      status: 'A',
    );
  }

  //Load from json response
  factory CustomerDiscountModel.fromJson(Map<String, dynamic> json) =>
      CustomerDiscountModel(
        customerDiscountId: json["customer_discount_id"],
        startDate: json["start_date"] != null
            ? DateTime.parse(json["start_date"])
            : null,
        endDate:
            json["end_date"] != null ? DateTime.parse(json["end_date"]) : null,
        isVariable: json["is_variable"],
        discountValue: json["discount_value"],
        status: json["status"],
      );

  //Create object map with property to json
  Map<String, dynamic> toJson() => {
        "customer_discount_id": customerDiscountId,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "is_variable": isVariable,
        "discount_value": discountValue,
        "status": status,
      };
}
