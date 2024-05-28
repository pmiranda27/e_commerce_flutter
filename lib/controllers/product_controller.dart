import 'package:e_commerce/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductController with ChangeNotifier {
  final List<ProductModel> produtos = [
    ProductModel('Moletom', 60.00, 'Moletom Legal'),
    ProductModel('Mouse Gamer', 150.00, 'Mouse Maneiro'),
    ProductModel('Teclado Gamer', 250.00, 'Teclado Radical'),
    ProductModel('Headset Gamer', 100.00, 'Headset Fofo'),
  ];
}
