import '../router/entities/product.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  final List<Product> _products = [];

  void addProduct(String name, double price, String description, {int quantity = 1, String imageUrl = ''}) {
    final product = Product(
      name: name,
      price: price,
      description: description,
      quantity: quantity,
      imageUrl: imageUrl,
    );
    _products.add(product);
  }

  List<Product> getProducts() {
    return List.unmodifiable(_products);
  }

  double calculateAveragePrice() {
    if (_products.isEmpty) return 0.0;
    final totalPrice = _products.fold<double>(0.0, (sum, product) => sum + product.price);
    return totalPrice / _products.length;
  }

  void clearProducts() {
    _products.clear();
  }
}