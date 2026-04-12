class ProductAttribute {
  String name;
  List<String> values;

  ProductAttribute({
    required this.name,
    required this.values,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      name: json['name'],
      values: List<String>.from(json['value']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "value": values,
    };
  }
}