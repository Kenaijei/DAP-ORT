import '../entities/product.dart';  // Adjust the import path based on your folder structure

class ProductService {
  final List<Product> _products = [];  // Private list to store products

  // Method to add a product (call this from your UI screen after collecting input)
  void addProduct(String name, double price, String description, int quantity) {
    final product = Product(
      name: name,
      price: price,
      description: description,
    );
    _products.add(product);
  }

  // Method to get all products (useful for displaying in UI)
  List<Product> getProducts() {
    return List.unmodifiable(_products);  // Return a read-only copy to prevent external modifications
  }

  // Method to calculate the average price of all products
  double calculateAveragePrice() {
    if (_products.isEmpty) return 0.0;  // Handle empty list to avoid division by zero
    final totalPrice = _products.fold<double>(0.0, (sum, product) => sum + product.price);
    return totalPrice / _products.length;
  }

  // Optional: Method to clear products (e.g., for resetting)
  void clearProducts() {
    _products.clear();
  }
}