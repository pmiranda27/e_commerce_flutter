import 'package:e_commerce/controllers/product_controller.dart';
import 'package:e_commerce/controllers/user_controller.dart';
import 'package:e_commerce/screens/carrinho.dart';
import 'package:e_commerce/screens/favorites.dart';
import 'package:e_commerce/screens/home_page.dart';
import 'package:e_commerce/screens/select_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserController>(create: (context) => UserController()),
        ChangeNotifierProvider<ProductController>(create: (context) => ProductController())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        routes: <String, WidgetBuilder> {
          '/selectuser': (BuildContext context) => SelectUser(),
          '/homepage': (BuildContext context) => HomePage(),
          '/favorites': (BuildContext context) => const Favorites(),
          '/carrinho': (BuildContext context) => const Carrinho(),
        },
        initialRoute: '/selectuser',
      ),
    );
  }
}
