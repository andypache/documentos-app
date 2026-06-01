import 'package:hdocumentos/src/model/model.dart';

/// Modelo inmutable para optimizar rebuilds del formulario de facturación
/// Solo se reconstruye cuando cambian estos valores específicos
class BillFormData {
  final CustomerModel? selectedCustomer;
  final List<BillItemModel> billItems;
  final List<PaymentMethodModel> paymentMethods;
  final PaymentMethodModel? selectedPaymentMethod;
  final bool isCalculating;
  final bool isLoading;

  const BillFormData({
    required this.selectedCustomer,
    required this.billItems,
    required this.paymentMethods,
    required this.selectedPaymentMethod,
    required this.isCalculating,
    required this.isLoading,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BillFormData &&
        other.selectedCustomer == selectedCustomer &&
        _listEquals(other.billItems, billItems) &&
        _listEquals(other.paymentMethods, paymentMethods) &&
        other.selectedPaymentMethod == selectedPaymentMethod &&
        other.isCalculating == isCalculating &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode =>
      selectedCustomer.hashCode ^
      billItems.hashCode ^
      paymentMethods.hashCode ^
      selectedPaymentMethod.hashCode ^
      isCalculating.hashCode ^
      isLoading.hashCode;

  /// Helper para comparar listas
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
