class ProductVariation {
  String pic;
  String price;
  String realPrice;

  ProductVariation({
    required this.pic,
    required this.price,
    required this.realPrice,
  });

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      pic: json['pic'],
      price: json['price'],
      realPrice: json['realprice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pic": pic,
      "price": price,
      "realprice": realPrice,
    };
  }
}