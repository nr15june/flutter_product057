import 'package:flutter/material.dart';
import 'package:flutter_product/controllers/product_controllers.dart';
import 'package:flutter_product/page/Add_Product.dart';
import 'package:flutter_product/page/UpdateProduct.dart';
import 'package:flutter_product/providers/user_provider.dart';
import 'package:flutter_product/models/product_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ProductModel> products = [];
  final ProductController _productController = ProductController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final productList = await _productController.fetchProducts(userProvider);
      setState(() {
        products = productList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching products: $e')));
    }
  }

  void _Logout() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ยืนยันการออกจากระบบ'),
        content: Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // ปิด dialog ถ้าไม่ต้องการออกจากระบบ
            },
            child: Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              userProvider.onLogout();

              if (!userProvider.isAuthentication()) {
                print('logout successful');
              }

              Navigator.of(context).pushReplacementNamed('/login'); // ไปที่หน้า login
            },
            child: Text('ยืนยัน'),
          ),
        ],
      );
    },
  );
}


  void _toPostProduct() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProductPage(),
      ),
    );
    if (result == true) {
      _fetchProducts();
    }
  }

  void _toUpdateProduct(ProductModel productModel) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateProductPage(product: productModel),
      ),
    );
    if (result == true) {
      _fetchProducts();
    }
  }

  Future<void> _deleteProduct(ProductModel productModel) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text(
              'คุณต้องการลบ "${productModel.productName}"หรือไม่ ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _productController.deleteProduct(productModel.id, userProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product deleted successfully!')),
        );
        _fetchProducts(); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'P R O D U C T',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade300,
        actions: [
          IconButton(onPressed: _Logout, icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Access Token: \n${userProvider.accessToken}'),
              SizedBox(height: 10,),
              Text('Refresh Token: \n${userProvider.refreshToken}'),
              SizedBox(height: 20,),
              if (products.isEmpty)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.productName),
                              SizedBox(
                                height: 5,
                              ),
                              Text('TYPE  : ${product.productType}'),
                              SizedBox(
                                height: 5,
                              ),
                              Text('PRICE : ${product.price}'),
                              SizedBox(
                                height: 5,
                              ),
                              Text('UNIT  : ${product.unit}'),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () => _toUpdateProduct(product),
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    tooltip: 'Edit Product',
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteProduct(product),
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    tooltip: 'Delete Product',
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toPostProduct,
        child: Icon(Icons.add),
        tooltip: 'Add Product',
      ),
    );
  }
}
