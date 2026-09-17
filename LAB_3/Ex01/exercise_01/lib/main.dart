import 'dart:async';

// Define the Product model
class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$$price)';
}

// Define the ProductRepository handling Futures and Streams
class ProductRepository {
  // Initial list of products
  final List<Product> _products = [
    Product(id: 1, name: 'Laptop', price: 1200.0),
    Product(id: 2, name: 'Smartphone', price: 800.0),
  ];

  // Use a broadcast StreamController to allow multiple listeners
  final StreamController<Product> _productController =
  StreamController<Product>.broadcast();

  // Future returning the full product list (simulating network delay)
  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(seconds: 1));
    return _products;
  }

  // Stream for real-time product updates
  Stream<Product> liveAdded() => _productController.stream;

  // Method to add a new product and emit it through the stream
  void addProduct(Product product) {
    _products.add(product);
    _productController.add(product); // Emit the new product event
  }

  // Close the controller when no longer needed
  void dispose() {
    _productController.close();
  }
}

void main() async {
  print('--- Exercise 1: Product Model & Repository ---');
  final repository = ProductRepository();

  // Listen to real-time stream updates
  repository.liveAdded().listen((product) {
    print('🔄 [Stream Event] New product added: $product');
  });

  // Fetch initial list via Future
  print('Fetching initial product list...');
  List<Product> initialProducts = await repository.getAll();
  print('Initial Products: $initialProducts');

  // Simulate adding products after a delay to trigger stream events
  await Future.delayed(Duration(milliseconds: 500));
  repository.addProduct(Product(id: 3, name: 'Headphones', price: 150.0));

  await Future.delayed(Duration(milliseconds: 500));
  repository.addProduct(Product(id: 4, name: 'Smartwatch', price: 250.0));

  // Wait briefly for stream events to print before finishing
  await Future.delayed(Duration(seconds: 1));
  repository.dispose();
}