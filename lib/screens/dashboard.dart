import 'package:apna_mart/main.dart';
import 'package:apna_mart/screens/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/controllers/models.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/controllers/services.dart';
import 'package:apna_mart/controllers/authController.dart';
import 'package:apna_mart/controllers/user_provider.dart';

var providerController;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const routeName = 'dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<ProductProvider>(context);
    Provider.of<UserProvider>(context).fetchUser(userid!);
    controller.fetchProduct();
    providerController = controller;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CartPage.routeName);
            },
            icon: Icon(Icons.shopping_cart),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () async {
              FirebaseAuthMethod(FirebaseAuth.instance).signOut(context);
            },
            icon: Icon(Icons.logout),
            color: Colors.black,
          ),
        ],
        backgroundColor: Color(0xff005acd),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: controller.products.length,
            itemBuilder: ((context, index) {
              return ProductTile(
                product: controller.products[index],
                ontap: () {
                  controller.cartProducts.add(controller.products[index]);
                  var snackBar = SnackBar(
                    content: Text('Added to Cart!'),
                    duration: Duration(seconds: 1),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              );
            }),
          ),
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
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.5),
                  offset: Offset(3, 2),
                  blurRadius: 7)
            ]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    product.image,
                    width: double.infinity,
                  )),
            ),
            CustomText(
              text: product.name,
              size: 18,
              weight: FontWeight.bold,
            ),
            CustomText(
              text: "",
              color: Colors.grey,
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
                IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: ontap,
                )
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
