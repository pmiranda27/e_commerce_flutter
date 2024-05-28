import 'package:e_commerce/components/font_style.dart';
import 'package:e_commerce/controllers/user_controller.dart';
import 'package:e_commerce/models/product_model.dart';
import 'package:e_commerce/screens/carrinho.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

SnackBar addItemSnack(String itemName) => SnackBar(
      backgroundColor: Colors.deepPurple,
      duration: const Duration(seconds: 2),
      content: Text('$itemName foi adicionado(a) ao Carrinho!',
          style: titlePoppins(22)),
    );

SnackBar favoriteSnack(String itemName) => SnackBar(
      backgroundColor: Colors.deepPurple,
      duration: const Duration(seconds: 2),
      content: Text('$itemName foi removido(a) dos favoritos!',
          style: titlePoppins(22)),
    );

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos', style: titlePoppins()),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, '/homepage', (_) => false),
            icon: const Icon(
              Icons.arrow_back,
              size: 35,
            )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push((context),
                    MaterialPageRoute(builder: (context) => const Carrinho()));
              },
              icon: const Icon(Icons.shopping_cart, size: 35)),
        ],
      ),
      body: SafeArea(child: Consumer<UserController>(
        builder: (context, userController, child) {
          return FutureBuilder<List<ProductModel>>(
              future: userProvider.getFavorites(0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  List<ProductModel> favorites = snapshot.data!;
                  if (favorites.isEmpty) {
                    print("Favorites tá vazio");
                    return Center(
                        child: Text("Sem Favoritos",
                            style: titlePoppins(28, Colors.grey)));
                  }
                  return ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.deepPurple[400],
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(favorites[index].nome!,
                                      style: tilePoppins(22)),
                                  Text(favorites[index].desc!,
                                      style: tilePoppins(17)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                      'R\$${favorites[index].preco.toString()}',
                                      style: tilePoppins(22, Colors.green)),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(favoriteSnack(
                                                favorites[index].nome!));
                                        userController.removeFromFavorite(
                                            0, favorites[index]);
                                      },
                                      icon: const Icon(
                                        Icons.favorite,
                                        size: 30,
                                        color: Colors.red,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        userController.addToCart(
                                            0, favorites[index]);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(addItemSnack(
                                                favorites[index].nome!));
                                      },
                                      icon: const Icon(
                                        Icons.shopping_basket,
                                        size: 30,
                                      )),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                }
                return Center(
                    child: Text("Sem Favoritos",
                        style: titlePoppins(28, Colors.grey)));
              });
        },
      )),
    );
  }
}
