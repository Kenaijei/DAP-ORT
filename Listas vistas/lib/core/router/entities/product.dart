class Product {
  // atributos
  final String name;
  final double price;
  final String description;
  final int quantity;
  final String imageUrl;

  // constructor
  Product({
    required this.name,
    required this.price,
    required this.description,
    this.quantity = 1,
    this.imageUrl = '',
  });

  double getPrice() {
    return price;
  }
}