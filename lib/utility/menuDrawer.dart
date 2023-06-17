import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/screens/cart.dart';
import 'package:apna_mart/screens/dashboard.dart';
import 'package:apna_mart/screens/profileScreen.dart';
import 'package:apna_mart/screens/orders.dart';

import '../controllers/authController.dart';


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
             ListTile(title: const Text('Sign Out'), onTap: () {
              FirebaseAuthMethod(FirebaseAuth.instance).signOut(context);
              Navigator.pushNamed(context, ProfileScreen.routeName);
            })
          ],
        ),
      ),
    );
  }
}
