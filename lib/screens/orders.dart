import 'package:apna_mart/controllers/orderController.dart';
import 'package:apna_mart/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/utility/menuDrawer.dart';
import 'package:apna_mart/utility/loginButton.dart';
import 'package:apna_mart/screens/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apna_mart/main.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'package:apna_mart/utility/loading.dart';
import 'package:apna_mart/controllers/models.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  static const routeName = 'orders';

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool isLoading = false;
  void getuserid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userid = pref.getString('uid');
    });
  }

  var orderProvider = OrderProvider();

  @override
  void initState() {
    super.initState();
    getuserid();
    getOrders();
  }

  void getOrders() async {
    setState(() {
      isLoading = true;
    });
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    await orderProvider.fetchOrders(userid!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userController = Provider.of<UserProvider>(context);
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          }

          Map<String, dynamic> map =
              snapshot.data!.data() as Map<String, dynamic>;
          userController.setUser(map);
          int length = orderProvider.products.length;

          return Scaffold(
            drawer: const MenuDrawer(),
            appBar: AppBar(
              title: Text(
                'Your Orders',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              actions: [
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
            body: isLoading
                ? Center(child: CircularProgressIndicator())
                : length == 0
                    ? Container(
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Nothing ordered yet:( ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                "Let's buy something first",
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              LoginButton(
                                  txt: "View Dashboard",
                                  color: Colors.orange,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, Dashboard.routeName);
                                  })
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: orderProvider.products.length,
                        // itemCount: orderlist.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                        child: Text(
                                      'Order#: ${orderProvider.products[index][0].orderId} : ${orderProvider.products[index][0].orderStatus}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    SizedBox(
                                      height: 13,
                                    ),
                                    Text(
                                      'Delivery Address: ${orderProvider.products[index][0].address}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Order Time: ${orderProvider.products[index][0].dateTime}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: orderProvider
                                              .products[index].length,
                                          // itemCount: orderlist[index].length,
                                          itemBuilder: (context, idx) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '${orderProvider.products[index][idx].productName} x ${orderProvider.products[index][idx].quantity} :'),
                                                Text(
                                                    '${orderProvider.products[index][idx].productCost}')
                                              ],
                                            );
                                          }),
                                    ),
                                    Divider(
                                      thickness: 5,
                                      color: Colors.orange,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Delivery Fee :'),
                                        Text('10')
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Your Total:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Rs. ${orderProvider.products[index][0].totalCost}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
          );
        });
  }
}
