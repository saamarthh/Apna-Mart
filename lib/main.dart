import 'package:apna_mart/controllers/orderController.dart';
import 'package:apna_mart/controllers/services.dart';
import 'package:apna_mart/screens/cart.dart';
import 'package:apna_mart/screens/dashboard.dart';
import 'package:apna_mart/screens/loginPage.dart';
import 'package:apna_mart/screens/orders.dart';
import 'package:apna_mart/screens/profileScreen.dart';
import 'package:apna_mart/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apna_mart/screens/orderConfirmation.dart';

String? userid;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  userid = prefs.getString('uid');
  runApp(MyApp(userid));
}

class MyApp extends StatefulWidget {

  final String? userid;
  const MyApp(this.userid, {Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context)=> OrderProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: userid==null?LoginPage.routeName:Dashboard.routeName,
        // initialRoute: OrderConfirmPage.routeName,
        routes: {
          Dashboard.routeName: (context) => Dashboard(),
          CartPage.routeName: (context) => CartPage(),
          LoginPage.routeName:(context) => LoginPage(),
          Signup.routeName: (context) => Signup(),
          ProfileScreen.routeName:(context) => ProfileScreen(),
          OrderConfirmPage.routeName:(context) => OrderConfirmPage(),
          OrdersPage.routeName:(context) => OrdersPage(),
        },
      ),
    );
  }
}
