import 'package:untitled1/Entities/ProductEntities.dart';

class ProductModel extends ProductEntities{

  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: json['price'],
    );
  }

  // Method to convert ProductModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
    };
  }
}