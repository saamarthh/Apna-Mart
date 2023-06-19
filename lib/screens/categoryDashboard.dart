import 'package:apna_mart/main.dart';
import 'package:apna_mart/screens/cart.dart';
import 'package:apna_mart/utility/loading.dart';
import 'package:apna_mart/utility/menuDrawer.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/controllers/models.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/controllers/services.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

var providerController;

class CategoryDashboard extends StatefulWidget {

  String categoryName;
  CategoryDashboard({super.key, required this.categoryName});

  static const routeName = 'category-dashboard';

  

  @override
  State<CategoryDashboard> createState() => _CategoryDashboardState();
}

class _CategoryDashboardState extends State<CategoryDashboard> {
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
    var controller = Provider.of<ProductProvider>(context);
    var userController = Provider.of<UserProvider>(context);
    userController.fetchUser(userid!);
    controller.fetchCategoryProduct(widget.categoryName);
    controller.totalPrice();
    providerController = controller;
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return userController.user.name == '' || controller.categoryProducts.length == 0
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
                  onPressed: () {
                  },
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                    child: Text("OUR ${widget.categoryName.toUpperCase()} COLLECTION", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: controller.categoryProducts.length,
                            itemBuilder: ((context, index) {
                              Product cartItem = controller.categoryProducts[index];
                              return ProductTile(
                                product: cartItem,
                                ontap: () {
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                    TextButton(child: Container(
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(3)),
                      
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
                        child: Text("Add", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ),
                    onPressed: ontap,)
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