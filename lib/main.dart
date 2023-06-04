import 'package:apna_mart/controllers/services.dart';
import 'package:apna_mart/screens/cart.dart';
import 'package:apna_mart/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51MtV1fSDRmD8t0PZbFqKeEfUlqVYAtbIfUlqGJ2FazW73XJDIBfkP614XwmVWngUcez2Fa46wW8DJ7LfKVBfyVxe00YNQLtuOI";
  // await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Dashboard.routeName,
      routes: {
        Dashboard.routeName: (context) => Dashboard(),
        CartPage.routeName: (context) => CartPage()
      },
    );
  }
}
