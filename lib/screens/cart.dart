import 'package:apna_mart/controllers/orderController.dart';
import 'package:apna_mart/screens/dashboard.dart';
import 'package:apna_mart/screens/orderConfirmation.dart';
import 'package:apna_mart/utility/loginButton.dart';
import 'package:apna_mart/utility/menuDrawer.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/controllers/models.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/controllers/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apna_mart/main.dart';
import 'package:apna_mart/controllers/user_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static const routeName = 'cartpage';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    getUidFromSharedPreferences();
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
    final controller = Provider.of<ProductProvider>(context);
    var userController = Provider.of<UserProvider>(context);
    userController.fetchUser(userid!);
    controller.totalPrice();
    double totalCost = controller.totalCost;
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text(
          'Your Cart',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Color(0xff005acd),
      ),
      body: controller.cartProducts.length == 0
          ? Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Empty :( ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Text(
                      "Let's shop for something",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LoginButton(
                        txt: "View Dashboard",
                        color: Colors.orange,
                        onPressed: () {
                          Navigator.pushNamed(context, Dashboard.routeName);
                        })
                  ],
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.cartProducts.length,
                      itemBuilder: (context, index) {
                        return CartTile(
                            product: controller.cartProducts[index],
                            onpressed: () {
                              controller.cartProducts.removeAt(index);
                            },
                            increaseCount: () {
                              controller.increaseQuantity(index);
                            },
                            decreaseCount: () {
                              controller.decreaseQuantity(index);
                            });
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Delivery Fee:",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                "Rs.10",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Grand Total:",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                "Rs.${totalCost + 10}",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.orange,
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        OrderProvider().addOrders(userController.user,
                            controller.cartProducts, controller.totalCost);
                        userController.user.isFirstTime
                            ? userController
                                .updateToReturningUser(userController.user.uid)
                            : userController.updateLoyaltyPoints(
                                userController.user.loyaltyPoints +
                                    controller.totalCost * 0.01,
                                userController.user.uid);
                        Navigator.pushReplacementNamed(
                            context, OrderConfirmPage.routeName);
                      },
                      child: Text(
                        "Confirm Order",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class CartTile extends StatelessWidget {
  final Product product;
  final Function() onpressed;
  final void Function() increaseCount;
  final void Function() decreaseCount;
  CartTile(
      {required this.product,
      required this.onpressed,
      required this.increaseCount,
      required this.decreaseCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Color.fromARGB(255, 189, 188, 188))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                product.image,
                width: 80,
              ),
            ),
            Expanded(
                child: Wrap(
              direction: Axis.vertical,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 14),
                    child: CustomText(
                      text: product.name,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.remove,
                          weight: 20,
                        ),
                        onPressed: decreaseCount),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: CustomText(
                          text: product.quantity.toString(),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.add,
                          weight: 20,
                        ),
                        onPressed: increaseCount),
                  ],
                )
              ],
            )),
            Padding(
              padding: const EdgeInsets.all(14),
              child: CustomText(
                text: "Rs.${product.price * product.quantity}",
                size: 22,
                weight: FontWeight.bold,
              ),
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
