import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FreedomSaleCard extends StatelessWidget {
  List<Map<String, dynamic>> saleBanners = [];
  FreedomSaleCard({super.key, required this.saleBanners});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 150.0,
              viewportFraction:
                  1.0, // This makes the item take full screen width
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              aspectRatio: 2.0, // Adjust this as needed
            ),
            items: saleBanners.map((bannerData) {
              print(bannerData);
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width:
                        MediaQuery.of(context).size.width, // Full screen width
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(bannerData['bannerImage']),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bannerData['saleHeading'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            bannerData['saleOffer'],
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
