//เก็บข้อมูลเกี่ยวกับล็อคอิน
import 'package:flutter/material.dart';
import 'package:flutter_product/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  String? _accessToken;
  String? _refreshToken;

  User? get user => _user; //เชคแล้วมีการรีเทิร์นกลับมา
  String get accessToken => _accessToken!;
  String get refreshToken => _refreshToken!;

  void onLogin(UserModel userModel) async {
    _user = userModel.user;
    _accessToken = userModel.accessToken;
    _refreshToken = userModel.refreshToken;
    notifyListeners(); 
  }

  void onLogout() {
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  bool isAuthentication() {
    return _accessToken != null && _refreshToken != null;
  }

  void requestToken(String newToken) {
    _accessToken = newToken;
    notifyListeners();
  }
}
