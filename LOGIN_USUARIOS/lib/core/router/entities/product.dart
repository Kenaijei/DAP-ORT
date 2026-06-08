class Product {
  // atributos
  final String name;
  final double price;
  final String description;

  // constructor
  Product({
    required this.name,
    required this.price,
    required this.description,
  });

  double getPrice(){
    return price;
  }
}