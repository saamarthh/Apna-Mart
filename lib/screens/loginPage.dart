import 'package:apna_mart/main.dart';
import 'package:apna_mart/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/utility/textfield.dart';
import 'package:apna_mart/utility/loginButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apna_mart/controllers/authController.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'otp_page.dart';
import 'signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';


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
  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        // authentication successful, do something
      },
      verificationFailed: (FirebaseAuthException e) {
        // authentication failed, do something
      },
      codeSent: (String verificationId, int? resendToken) async {
        // code sent to phone number, save verificationId for later use
        String smsCode = ''; // get sms code from user
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        // Get.to(OtpPage(), arguments: [verificationId]);
        Navigator.pushReplacementNamed(context, OtpPage.routeName, arguments: [verificationId]);
        await auth.signInWithCredential(credential);
        // authentication successful, do something
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> _userLogin() async {
    String prefix = '+91';
    String phoneNumber = phoneController.text;
    String completePhoneNumber = prefix + phoneNumber;
    if (phoneNumber == "") {
      Get.snackbar(
        "Please enter the mobile number!",
        "Failed",
        colorText: Colors.white,
      );
    } else {
      signInWithPhoneNumber(completePhoneNumber);
    }
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
                          await _userLogin();
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
