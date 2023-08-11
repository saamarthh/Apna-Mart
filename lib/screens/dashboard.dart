import 'package:apna_mart/main.dart';
import 'package:apna_mart/screens/cart.dart';
import 'package:apna_mart/screens/categoryDashboard.dart';
import 'package:apna_mart/utility/loading.dart';
import 'package:apna_mart/utility/menuDrawer.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/controllers/models.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/controllers/services.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'nodelivery.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geodesy/geodesy.dart';
import 'package:fluttertoast/fluttertoast.dart';

var providerController;

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  static const routeName = 'dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double distanceInKm = 0.0;
  final desiredLocation = LatLng(23.2992973, 85.2701807);
  //Latitude: 28.6949376, Longitude: 77.1784704
  @override
  void initState() {
    super.initState();
    getUidFromSharedPreferences();
    checkUserLocation();
  }

  Future<void> checkUserLocation() async {
    print("checking location");

    try {
      Position position = await _determinePosition();
      print("User position: ${position.latitude}, ${position.longitude}");

      num distance = Geodesy().distanceBetweenTwoGeoPoints(
        LatLng(position.latitude, position.longitude),
        desiredLocation,
      );

      setState(() {
        distanceInKm = distance / 1000; // Convert distance to kilometers
      });

      print("Distance in km: $distanceInKm");
    } catch (e) {
      print("Error determining user location: $e");
      // Handle the error gracefully here, show an error message, etc.
    }
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

  Future<void> getUidFromSharedPreferences() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userid = pref.getString('uid') ?? '';
    });
    fetchUserData(userid!);
  }

  Future<void> fetchUserData(String uid) async {
    final userProviderModel = Provider.of<UserProvider>(context, listen: false);
    await userProviderModel.fetchUser(uid);
    print(userProviderModel.user.name);
  }

  @override
  Widget build(BuildContext context) {
    final userProviderModel = Provider.of<UserProvider>(context);
    final user = userProviderModel.user;
    var controller = Provider.of<ProductProvider>(context);
    var userController = Provider.of<UserProvider>(context);
    userController.fetchUser(userid!);
    controller.fetchCategory();
    controller.fetchProduct();
    controller.totalPrice();
    providerController = controller;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return distanceInKm > 10
        ? DeliveryUnavailableScreen()
        : user.name.isEmpty
            ? LoadingScreen()
            : Scaffold(
                drawer: const MenuDrawer(),
                appBar: AppBar(
                  title: Text(
                    'Hello ${userController.user.name} 👋',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search_rounded),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CartPage.routeName);
                      },
                      icon: Icon(Icons.shopping_cart),
                      color: Colors.white,
                    ),
                  ],
                  backgroundColor: Color(0xff005acd),
                ),
                body: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 8, bottom: 8),
                              child: Text(
                                "SHOP BY CATEGORY",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                                  itemCount: controller.category.length,
                                  itemBuilder: ((context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoryDashboard(
                                                  categoryName: controller
                                                      .category[index]
                                                      .categoryName,
                                                ),
                                              ));
                                        },
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Image.network(controller
                                                    .category[index]
                                                    .categoryImage)),
                                            Center(
                                              child: Text(
                                                "${controller.category[index].categoryName}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 8, bottom: 8),
                              child: Text(
                                "OUR PRODUCTS",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemCount: controller.products.length,
                                itemBuilder: ((context, index) {
                                  Product cartItem = controller.products[index];
                                  // bool addDisabled = false;
                                  return ProductTile(
                                    product: cartItem,
                                    // addDisabled: addDisabled,
                                    ontap: () {
                                      // setState(() {
                                      //   addDisabled = true;
                                      // });
                                      controller.cartProducts.add(cartItem);
                                      controller.totalPrice();
                                      var snackBar = SnackBar(
                                        content: Text(
                                            'Added to Cart! Click 🛒 to update your order'),
                                        duration: Duration(seconds: 1),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      controller.totalCost != 0
                          ? Container(
                              color: Colors.orange,
                              width: double.infinity,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                            Text(
                                              'Rs. ${controller.totalCost}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, CartPage.routeName);
                                          },
                                          child: Text("View Cart",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)))
                                    ]),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;
  final Function() ontap;
  // bool addDisabled = false;
  ProductTile({required this.product, required this.ontap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.35),
                  offset: Offset(1, 1),
                  blurRadius: 3)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.network(
                    product.image,
                  )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                  text: product.name,
                  size: 18,
                  weight: FontWeight.w300,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomText(
                        text: "Rs.${product.price}",
                        size: 22,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    // addDisabled ? Container(
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(3),
                    //         border: Border.all(color: Colors.orange)),

                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           vertical: 5.0, horizontal: 8),
                    //       child: Text(
                    //         "Added",
                    //         style: TextStyle(
                    //             color: Colors.orange,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    TextButton(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(3)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8),
                          child: Text(
                            "Add",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onPressed: ontap,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;

  CustomText(
      {required this.text,
      this.size = 16,
      this.color = Colors.black,
      this.weight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: size, color: color, fontWeight: weight),
    );
  }
}
