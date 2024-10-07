import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter_product/providers/user_provider.dart';
import 'package:flutter_product/varibles.dart';
import 'package:flutter_product/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthController {
  //---------------------------------------- login ---------------------------------------------------
  Future<UserModel> login(
      BuildContext context, String username, String password) async {
    print(apiURL);

    final response = await http.post(Uri.parse("$apiURL/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "username": username,
            "password": password,
          },
        ));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('Response data: $data'); 
      UserModel userModel = UserModel.fromJson(data);
      return userModel;
    } else {
      throw Exception('Error: Invalid response structure');
    }
  }

  //---------------------------------------- register ---------------------------------------------------
  Future<void> register(BuildContext context, String username, String password,
      String name, String role) async {
    final Map<String, dynamic> registerData = {
      "username": username,
      "password": password,
      "name": name,
      "role": role,
    };

    final response = await http.post(
      Uri.parse("$apiURL/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(registerData),
    );
    print(response.statusCode);

    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print('Registration failed');
    }
  }

  //---------------------------------------- refreshToken ---------------------------------------------------
  Future<void> refreshToken(UserProvider userProvider) async {
    final refreshToken = userProvider.refreshToken;

    if (refreshToken == null) {
      throw Exception('Refresh token is null');
    }

    final response = await http.post(
      Uri.parse('$apiURL/api/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': refreshToken,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      userProvider.requestToken(responseData['accessToken']);
    } else {
      print('Failed to refresh token : ${response.body}');
      throw Exception('Failed to refresh token : ${response.body}');
    }
  }
}