import 'package:demo_productos_app/models/models.dart';
import 'package:demo_productos_app/screens/screens.dart';
import 'package:demo_productos_app/services/services.dart';
import 'package:demo_productos_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    final authproductService = Provider.of<AuthService>(context, listen: false);

    if (productService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
              onPressed: () {
                authproductService.logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
              icon: const Icon(Icons.login_outlined)),
        ],
      ),
      body: ListView.builder(
          itemCount: productService.products.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                productService.selectedProduct =
                    productService.products[index].copy();
                Navigator.pushNamed(context, 'product');
              },
              child: ProductCard(
                product: productService.products[index],
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productService.selectedProduct =
              Product(available: true, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
        },
        child: Icon(Icons.add_outlined),
      ),
    );
  }
}
