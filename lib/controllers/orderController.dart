import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';
import 'package:intl/intl.dart';
import 'package:short_uuids/short_uuids.dart';

class OrderProvider {
  List<List<Orders>> _products = [];
  List<List<Orders>> get products => _products;
  void addOrders(
      UserModal user, List<Product> cartProducts, double totalPrice) async {
    try {
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
          'address': '${user.address1} ${user.address2} - ${user.pinCode}',
          'date': date,
          'orderId': orderId,
        };

        await FirebaseFirestore.instance
            .collection('orders')
            .doc(user.uid)
            .collection(orderId)
            .doc()
            .set(order);
      });
      await FirebaseFirestore.instance.collection('orderId').doc(orderId).set({
        'orderId': orderId,
        'date': date,
        'customerName': user.name,
        'uid': user.uid
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
          .where("uid", isEqualTo: userid)
          .get();
      snapshot.docs.forEach((doc) async {
        print(doc.id);
        final List<Orders> loadedProduct = [];
        final QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .doc(userid)
            .collection(doc['orderId'])
            .get();

        orderSnapshot.docs.forEach((element) {
          int count = 0;
          print(element.id);
          loadedProduct.add(Orders(
              productName: element['productName'],
              customerName: element['customerName'],
              quantity: element['quantity'],
              productCost: element['productCost'],
              totalCost: element['totalCost'],
              phoneNumber: element['phoneNumber'],
              address: element['address'],
              dateTime: element['date'],
              orderId: element['orderId']));
          print(count++);
        });
        orderList.add(loadedProduct);
      });
      _products = orderList;
      print(orderList.length);
      print(_products.length);
      // notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
