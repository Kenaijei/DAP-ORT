import 'package:flutter/material.dart';
import 'package:tp2_dap/core/entities/product.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  final String? username;

  const HomeScreen({super.key, this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  final List<Product> _products = [];

  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        final newProduct = Product(
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          quantity: int.parse(_quantityController.text),
        );

        _products.add(newProduct);

        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _quantityController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto agregado con éxito'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  void _calculateResults() {
    if (_products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe ingresar al menos un producto'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final mostExpensiveProduct =
        _products.reduce((a, b) => a.price > b.price ? a : b);
    final cheapestProduct =
        _products.reduce((a, b) => a.price < b.price ? a : b);
    final highestQuantityProduct =
        _products.reduce((a, b) => a.quantity > b.quantity ? a : b);
    final lowestQuantityProduct =
        _products.reduce((a, b) => a.quantity < b.quantity ? a : b);
    final totalPrice = _products.fold(0.0, (sum, item) => sum + item.price);
    final averagePrice = totalPrice / _products.length;

    final results = {
      'mostExpensiveName': mostExpensiveProduct.name,
      'mostExpensiveDescription': mostExpensiveProduct.description,
      'cheapestName': cheapestProduct.name,
      'cheapestDescription': cheapestProduct.description,
      'highestQuantityName': highestQuantityProduct.name,
      'highestQuantityDescription': highestQuantityProduct.description,
      'lowestQuantityName': lowestQuantityProduct.name,
      'lowestQuantityDescription': lowestQuantityProduct.description,
      'averagePrice': averagePrice,
    };

    context.go('/results', extra: results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Hola, ${widget.username ?? 'Usuario'}'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false, // Oculta la flecha de "atrás"
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Ingresar Producto",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del producto',
                      prefixIcon: const Icon(Icons.shopping_bag),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción del producto',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Precio del producto',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un precio';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Por favor ingrese un número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Cantidad del producto',
                      prefixIcon: const Icon(Icons.format_list_numbered),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una cantidad';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Por favor ingrese un número entero válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addProduct,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.green, // Color para agregar
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Ingresar Producto'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _calculateResults,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context).primaryColor, // Color primario
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Calcular Resultados'),
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
