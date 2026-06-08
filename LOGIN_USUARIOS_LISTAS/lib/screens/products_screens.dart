import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/services/product_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductService _productService = ProductService();  // Instance of the service
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  double _averagePrice = 0.0;

  void _addProduct() {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final description = _descriptionController.text;

    if (name.isNotEmpty && price > 0) {
      _productService.addProduct(name, price, description);
      _updateAveragePrice();
      // Clear fields after adding
      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
    } else {
      // Show error (e.g., via SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields with valid data')),
      );
    }
  }

  void _updateAveragePrice() {
    setState(() {
      _averagePrice = _productService.calculateAveragePrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Products')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: _priceController, decoration: InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
            ElevatedButton(onPressed: _addProduct, child: Text('Add Product')),
            SizedBox(height: 20),
            Text('Average Price: \$${_averagePrice.toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: () => context.go('/home', extra: 'User'), // Replace 'User' with actual username if needed
              child: Text('Go to Home'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _productService.getProducts().length,
                itemBuilder: (context, index) {
                  final product = _productService.getProducts()[index];
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