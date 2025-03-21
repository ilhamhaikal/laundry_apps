class Product {
  final String id;
  final String name;
  final int price;
  final String uomId;
  final String uomName;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.uomId,
    required this.uomName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final uom = json['uom'] as Map<String, dynamic>? ?? {};

    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      uomId: json['uom_id'] ?? uom['id'] ?? '',
      uomName: uom['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'uom_id': uomId.trim(), // Ensure no whitespace
    };
  }
}
