/// Modelo liviano para el endpoint `bills/last-sales`.
///
/// Contiene sólo los campos que el listado de últimas ventas necesita mostrar
/// (resumen por factura). No es el mismo que [BillModel], que representa una
/// factura completa con ítems.
class LastSaleModel {
  final String? id;
  final String? accessKey;
  final DateTime? date;
  final String? customerName;
  final String? customerIdentification;
  final double subtotal;
  final double total;
  final int itemCount;
  final String? status;

  const LastSaleModel({
    this.id,
    this.accessKey,
    this.date,
    this.customerName,
    this.customerIdentification,
    this.subtotal = 0.0,
    this.total = 0.0,
    this.itemCount = 0,
    this.status,
  });

  factory LastSaleModel.fromJson(Map<String, dynamic> json) {
    return LastSaleModel(
      id: json['id'] as String?,
      accessKey: json['accessKey'] as String?,
      date: json['date'] != null ? _parseDate(json['date']) : null,
      customerName: json['customerName'] as String? ??
          json['customer']?['name'] as String?,
      customerIdentification: json['customerIdentification'] as String? ??
          json['customer']?['identification'] as String?,
      subtotal: _toDouble(json['subtotal']),
      total: _toDouble(json['total']),
      itemCount: (json['itemCount'] as num?)?.toInt() ??
          (json['items'] as List?)?.length ??
          0,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'accessKey': accessKey,
        'date': date?.toIso8601String(),
        'customerName': customerName,
        'customerIdentification': customerIdentification,
        'subtotal': subtotal,
        'total': total,
        'itemCount': itemCount,
        'status': status,
      };

  // ─── Helpers ──────────────────────────────────────────────────────────────

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
