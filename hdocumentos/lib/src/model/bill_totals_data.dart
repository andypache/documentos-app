/// Modelo inmutable para optimizar rebuilds del panel de totales
/// Solo se reconstruye cuando cambian estos valores específicos
class BillTotalsData {
  final double subtotal;
  final double customerDiscount;
  final double itemDiscount;
  final double discountTotal;
  final double totalTax;
  final double total;
  final bool isCalculating;
  final bool canSave;
  final String? customerDiscountLabel;

  const BillTotalsData({
    required this.subtotal,
    required this.customerDiscount,
    required this.itemDiscount,
    required this.discountTotal,
    required this.totalTax,
    required this.total,
    required this.isCalculating,
    required this.canSave,
    this.customerDiscountLabel,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BillTotalsData &&
        other.subtotal == subtotal &&
        other.customerDiscount == customerDiscount &&
        other.itemDiscount == itemDiscount &&
        other.discountTotal == discountTotal &&
        other.totalTax == totalTax &&
        other.total == total &&
        other.isCalculating == isCalculating &&
        other.canSave == canSave &&
        other.customerDiscountLabel == customerDiscountLabel;
  }

  @override
  int get hashCode {
    return Object.hash(
      subtotal,
      customerDiscount,
      itemDiscount,
      discountTotal,
      totalTax,
      total,
      isCalculating,
      canSave,
      customerDiscountLabel,
    );
  }
}
