import 'package:e_commerce/models/product_model.dart';

class UserModel {
  String? nome;
  String? email;
  String? password;
  List<ProductModel> products = [];
  List<ProductModel> favorites = [];

  UserModel(this.nome, this.email, this.password);
}
