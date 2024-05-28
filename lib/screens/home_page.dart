import 'package:e_commerce/components/font_style.dart';
import 'package:e_commerce/controllers/product_controller.dart';
import 'package:e_commerce/controllers/user_controller.dart';
import 'package:e_commerce/models/product_model.dart';
import 'package:e_commerce/screens/carrinho.dart';
import 'package:e_commerce/screens/favorites.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

SnackBar addItemSnack(String itemName) => SnackBar(
      backgroundColor: Colors.deepPurple,
      duration: const Duration(seconds: 2),
      content: Text('$itemName foi adicionado(a) ao Carrinho!',
          style: titlePoppins(22)),
    );

SnackBar favoriteSnack(String itemName, bool isAdding) => SnackBar(
      backgroundColor: Colors.deepPurple,
      duration: const Duration(seconds: 2),
      content: isAdding
          ? Text(
              '$itemName foi adicionado(a) aos favoritos!',
              style: titlePoppins(22),
            )
          : Text('$itemName foi removido(a) dos favoritos!',
              style: titlePoppins(22)),
    );

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserController>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Catálogo', style: titlePoppins()),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu, size: 35)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push((context),
                    MaterialPageRoute(builder: (context) => const Favorites()));
              },
              icon: const Icon(Icons.favorite, size: 35)),
          IconButton(
              onPressed: () {
                Navigator.push((context),
                    MaterialPageRoute(builder: (context) => const Carrinho()));
              },
              icon: const Icon(Icons.shopping_cart, size: 35)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Consumer<UserController>(
              builder: (context, controller, child) {
                return Column(
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(color: Colors.black45),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder(
                            future: userProvider.getUserName(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasData) {
                                final userName = snapshot.data;
                                return SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Seja bem-vindo(a)',
                                          style: titlePoppins(26)),
                                      Text(userName!,
                                          style: titlePoppins(
                                              24, Colors.deepPurple[400])),
                                    ],
                                  ),
                                );
                              }
                              return Text('Usuário Inválido',
                                  style: titlePoppins(16, Colors.deepPurple));
                            },
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.logoutCurrentUser() == true) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/selectuser', (_) => false);
                        }
                      },
                      child: ListTile(
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          title: Text('Desconectar',
                              style: tilePoppins(18, Colors.red))),
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Consumer2<ProductController, UserController>(
                builder: (context, product, userController, child) {
                  List<ProductModel> produtosList = product.produtos;
                  return ListView.builder(
                      itemCount: produtosList.length,
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
                                  Text(produtosList[index].nome!,
                                      style: tilePoppins(22)),
                                  Text(produtosList[index].desc!,
                                      style: tilePoppins(17)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                      'R\$${produtosList[index].preco.toString()}',
                                      style: tilePoppins(22, Colors.green)),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (userController.isFavorited(
                                            0, produtosList[index])) {
                                          userController.removeFromFavorite(
                                              0, produtosList[index]);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(favoriteSnack(
                                                  produtosList[index].nome!,
                                                  false));
                                        } else if (!userController.isFavorited(
                                            0, produtosList[index])) {
                                          userController.addToFavorite(
                                              0, produtosList[index]);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(favoriteSnack(
                                                  produtosList[index].nome!,
                                                  true));
                                        }
                                      },
                                      icon: Icon(
                                        Icons.favorite,
                                        size: 30,
                                        color: userController.isFavorited(
                                                0, produtosList[index])
                                            ? Colors.red
                                            : Colors.white,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        userController.addToCart(
                                            0, produtosList[index]);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(addItemSnack(
                                                produtosList[index].nome!));
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
