import 'dart:convert';

class Product {
  Product({
    this.id,
    required this.available,
    required this.name,
    this.picture,
    required this.price,
  });

  String? id;
  bool available;
  String name;
  String? picture;
  double price;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
      };

  Product copy() => Product(
      available: this.available,
      name: this.name,
      price: this.price,
      picture: this.picture,
      id: this.id);
}
