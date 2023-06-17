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
      width: 5*MediaQuery.of(context).size.width/6,
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
        ),
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("${userProvider.user.name}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  Text("Contact Number: ${userProvider.user.phoneNumber}", style: TextStyle( fontSize: 14, color: Colors.grey)),
                  Text("Home Address: ${userProvider.user.address1} ${userProvider.user.address2} - ${userProvider.user.pinCode}", style: TextStyle( fontSize: 14, color: Colors.grey))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 5),
              child: Text("Your Actions", style:TextStyle(color: Colors.grey)),
            ),
            ListTile(
                title: const Text('Browse Products', style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.pushNamed(context, Dashboard.routeName);
                }),
            ListTile(
                title: const Text('Your orders',style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pushNamed(context, OrdersPage.routeName);
                }),
            ListTile(
                title: const Text('Your Cart',style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pushNamed(context, CartPage.routeName);
                }),
            ListTile(
                title: const Text('Edit Your Profile',style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pushNamed(context, ProfileScreen.routeName);
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 5),
              child: Text("Other Actions", style:TextStyle(color: Colors.grey)),
            ),
            ListTile(
                title: const Text('Know About us',style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  // Navigator.pushNamed(context, ProfileScreen.routeName);
                }),
            ListTile(
                title: const Text('Sign Out',style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  FirebaseAuthMethod(FirebaseAuth.instance).signOut(context);
                  Navigator.pushNamed(context, ProfileScreen.routeName);
                })
          ],
        ),
      ),
    );
  }
}
