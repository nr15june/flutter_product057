import 'package:flutter/material.dart';

import 'package:flutter_product/controllers/auth_controllers.dart';
import 'package:flutter_product/providers/user_provider.dart';
import 'package:flutter_product/varibles.dart';
import 'package:flutter_product/models/product_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ProductController {
  final _authController = AuthController();
  
  //---------------------------------------- response ---------------------------------------------------
  Future<void> _response(
      http.Response response, UserProvider userProvider) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else if (response.statusCode == 403) {
      await AuthController().refreshToken(userProvider);
    } else if (response.statusCode == 401) {
      userProvider.onLogout();
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error : ${response.statusCode} - ${response.body}');
    }
  }

  //---------------------------------------- fetchProducts -----------------------------------------------
  Future<List<ProductModel>> fetchProducts(UserProvider userProvider) async {
    final response = await http.get(Uri.parse('$apiURL/api/product'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userProvider.accessToken}',
    });

    await _response(response, userProvider);

    List<dynamic> productList = jsonDecode(response.body);
    return productList.map((json) => ProductModel.fromJson(json)).toList();
  }

  //---------------------------------------- PostProduct -----------------------------------------------
  Future<void> PostProduct(
      ProductModel productModel, UserProvider userProvider) async {
    final response = await http.post(Uri.parse('$apiURL/api/product'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userProvider.accessToken}',
        },
        body: jsonEncode(productModel.toJson()));
    await _response(response, userProvider);
  }

  //---------------------------------------- updateProduct -----------------------------------------------
  Future<void> updateProduct(
      ProductModel productModel, UserProvider userProvider) async {
    final response =
        await http.put(Uri.parse('$apiURL/api/product/${productModel.id}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${userProvider.accessToken}',
            },
            body: jsonEncode(productModel.toJson()));
    await _response(response, userProvider);
  }

  //---------------------------------------- deleteProduct --------------------------------------------
  Future<void> deleteProduct(
      String product_id, UserProvider userProvider) async {
    final response = await http.delete(
      Uri.parse('$apiURL/api/product/${product_id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userProvider.accessToken}',
      },
    );
    await _response(response, userProvider);
  }
}