import 'package:flutter/material.dart';

import 'package:flutter_product/page/login.dart';
import 'package:flutter_product/page/home.dart';
import 'package:flutter_product/page/admin.dart';
import 'package:flutter_product/page/register.dart';
import 'package:flutter_product/page/Add_Product.dart';
import 'package:flutter_product/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
          initialRoute: '/login',
          debugShowCheckedModeBanner: false,
          routes: {
            '/login': (context) => LoginPage(),
            '/home': (context) => HomePage(),
            '/admin': (context) => AdminPage(),
            '/register': (context) => RegisterPage(),
            '/addproduct': (context) => AddProductPage(),
          }),
    );
  }
}
