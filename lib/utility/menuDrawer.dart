import 'package:flutter/material.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/screens/cart.dart';
import 'package:apna_mart/screens/dashboard.dart';
import 'package:apna_mart/screens/profileScreen.dart';
import 'package:apna_mart/screens/orders.dart';


class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Container(
      width: 2*MediaQuery.of(context).size.width/3,
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
        ),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello ${userProvider.user.name} 👋!!',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(title: const Text('Browse Products'), onTap: () {
              Navigator.pushNamed(context, Dashboard.routeName);
            }),
            ListTile(title: const Text('Your orders'), onTap: () {
              Navigator.pushNamed(context, OrdersPage.routeName);
            }),
            ListTile(
                title: const Text('Your Cart'),
                onTap: () {
                  Navigator.pushNamed(context, CartPage.routeName);
                }),
            ListTile(title: const Text('Your Profile'), onTap: () {
              Navigator.pushNamed(context, ProfileScreen.routeName);
            }),
          ],
        ),
      ),
    );
  }
}
