import 'package:apna_mart/main.dart';
import 'package:apna_mart/screens/cart.dart';
import 'package:apna_mart/utility/loading.dart';
import 'package:apna_mart/utility/menuDrawer.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/controllers/models.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/controllers/services.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';


class CategoryDashboard extends StatefulWidget {
  String categoryName;
  CategoryDashboard({super.key, required this.categoryName});

  static const routeName = 'category-dashboard';

  @override
  State<CategoryDashboard> createState() => _CategoryDashboardState();
}

class _CategoryDashboardState extends State<CategoryDashboard> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> getUidFromSharedPreferences() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userid = pref.getString('uid');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<ProductProvider>(context, listen: false);
    var userController = Provider.of<UserProvider>(context);
    
    controller.categoryProducts.clear();

    controller.fetchCategoryProduct(widget.categoryName);

    controller.totalPrice();
    int length = 0;
    num totalprice = 0;

    setState(() {
      length = controller.cartProducts.length;
      totalprice = controller.totalCost;
    });

    final scaffoldKey = GlobalKey<ScaffoldState>();
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userid).get(),
        builder: (context, snapshot) {
          if (controller.categoryProducts.length == 0) {
            return LoadingScreen();
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text("No Product under this category !"),
            );
          }

          Map<String, dynamic> map =
              snapshot.data!.data() as Map<String, dynamic>;
          userController.setUser(map);
          return Scaffold(
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
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CartPage.routeName);
                      },
                      icon: Icon(Icons.shopping_cart),
                      color: Colors.white,
                    ),
                    if (length != 0)
                      Positioned(
                        right: 12,
                        bottom: 15,
                        child: CircleAvatar(
                          radius: 7,
                          backgroundColor: Colors.red,
                          child: Text(
                            "${controller.cartProducts.length}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                  ],
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
                    child: Text(
                      "OUR ${widget.categoryName.toUpperCase()} COLLECTION",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent:
                                        MediaQuery.sizeOf(context).height / 3),
                            itemCount: controller.categoryProducts.length,
                            itemBuilder: ((context, index) {
                              Product cartItem =
                                  controller.categoryProducts[index];
                              return ProductTile(
                                product: cartItem,
                                ontap: () {
                                  setState(() {
                                    controller.cartProducts.add(cartItem);
                                    controller.totalPrice();
                                    length = controller.cartProducts.length;
                                    totalprice = controller.totalCost;
                                  });
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
                  totalprice != 0
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
        });
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
        height: MediaQuery.sizeOf(context).height / 3,
        width: MediaQuery.sizeOf(context).width / 2,
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
                  height: 60,
                  width: 60,
                  // child: Image.network(
                  //   product.image,
                  //   fit: BoxFit.fill,
                  // ),
                   child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.fill,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(
                            value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error)

                  ),
                  ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: CustomText(
                    text: "${product.name} (MRP: ${product.mrp_price})",
                    size: 12,
                    weight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CustomText(
                            text: "Our price:",
                            size: 17,
                            weight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CustomText(
                            text: "Rs.${product.our_price}",
                            size: 17,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(3)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8),
                          child: Center(
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
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
