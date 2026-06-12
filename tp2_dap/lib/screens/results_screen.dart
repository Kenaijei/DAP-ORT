import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, dynamic> results;

  const ResultsScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    // Función auxiliar para crear tarjetas de resultados
    Widget _buildResultCard(String title, String name, String description) {
      return Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Resultados'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/home'), // Volver a la pantalla de inicio
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultCard(
              'Producto más caro',
              results['mostExpensiveName'] ?? 'N/A',
              results['mostExpensiveDescription'] ?? 'N/A',
            ),
            _buildResultCard(
              'Producto más barato',
              results['cheapestName'] ?? 'N/A',
              results['cheapestDescription'] ?? 'N/A',
            ),
            _buildResultCard(
              'Producto con mayor cantidad',
              results['highestQuantityName'] ?? 'N/A',
              results['highestQuantityDescription'] ?? 'N/A',
            ),
            _buildResultCard(
              'Producto con menor cantidad',
              results['lowestQuantityName'] ?? 'N/A',
              results['lowestQuantityDescription'] ?? 'N/A',
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Precio promedio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      '\$${(results['averagePrice'] as double?)?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'), // Ir a la pantalla de login
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.redAccent, // Color para salir
                foregroundColor: Colors.white,
              ),
              child: const Text('Salir'),
            ),
          ],
        ),
      ),
    );
  }
}
