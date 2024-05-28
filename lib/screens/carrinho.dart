import 'package:e_commerce/components/font_style.dart';
import 'package:e_commerce/controllers/user_controller.dart';
import 'package:e_commerce/models/product_model.dart';
import 'package:e_commerce/screens/favorites.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

SnackBar buyAll() => SnackBar(
    backgroundColor: Colors.green,
    duration: const Duration(seconds: 4),
    content: Text('Agradecemos pela compra!', style: titlePoppins(20)));

class Carrinho extends StatelessWidget {
  const Carrinho({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho', style: titlePoppins()),
        centerTitle: true,
        leading: IconButton(
            onPressed: () =>
                Navigator.pushNamedAndRemoveUntil(context, '/homepage', (_) => false),
            icon: const Icon(
              Icons.arrow_back,
              size: 35,
            )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push((context),
                    MaterialPageRoute(builder: (context) => const Favorites()));
              },
              icon: const Icon(Icons.favorite, size: 35)),
        ],
      ),
      body: SafeArea(child: Consumer<UserController>(
        builder: (context, userController, child) {
          return FutureBuilder<List<ProductModel>>(
              future: userProvider.getCart(0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  List<ProductModel> products = snapshot.data!;
                  if (products.isEmpty) {
                    return Center(
                        child: Text("Carrinho vazio...",
                            style: titlePoppins(28, Colors.grey)));
                  }
                  return ListView.builder(
                      itemCount: products.length,
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
                                  Text(products[index].nome!,
                                      style: tilePoppins(22)),
                                  Text(products[index].desc!,
                                      style: tilePoppins(17)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('R\$${products[index].preco.toString()}',
                                      style: tilePoppins(22, Colors.green)),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        userController.removeFromCart(
                                            0, products[index]);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
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
                    child: Text("Carrinho vazio...",
                        style: titlePoppins(28, Colors.grey)));
              });
        },
      )),
      bottomNavigationBar: BottomAppBar(
        child: Consumer<UserController>(
          builder: (context, userController, child) {
            return FutureBuilder<List<ProductModel>>(
              future: userProvider.getCart(0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('R\$00.00', style: titlePoppins(28, Colors.grey)),
                      TextButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.deepPurple)),
                          child: Text('Comprar',
                              style: titlePoppins(28, Colors.grey)))
                    ],
                  );
                } else if (snapshot.hasData) {
                  List<ProductModel> listPrice = snapshot.data!;

                  double totalPrice = 0;

                  listPrice.forEach((p) {
                    totalPrice += p.preco!;
                  });

                  if (listPrice.isNotEmpty) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('R\$$totalPrice', style: titlePoppins(28)),
                        TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(buyAll());
                              userController.clearCart(0);
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.deepPurple)),
                            child: Text('Comprar', style: titlePoppins()))
                      ],
                    );
                  }
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('R\$00.00', style: titlePoppins(28, Colors.grey)),
                    TextButton(
                        onPressed: () {},
                        child: Text('Comprar',
                            style: titlePoppins(28, Colors.grey)))
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
