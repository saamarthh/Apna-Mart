import 'package:apna_mart/screens/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:apna_mart/utility/showSnackbar.dart';
import 'package:apna_mart/utility/showOtpDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FirebaseAuthMethod {
  final FirebaseAuth _auth;
  FirebaseAuthMethod(this._auth);
  User get user => _auth.currentUser!;

  Future<UserCredential> phoneSignIn(
    BuildContext context, String phoneNumber) async {
    final completer = Completer<UserCredential>();
    TextEditingController otpController = TextEditingController();
    try {
      _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final userCredential = await _auth.signInWithCredential(credential);
          completer.complete(userCredential);
        },
        verificationFailed: (e) {
          showSnackBar(context, e.message!);
          completer.completeError(
              e); // Completing the completer with an error to signal failure
        },
        codeSent: (String verificationId, int? resendToken) {
          showOtpDialog(
            otpController: otpController,
            context: context,
            onPressed: () async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: otpController.text.trim(),
              );
              final userCredential1 =
                  await _auth.signInWithCredential(credential);
              completer.complete(userCredential1);
              Navigator.of(context).pop();
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          completer.completeError('Verification timed out');
        },
      );
    } catch (e) {
      print('Authentication failed: $e');
      rethrow;
    }
    return completer.future;
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove('uid');
      Navigator.pushNamed(context, LoginPage.routeName);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }
}