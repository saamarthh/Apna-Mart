import 'package:apna_mart/controllers/services.dart';
import 'package:apna_mart/screens/cart.dart';
import 'package:apna_mart/screens/dashboard.dart';
import 'package:apna_mart/screens/loadDashboard.dart';
import 'package:apna_mart/screens/loginPage.dart';
import 'package:apna_mart/screens/nodelivery.dart';
import 'package:apna_mart/screens/orders.dart';
import 'package:apna_mart/screens/otp_page.dart';
import 'package:apna_mart/screens/profileScreen.dart';
import 'package:apna_mart/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apna_mart/screens/orderConfirmation.dart';
import 'screens/welcome.dart';

String? userid;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  UserProvider userProvider = UserProvider();
  ProductProvider productProvider = ProductProvider();
  userid = prefs.getString('uid');
  runApp(MyApp(userid));
}

class MyApp extends StatefulWidget {
  final String? userData;
  const MyApp(this.userData, {Key? key}) : super(key: key);

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
        // ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: GetMaterialApp(
        theme: ThemeData(fontFamily: 'Poppins'),
        debugShowCheckedModeBanner: false,
        initialRoute:
            userid == null ? WelcomeScreen.routeName : Dashboard.routeName,
        routes: {
          WelcomeScreen.routeName: (context) => WelcomeScreen(),
          Dashboard.routeName: (context) => Dashboard(),
          CartPage.routeName: (context) => CartPage(),
          LoginPage.routeName: (context) => LoginPage(),
          Signup.routeName: (context) => Signup(),
          ProfileScreen.routeName: (context) => ProfileScreen(),
          OrderConfirmPage.routeName: (context) => OrderConfirmPage(),
          OrdersPage.routeName: (context) => OrdersPage(),
          DeliveryUnavailableScreen.routeName: (context) =>
              DeliveryUnavailableScreen(),
          OtpPage.routeName: (context) => OtpPage(),
          LoadingDashboard.routeName: (context) => LoadingDashboard(),
        },
      ),
    );
  }
}
