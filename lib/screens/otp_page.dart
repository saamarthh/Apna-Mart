import 'package:apna_mart/controllers/user_provider.dart';
import 'package:apna_mart/main.dart';

import 'package:apna_mart/screens/loadDashboard.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  OtpPage({Key? key}) : super(key: key);
  static const routeName = 'otp-page';
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  final TextEditingController _thirdController = TextEditingController();
  final TextEditingController _fourthController = TextEditingController();
  final TextEditingController _fifthController = TextEditingController();
  final TextEditingController _sixthController = TextEditingController();
  UserProvider userController = UserProvider();

  String? otpCode;
  final String verificationId = Get.arguments[0];
  // final String verificationId = "testing";
  FirebaseAuth auth = FirebaseAuth.instance;
  late SharedPreferences pref;
  void sharedPreference() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPreference();
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    _fourthController.dispose();
    _fifthController.dispose();
    _sixthController.dispose();
    super.dispose();
  }

  // verify otp
  void verifyOtp(
    String verificationId,
    String userOtp,
  ) async {
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await auth.signInWithCredential(creds)).user;

      if (user != null) {
        print(user.uid);
        await pref.setString("uid", user.uid);

        print(pref.getString("uid")!);
        setState(() {
          userid = pref.getString("uid");
        });
        print(userid!);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingDashboard(uid: user.uid, phoneNumber: user.phoneNumber)));
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        e.message.toString(),
        "Failed",
        colorText: Colors.white,
      );
    }
  }

  void _login() {
    if (otpCode != null) {
      verifyOtp(verificationId, otpCode!);
    } else {
      Get.snackbar(
        "Enter 6-Digit code",
        "Failed",
        colorText: Colors.white,
      );
    }
  }

  final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      elevation: 6,
      minimumSize: const Size(120, 50),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(50),
      )));

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff005acd),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 200),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  children: [
                    TextSpan(
                      text: 'Enter the Otp Sent',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Pinput(
                length: 6,
                showCursor: true,
                defaultPinTheme: PinTheme(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                onCompleted: (value) {
                  setState(() {
                    otpCode = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  style: style,
                  onPressed: _login,
                  child: const Text(
                    'Verify Otp',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  )),
              const SizedBox(height: 80),
              const Text(
                "Didn't receive any code?",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              const Text(
                "Resend new code",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
