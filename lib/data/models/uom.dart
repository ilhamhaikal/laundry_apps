class Uom {
  final String id;
  final String name;

  Uom({required this.id, required this.name});

  factory Uom.fromJson(Map<String, dynamic> json) {
    return Uom(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
