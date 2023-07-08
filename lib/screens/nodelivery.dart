import 'package:flutter/material.dart';

class DeliveryUnavailableScreen extends StatelessWidget {
  static const routeName = 'no-delivery';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Delivery Unavailable'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 72.0,
                color: Colors.red,
              ),
              SizedBox(height: 16.0),
              Text(
                "Sorry, we can't deliver to your location.",
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
