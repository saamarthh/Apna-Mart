import 'package:apna_mart/main.dart';
import 'package:apna_mart/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/utility/textfield.dart';
import 'package:apna_mart/utility/loginButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apna_mart/controllers/authController.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  Future<void> phoneSignIn() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String prefix = '+91';
    String phoneNumber = phoneController.text;
    String completePhoneNumber = prefix + phoneNumber;
    print(completePhoneNumber);
    UserCredential userCredential =
        await FirebaseAuthMethod(FirebaseAuth.instance).phoneSignIn(
      context,
      completePhoneNumber,
    );
    if (userCredential != null) {
      final userProviderModel =
          Provider.of<UserProvider>(context, listen: false);
      userProviderModel.setUserCredential(userCredential);
      await pref.setString("uid", userCredential.user!.uid);
      userProviderModel.setUid(userCredential.user!.uid);
      print(pref.getString('uid'));
      if (userCredential.additionalUserInfo!.isNewUser) {
        Navigator.pushReplacementNamed(context, Signup.routeName);
      } else {
        if (userid == null) {
          Navigator.pushReplacementNamed(context, Signup.routeName);
        }
        else {
          Navigator.pushReplacementNamed(context, Dashboard.routeName);
        }
      }
    } else {
      print('error');
    }
    // Navigator.pushNamed(context, LandingPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: ListView(
              shrinkWrap: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Hero(
                  tag: 'logo',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                  child: Text(
                    "Welcome back!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                  child: TextInputField(
                      userInput: phoneController,
                      hintTitle: 'Enter Phone Number:',
                      keyboardType: TextInputType.phone,
                      hideText: false),
                ),
                isLoading
                    ? SpinKitRing(color: Colors.orange)
                    : LoginButton(
                        txt: 'Login',
                        color: Colors.orange,
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await phoneSignIn();
                          setState(() {
                            isLoading = false;
                          });
                        })
              ]),
        ),
      ),
    );
  }
}
