import 'package:flashchat/Tmart/model/product_attribute.dart';
import 'package:flashchat/Tmart/model/product_variation.dart';


class Product {
  String name;
  String brand;
  String brandLogo;
  String category;
  int quantity;
  double totalRating;
  int totalReviews;

  List<ProductAttribute> attributes;
  List<ProductVariation> variations;

  Product({
    required this.name,
    required this.brand,
    required this.brandLogo,
    required this.category,
    required this.quantity,
    required this.totalRating,
    required this.totalReviews,
    required this.attributes,
    required this.variations,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      brand: json['brand'],
      brandLogo: json['brandLogo'],
      category: json['category'],
      quantity: json['quantity'],
      totalRating: (json['totalRating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
      attributes: (json['attributes'] as List)
          .map((e) => ProductAttribute.fromJson(e))
          .toList(),
      variations: (json['variation'] as List)
          .map((e) => ProductVariation.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "brand": brand,
      "brandLogo": brandLogo,
      "category": category,
      "quantity": quantity,
      "totalRating": totalRating,
      "totalReviews": totalReviews,
      "attributes": attributes.map((e) => e.toJson()).toList(),
      "variation": variations.map((e) => e.toJson()).toList(),
    };
  }
}