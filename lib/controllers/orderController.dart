import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'package:intl/intl.dart';
import 'package:short_uuids/short_uuids.dart';

class OrderProvider{
  List<List<Orders>> _products = [];
  List<List<Orders>> get products => _products;
  void addOrders(
      UserModal user, List<Product> cartProducts, double totalPrice) {
    try {
      int count = 1;
      String orderId = ShortUuid().generate();
      String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
      Map<String, dynamic> order;
      cartProducts.forEach((item) async {
        order = {
          'productName': item.name,
          'customerName': user.name,
          'quantity': item.quantity,
          'productCost': item.price * item.quantity,
          'totalCost': totalPrice,
          'phoneNumber': user.phoneNumber,
          'address': '${user.address1} ${user.address2} ${user.address3}',
          'date': date,
          'orderId': orderId,
        };

        await FirebaseFirestore.instance
            .collection('orders')
            .doc(user.uid)
            .collection(orderId)
            .doc()
            .set(order);

        await FirebaseFirestore.instance
            .collection('orderId')
            .doc(user.uid)
            .collection('orderId')
            .doc(orderId)
            .set({
          'orderId': orderId,
          'date': date,
          'customerName': user.name,
        });
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchOrders(String userid) async {
    try {
      final List<List<Orders>> orderList = [];
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orderId')
          .doc(userid)
          .collection('orderId')
          .get();

      snapshot.docs.forEach((doc) async {
        var id = doc.id;
        final List<Orders> loadedProduct = [];
        final QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .doc(userid)
            .collection(id)
            .get();

        orderSnapshot.docs.forEach((element) {
          loadedProduct.add(Orders(
              productName: element['productName'],
              customerName: element['customerName'],
              quantity: element['quantity'],
              productCost: element['productCost'],
              totalCost: element['totalCost'],
              phoneNumber: element['phoneNumber'],
              address: element['address'],
              date: element['date'],
              orderId: element['orderId']));
        });
        orderList.add(loadedProduct);
      });
      _products = orderList;
      // notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
