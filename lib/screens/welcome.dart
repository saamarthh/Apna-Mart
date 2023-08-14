import 'package:apna_mart/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/utility/loginButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apna_mart/utility/loading.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static const routeName = 'welcome';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> futureSnapshot;

  @override
  void initState() {
    super.initState();
    futureSnapshot = fetchUserData();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('gYTJf5uNiPcaIaXR8NKg4z6xcTs1')
        .get();
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff005acd),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.30,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Laddu Gopal",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Your one-stop solution",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.normal),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Divider(
                    thickness: 1,
                    color: Colors.white,
                  ),
                ),
              ),
              LoginButton(
                  txt: 'Get Started',
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, LoginPage.routeName);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
