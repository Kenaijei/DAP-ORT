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
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? _message;
  Product? _mostExpensive;
  Product? _cheapest;
  Product? _highestQuantity;
  Product? _lowestQuantity;
  double _averagePrice = 0.0;

  @override
  void initState() {
    super.initState();
    _productService.clearProducts();
  }

  void _addProduct() {
    final String name = _nameController.text.trim();
    final String description = _descriptionController.text.trim();
    final int quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final double price = double.tryParse(_priceController.text.trim()) ?? -1;

    if (name.isEmpty || description.isEmpty || quantity <= 0 || price <= 0) {
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
    );
    _clearInputs();

    setState(() {
      _message = 'Producto agregado: $name';
    });
  }

  void _calculateStatistics() {
    final products = _productService.getProducts();

    if (products.isEmpty) {
      setState(() {
        _message = 'No hay productos para calcular estadísticas.';
        _mostExpensive = null;
        _cheapest = null;
        _highestQuantity = null;
        _lowestQuantity = null;
        _averagePrice = 0.0;
      });
      return;
    }

    setState(() {
      _mostExpensive = products.reduce((current, next) => next.price > current.price ? next : current);
      _cheapest = products.reduce((current, next) => next.price < current.price ? next : current);
      _highestQuantity = products.reduce((current, next) => next.quantity > current.quantity ? next : current);
      _lowestQuantity = products.reduce((current, next) => next.quantity < current.quantity ? next : current);
      _averagePrice = _productService.calculateAveragePrice();
      _message = 'Estadísticas calculadas correctamente.';
    });
  }

  void _clearInputs() {
    _nameController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _priceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final productList = _productService.getProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${widget.username ?? 'Invitado'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Precio',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addProduct,
                    child: const Text('Cargar producto'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calculateStatistics,
                    child: const Text('Calcular estadísticas'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_message != null) ...[
              Text(
                _message!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
            ],
            if (_mostExpensive != null) ...[
              Text('Más caro: ${_mostExpensive!.name} - ${_mostExpensive!.description}'),
              Text('Más barato: ${_cheapest!.name} - ${_cheapest!.description}'),
              Text('Mayor cantidad: ${_highestQuantity!.name} (${_highestQuantity!.quantity})'),
              Text('Menor cantidad: ${_lowestQuantity!.name} (${_lowestQuantity!.quantity})'),
              Text('Precio promedio: \$${_averagePrice.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
            ],
            const Text(
              'Productos ingresados:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: productList.isEmpty
                  ? const Center(child: Text('No hay productos cargados aún.'))
                  : ListView.builder(
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        final product = productList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(product.name),
                            subtitle: Text('${product.description} • Cantidad: ${product.quantity} • Precio: \$${product.price.toStringAsFixed(2)}'),
                          ),
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
