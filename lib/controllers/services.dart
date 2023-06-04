import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apna_mart/controllers/models.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _cartProducts = [];
  List<Product> get cartProducts => _cartProducts;

  double totalCost = 0;

  // Create a new grocery item
  Future<void> addToCart(Product product) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(product.id)
          .set({
        'id': product.id,
        'image': product.image,
        'productName': product.name,
        'quantity': product.quantity,
        'price': product.price,
        // 'user': user.name,
        // 'phoneNumber': user.phoneNumber,
        // 'address': user.address,
      });
    } catch (error) {
      print(error);
    }
  }

  // Read all grocery items from Firestore
  Future<void> fetchProduct() async {
    try {
      final List<Product> loadedProduct = [];
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      snapshot.docs.forEach((doc) {
        loadedProduct.add(
          Product(
            id: doc['id'],
            name: doc['name'],
            quantity: doc['quantity'],
            price: doc['price'],
            image: doc['image'],
          ),
        );
      });
      _products = loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> totalPrice() async {
    try {
      double orderPrice = 0;
      _cartProducts.forEach((item) {
        orderPrice += (item.price * item.quantity);
      });
      totalCost = orderPrice;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchCart() async {
    try {
      final List<Product> loadedProduct = [];
      var snapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      snapshot.docs.forEach((doc) {
        loadedProduct.add(
          Product(
            id: doc['id'],
            name: doc['productName'],
            quantity: doc['quantity'],
            price: doc['price'],
            image: doc['image'],
          ),
        );
      });
      _cartProducts = loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void increaseQuantity(int index) {
    _cartProducts[index].quantity += 1;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    _cartProducts[index].quantity = _cartProducts[index].quantity <= 0
        ? 0
        : _cartProducts[index].quantity - 1;
    if (_cartProducts[index].quantity == 0) {
      _cartProducts.removeAt(index);
    }
    notifyListeners();
  }
}
