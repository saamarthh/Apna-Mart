import 'package:apna_mart/controllers/payment.dart';
import 'package:apna_mart/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/controllers/models.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/controllers/services.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static const routeName = 'cartpage';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProductProvider>(context);
    controller.totalPrice();
    double totalCost = controller.totalCost;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        backgroundColor: Color(0xff005acd),
      ),
      body: controller.cartProducts.length == 0
          ? Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  'Cart is empty :(',
                  style: TextStyle(color: Colors.black),
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
                  Container(
                    width: double.infinity,
                    height: 50,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
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
                            "Rs.${totalCost}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
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
                        // makePayment(context, controller.totalCost);
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     Dashboard.routeName,
                        //     (Route<dynamic> route) => false);
                      },
                      child: Text(
                        "Proceed to Payment",
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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.network(
            //     product.image,
            //     width: 80,
            //   ),
            // ),
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
                        icon: Icon(Icons.chevron_left),
                        onPressed: decreaseCount),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                        text: product.quantity.toString(),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.chevron_right),
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
