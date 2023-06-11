import 'package:apna_mart/screens/dashboard.dart';
import 'package:apna_mart/screens/orders.dart';
import 'package:apna_mart/utility/loginButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/controllers/services.dart';

class OrderConfirmPage extends StatefulWidget {
  const OrderConfirmPage({super.key});

  static const routeName = 'confirm';

  @override
  State<OrderConfirmPage> createState() => _OrderConfirmPageState();
}

class _OrderConfirmPageState extends State<OrderConfirmPage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context).emptyCart();
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '🎉',
          style: TextStyle(fontSize: 100),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Yayy! Your Order has been confirmed",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          "Check your order in 'View Orders' or continue shopping!",
          style: TextStyle(color: Color.fromARGB(255, 169, 168, 168)),
        ),
        SizedBox(
          height: 30,
        ),
        LoginButton(
          color: Colors.orange,
          txt: "View orders",
          onPressed: () {
            Navigator.pushReplacementNamed(context, OrdersPage.routeName);
          },
        ),
        LoginButton(
          color: Colors.orange,
          txt: "     Home     ",
          onPressed: () {
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          },
        ),
      ],
    )));
  }
}
