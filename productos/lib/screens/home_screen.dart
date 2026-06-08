import 'package:flutter/material.dart';
import '../core/services/product_service.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();
    final products = productService.getProducts();
    final averagePrice = productService.calculateAveragePrice();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ingresar datos:'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Average Price: \$${averagePrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Products:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: products.isEmpty
                  ? Center(child: Text('No products added yet.'))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text('${product.description} - \$${product.price}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}