import 'package:flutter/material.dart';
import 'package:apna_mart/controllers/models.dart';
import 'package:apna_mart/controllers/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cart.dart';

class SearchPage extends StatefulWidget {
  static const routeName = 'search';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> products = [];
  List<Product> _searchResults = [];
  int currentPage = 1; // Current page number
  int itemsPerPage = 20;

  @override
  Widget build(BuildContext context) {
    ProductProvider controller =
        Provider.of<ProductProvider>(context, listen: false);

    if (controller.products.isEmpty) {
      controller.fetchProduct();
    }

    products = controller.products;

    int length = 0;
    num totalprice = 0;

    setState(() {
      length = controller.cartProducts.length;
      totalprice = controller.totalCost;
    });

    List<Product> getPaginatedProducts() {
      // Calculate the starting and ending indices for the current page
      int startIndex = (currentPage - 1) * itemsPerPage;
      int endIndex = currentPage * itemsPerPage;

      // Return a sublist of products for the current page
      return _searchResults.sublist(
        startIndex,
        endIndex.clamp(
            0,
            _searchResults
                .length), // Ensure endIndex doesn't exceed the list length
      );
    }

    int getTotalPages(List<Product> products, int itemsPerPage) {
      int totalPages = (products.length / itemsPerPage).ceil();
      return totalPages == 0 ? 1 : totalPages;
    }

    int totalPages = getTotalPages(_searchResults, itemsPerPage);

    if (currentPage > totalPages) {
      totalPages = 1;
      currentPage = 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Search for your Products',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        backgroundColor: Color(0xff005acd),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchResults = products
                      .where((product) => product.name
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          currentPage > totalPages
              ? Text('No items')
              : Expanded(
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
                          itemCount: getPaginatedProducts().length,
                          itemBuilder: ((context, index) {
                            Product cartItem = getPaginatedProducts()[index];
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded),
                onPressed: () {
                  if (currentPage > 1) {
                    setState(() {
                      currentPage--;
                    });
                  }
                },
                iconSize: 24, // Adjust the icon size
              ),
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orange[400], // Customize the background color
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "$currentPage / $totalPages",
                  style: TextStyle(
                    fontSize: 16, // Adjust the font size
                    color: Colors.white, // Customize the text color
                  ),
                ),
              ),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios_rounded),
                onPressed: () {
                  if (currentPage < totalPages) {
                    setState(() {
                      currentPage++;
                    });
                  }
                },
                iconSize: 24, // Adjust the icon size
              ),
            ],
          ),
          if (totalprice != 0)
            Container(
              color: Colors.orange,
              width: double.infinity,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
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
                            Navigator.pushNamed(context, CartPage.routeName);
                          },
                          child: Text("View Cart",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)))
                    ]),
              ),
            )
        ],
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
                height: 90,
                width: 80,
                // child: Image.network(
                //   product.image,
                //   fit: BoxFit.fill,
                // )
                child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.fill,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error)),
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
