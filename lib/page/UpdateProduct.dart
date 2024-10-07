import 'package:flutter/material.dart';
import 'package:flutter_product/controllers/product_controllers.dart';
import 'package:flutter_product/models/product_model.dart';
import 'package:flutter_product/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UpdateProductPage extends StatefulWidget {
  final ProductModel product;

  UpdateProductPage({required this.product});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formkey = GlobalKey<FormState>();
  final ProductController _ProductController = ProductController();

  late String _productName;
  late String _productType;
  late int _price;
  late String _unit;

  @override
  void initState() {
    super.initState();
    _productName = widget.product.productName;
    _productType = widget.product.productType;
    _price = widget.product.price;
    _unit = widget.product.unit;
  }

  void _updateProduct() async {
    if (_formkey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final updatedProduct = ProductModel(
        productName: _productName,
        productType: _productType,
        price: _price,
        unit: _unit,
        id: widget.product.id,
      );

      try {
        await _ProductController.updateProduct(updatedProduct, userProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully!')),
        );
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating product: $e')),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'U P D A T E    P R O D U C T',
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
                      children: <Widget>[
                        TextFormField(
                          initialValue: _productName,
                          decoration:
                              const InputDecoration(labelText: 'PRODUCT NAME'),
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
                        SizedBox(height: 20),
                        TextFormField(
                          initialValue: _productType,
                          decoration:
                              const InputDecoration(labelText: 'PRODUCT TYPE'),
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
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: _price.toString(),
                          decoration: const InputDecoration(labelText: 'PRICE'),
                          onChanged: (value) {
                            _price = int.tryParse(value) ?? 0;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'โปรดระบุ price';
                            }
                            if (int.tryParse(value) == null) {
                              return 'โปรดระบุ valid number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: _unit,
                          decoration: const InputDecoration(labelText: 'UNIT'),
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
                        SizedBox(height: 30),
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
                              onPressed: _updateProduct,
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
    );
  }
}
