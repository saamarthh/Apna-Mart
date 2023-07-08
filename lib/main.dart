import 'package:apna_mart/controllers/services.dart';
import 'package:apna_mart/screens/cart.dart';
import 'package:apna_mart/screens/dashboard.dart';
import 'package:apna_mart/screens/loginPage.dart';
import 'package:apna_mart/screens/nodelivery.dart';
import 'package:apna_mart/screens/orders.dart';
import 'package:apna_mart/screens/profileScreen.dart';
import 'package:apna_mart/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apna_mart/screens/orderConfirmation.dart';
import 'screens/welcome.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geodesy/geodesy.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  double distanceInKm = 0.0;
  final desiredLocation = LatLng(37.7749, -122.4194);

    @override
  void initState() {
    super.initState();
    checkUserLocation();
  }

  Future<void> checkUserLocation() async {
    print("checking location");

    Position position = await _determinePosition();
    print(position);

    num distance = Geodesy().distanceBetweenTwoGeoPoints(
      LatLng(position.latitude, position.longitude),
      desiredLocation,
    );

    setState(() {
      distanceInKm = distance / 1000; // Convert distance to kilometers
    });
    print("distance in km");
    print(distanceInKm);
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        // ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Poppins'),
        debugShowCheckedModeBanner: false,
        // initialRoute:
        //     userid == null ? WelcomeScreen.routeNam : Dashboard.reouteName,
        initialRoute: Dashboard.routeName,
        routes: {
          WelcomeScreen.routeName: (context) => WelcomeScreen(),
          Dashboard.routeName: (context) => Dashboard(distanceInKm: distanceInKm,),
          CartPage.routeName: (context) => CartPage(),
          LoginPage.routeName: (context) => LoginPage(),
          Signup.routeName: (context) => Signup(),
          ProfileScreen.routeName: (context) => ProfileScreen(),
          OrderConfirmPage.routeName: (context) => OrderConfirmPage(),
          OrdersPage.routeName: (context) => OrdersPage(),
          DeliveryUnavailableScreen.routeName:(context)=>DeliveryUnavailableScreen()
        },
      ),
    );
  }
}
