class PaymentMethodModel {
  final int id;
  final String name;
  final bool isActive;

  PaymentMethodModel({
    required this.id,
    required this.name,
    this.isActive = true,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as int,
      name: json['name'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return 'PaymentMethodModel{id: $id, name: $name, isActive: $isActive}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentMethodModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
