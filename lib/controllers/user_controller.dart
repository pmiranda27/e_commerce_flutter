import 'package:e_commerce/models/product_model.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:flutter/material.dart';

class UserController with ChangeNotifier {
  List<UserModel> users = [
    UserModel('Gunther', 'gunther@gmail.com', '123'),
    UserModel('Miranda', 'miranda@gmail.com', '123'),
    UserModel('Santhiago', 'santhiago@gmail.com', 'robertao'),
  ];

  int? loggedUserId;

  List<UserModel> getUserList() {
    return users;
  }

  Future<String?> getUserName() async {
    return users[loggedUserId!].nome;
  }

  Future<List<ProductModel>> getFavorites(int userIndex) async {
    return users[userIndex].favorites;
  }

  bool setCurrentUser(String email, String password) {
    final selUser = users.firstWhere((u) => u.email == email);
    if (selUser.password == password) {
      loggedUserId = users.indexWhere((e) => e == selUser);
      return true;
    }
    return false;
  }

  bool logoutCurrentUser() {
    loggedUserId = null;

    if (loggedUserId == null) {
      return true;
    }
    return false;
  }

  bool isFavorited(int userId, ProductModel product) {
    if (users[userId].favorites.contains(product)) {
      return true;
    }
    return false;
  }

  void addToFavorite(int userInd, ProductModel product) {
    if (!users[userInd].favorites.contains(product)) {
      users[userInd].favorites.add(product);
      notifyListeners();
    }
  }

  void removeFromFavorite(int userInd, ProductModel product) {
    if (users[userInd].favorites.contains(product)) {
      users[userInd].favorites.remove(product);
      notifyListeners();
    }
  }

  void addToCart(int userInd, ProductModel product) {
    users[userInd].products.add(product);
    notifyListeners();
  }

  void removeFromCart(int userInd, ProductModel product) {
    if (users[userInd].products.contains(product)) {
      users[userInd].products.remove(product);
      notifyListeners();
    }
  }

  void clearCart(int userId) {
    if (users[userId].products.isNotEmpty) {
      users[userId].products.clear();
      notifyListeners();
    }
  }

  Future<List<ProductModel>> getCart(int userIndex) async {
    return users[userIndex].products;
  }
}
