import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'package:intl/intl.dart';

class OrderProvider extends ChangeNotifier {
  List<Orders> _products = [];
  List<Orders> get products => _products;

  void addOrders(
      UserModal user, List<Product> cartProducts, double totalPrice) {
    try {
      int count = 1;
      Map<String, dynamic> order;
      cartProducts.forEach((item) async {
        order = {
          'productName': item.name,
          'customerName': user.name,
          'quantity': item.quantity,
          'productCost': item.price*item.quantity,
          'totalCost': totalPrice,
          'phoneNumber': user.phoneNumber,
          'address': '${user.address1} ${user.address2} ${user.address3}',
        };

        await FirebaseFirestore.instance
            .collection('orders')
            .doc('Confirmed Orders')
            .collection(user.name)
            .doc(
                '${DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.now())} itemNo. ${count++}')
            .set(order);
      });
    } catch (error) {
      print(error);
    }
  }

  void fetchOrders(UserModal user) async {
    try {
      final List<Orders> loadedProduct = [];
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc('Confirmed Orders')
          .collection(user.name)
          .get();
      snapshot.docs.forEach((doc) {
        loadedProduct.add(Orders(
            productName: doc['productName'],
            customerName: doc['customerName'],
            quantity: doc['quantity'],
            productCost: doc['productCost'],
            totalCost: doc['totalCost'],
            phoneNumber: doc['phoneNumber'],
            address: doc['address']));
      });
      _products = loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
