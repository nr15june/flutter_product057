import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_product/controllers/auth_controllers.dart';
import 'package:flutter_product/providers/user_provider.dart';
import 'package:flutter_product/models/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


 void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserModel userModel = await AuthController()
            .login(context, _usernameController.text, _passwordController.text);

        if (!mounted) return;

        // ตรวจสอบ role ของผู้ใช้
        String role = userModel.user.role;
        print("role :$role");

        // อัปเดตสถานะการเข้าสู่ระบบของผู้ใช้
        Provider.of<UserProvider>(context, listen: false).onLogin(userModel);

        // นำทางไปยังหน้าตาม role ของผู้ใช้
        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else if (role == 'user') {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // กรณีที่ role ไม่ตรงกับที่คาดไว้
          print('Error: Unknown role');
        }
      } catch (e) {
        print(e);
        
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ใช้ Container เพื่อครอบคลุมพื้นที่ของ Scaffold
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade100,
              Colors.pink.shade100
            ], // ไล่สีจากฟ้าไปชมพู
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'L O G I N',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 300,
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: 300,
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      alignment: Alignment.centerLeft, // จัดให้อยู่ทางซ้าย
                      width: 400, // ความกว้างของ Container ให้ตรงกับฟอร์ม
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 138, 57, 189),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    GestureDetector(
                      onTap: _login,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade300,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
