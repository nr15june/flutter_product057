import 'package:flutter/material.dart';
import 'package:flutter_product/controllers/product_controllers.dart';
import 'package:flutter_product/models/product_model.dart';
import 'package:flutter_product/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formkey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();

  String _productName = '';
  String _productType = '';
  int _price = 0;
  String _unit = '';

  void _postProduct() async {
    if (_formkey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final newProduct = ProductModel(
          productName: _productName,
          productType: _productType,
          price: _price,
          unit: _unit,
          id: '');

      try {
        await _productController.PostProduct(newProduct, userProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully!')),
        );
        // ไปยังหน้า HomePage หลังจากเพิ่มผลิตภัณฑ์สำเร็จ
        Navigator.of(context).pop(
            true); // หรือใช้ Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade100,
              Colors.lightGreen.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'P R O D U C T   L I S T',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'PRODUCT NAME'),
                            onChanged: (value) {
                              _productName = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'โปรดระบุ product name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'PRODUCT TYPE'),
                            onChanged: (value) {
                              _productType = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'โปรดระบุ product type';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'PRICE'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _price = int.tryParse(value) ?? 0;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'โปรดระบุ price';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'UNIT'),
                            onChanged: (value) {
                              _unit = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'โปรดระบุ unit';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 80),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade900,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 12.0),
                                child: Text(
                                  'ยกเลิก',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _postProduct,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade900,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 12.0),
                                child: Text(
                                  'บันทึก',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
