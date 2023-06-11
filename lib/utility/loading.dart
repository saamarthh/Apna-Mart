import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitRing(color: Colors.orange),
            SizedBox(
              height: 20,
            ),
            Text("Hang On..", textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),),
            Text("Taking you to your shopping place!", style: TextStyle(color: Color.fromARGB(255, 169, 168, 168))),
          ],
        ),
      ),
    );
  }
}