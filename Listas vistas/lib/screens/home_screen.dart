import 'package:flutter/material.dart';
import '../core/services/product_service.dart';
import '../core/router/entities/product.dart';

class HomeScreen extends StatefulWidget {
  final String? username;

  const HomeScreen({super.key, this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? _message;

  @override
  void initState() {
    super.initState();
    _productService.clearProducts();
  }

  void _addProduct() {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

    if (name.isEmpty || description.isEmpty || imageUrl.isEmpty || quantity <= 0 || price <= 0) {
      setState(() {
        _message = 'Completa todos los campos con valores válidos.';
      });
      return;
    }

    _productService.addProduct(
      name,
      price,
      description,
      quantity: quantity,
      imageUrl: imageUrl,
    );
    _clearInputs();

    setState(() {
      _message = 'Producto agregado: $name';
    });
  }

  void _clearInputs() {
    _nameController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _quantityController.clear();
    _priceController.clear();
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: product.imageUrl.isNotEmpty
              ? Image.network(
                  product.imageUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      width: 72,
                      height: 72,
                      child: Icon(Icons.broken_image, size: 40),
                    );
                  },
                )
              : const SizedBox(
                  width: 72,
                  height: 72,
                  child: Icon(Icons.image_not_supported, size: 40),
                ),
        ),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.description),
            const SizedBox(height: 4),
            Text('Cantidad: ${product.quantity} · Precio: \$${product.price.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _productService.getProducts();

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de productos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Descripción')),
            TextField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'URL de imagen'), keyboardType: TextInputType.url),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Precio'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _addProduct, child: const Text('Agregar producto')),
            if (_message != null) ...[
              const SizedBox(height: 12),
              Text(_message!, style: const TextStyle(color: Colors.green)),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('No hay productos agregados.'))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(products[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
