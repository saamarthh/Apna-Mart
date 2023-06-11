import 'package:apna_mart/controllers/orderController.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/utility/menuDrawer.dart';
import 'package:apna_mart/controllers/authController.dart';
import 'package:apna_mart/screens/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apna_mart/main.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/controllers/user_provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  static const routeName = 'orders';

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  void getuserid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userid = pref.getString('uid');
    });
  }

  @override
  void initState() {
    getuserid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userController = Provider.of<UserProvider>(context);
    userController.fetchUser(userid!);
    var orderProvider = Provider.of<OrderProvider>(context);
    orderProvider.fetchOrders(userController.user);
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CartPage.routeName);
            },
            icon: Icon(Icons.shopping_cart),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () async {
              FirebaseAuthMethod(FirebaseAuth.instance).signOut(context);
            },
            icon: Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
        backgroundColor: Color(0xff005acd),
      ),
      body: ListView.builder(
          itemCount: orderProvider.products.length,
          itemBuilder: ((context, index) {
            return ListTile(
              title: Text(orderProvider.products[index].productName),
              subtitle: Row(
                children: [
                  Text('${orderProvider.products[index].productCost}'),
                  Text(orderProvider.products[index].quantity),
                ],
              ),
            );
          })),
    );
  }
}
