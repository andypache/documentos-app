/// Modelo para crear una venta en el sistema
class SaleCreateRequestModel {
  final String username;
  final String companyId;
  final String companyUserId;
  final bool noData;
  final String establishmentNumber;
  final String emissionPoint;
  final CustomerSaleModel customer;
  final double subtotal;
  final double discount;
  final double discountItem;
  final double discountValue;
  final double totalTax;
  final double total;
  final double subtotalWithoutTax;
  final List<TotalTaxListModel> totalTaxList;
  final List<SaleDetailModel> saleDetails;
  final List<PaymentMethodDetailModel> paymentMethodDetails;

  SaleCreateRequestModel({
    required this.username,
    required this.companyId,
    required this.companyUserId,
    required this.noData,
    required this.establishmentNumber,
    required this.emissionPoint,
    required this.customer,
    required this.subtotal,
    required this.discount,
    required this.discountItem,
    required this.discountValue,
    required this.totalTax,
    required this.total,
    required this.subtotalWithoutTax,
    required this.totalTaxList,
    required this.saleDetails,
    required this.paymentMethodDetails,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'company_id': companyId,
        'company_user_id': companyUserId,
        'no_data': noData,
        'establishment_number': establishmentNumber,
        'emission_point': emissionPoint,
        'customer': customer.toJson(),
        'subtotal': subtotal,
        'discount': discount,
        'discount_item': discountItem,
        'discount_value': discountValue,
        'total_tax': totalTax,
        'total': total,
        'subtotal_without_tax': subtotalWithoutTax,
        'total_tax_list': totalTaxList.map((e) => e.toJson()).toList(),
        'sale_details': saleDetails.map((e) => e.toJson()).toList(),
        'payment_method_details':
            paymentMethodDetails.map((e) => e.toJson()).toList(),
      };
}

/// Modelo de cliente para la venta
class CustomerSaleModel {
  final String identificationType;
  final String identification;
  final String businessName;
  final String name;
  final String surname;
  final String lastname;
  final String telephone;
  final String location;
  final String email;

  CustomerSaleModel({
    required this.identificationType,
    required this.identification,
    required this.businessName,
    required this.name,
    required this.surname,
    required this.lastname,
    required this.telephone,
    required this.location,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'identification_type': identificationType,
        'identification': identification,
        'business_name': businessName,
        'name': name,
        'surname': surname,
        'lastname': lastname,
        'telephone': telephone,
        'location': location,
        'email': email,
      };
}

/// Modelo de impuesto total
class TotalTaxListModel {
  final String companySaleParameterId;
  final double calculationSubtotal;
  final double taxPercentage;
  final double taxValue;

  TotalTaxListModel({
    required this.companySaleParameterId,
    required this.calculationSubtotal,
    required this.taxPercentage,
    required this.taxValue,
  });

  Map<String, dynamic> toJson() => {
        'company_sale_parameter_id': companySaleParameterId,
        'calculation_subtotal': calculationSubtotal,
        'tax_percentage': taxPercentage,
        'tax_value': taxValue,
      };
}

/// Modelo de detalle de venta
class SaleDetailModel {
  final String itemId;
  final int amount;
  final double price;
  final double cost;
  final String description;
  final double discount;
  final double discountValue;
  final double total;
  final double totalDiscount;
  final bool inventory;
  final List<TaxListModel> taxList;

  SaleDetailModel({
    required this.itemId,
    required this.amount,
    required this.price,
    required this.cost,
    required this.description,
    required this.discount,
    required this.discountValue,
    required this.total,
    required this.totalDiscount,
    required this.inventory,
    required this.taxList,
  });

  Map<String, dynamic> toJson() => {
        'item_id': itemId,
        'amount': amount,
        'price': price,
        'cost': cost,
        'description': description,
        'discount': discount,
        'discount_value': discountValue,
        'total': total,
        'total_discount': totalDiscount,
        'inventory': inventory,
        'tax_list': taxList.map((e) => e.toJson()).toList(),
      };
}

/// Modelo de impuesto por item
class TaxListModel {
  final String companySaleParameterId;
  final double calculationSubtotal;
  final double taxPercentage;
  final double taxValue;

  TaxListModel({
    required this.companySaleParameterId,
    required this.calculationSubtotal,
    required this.taxPercentage,
    required this.taxValue,
  });

  Map<String, dynamic> toJson() => {
        'company_sale_parameter_id': companySaleParameterId,
        'calculation_subtotal': calculationSubtotal,
        'tax_percentage': taxPercentage,
        'tax_value': taxValue,
      };
}

/// Modelo de detalle de método de pago
class PaymentMethodDetailModel {
  final String companyPaymentMethodId;
  final double value;

  PaymentMethodDetailModel({
    required this.companyPaymentMethodId,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
        'company_payment_method_id': companyPaymentMethodId,
        'value': value,
      };
}
