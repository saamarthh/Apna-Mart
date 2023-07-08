import 'package:apna_mart/screens/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:apna_mart/utility/showSnackbar.dart';
import 'package:apna_mart/utility/showOtpDialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'package:apna_mart/controllers/models.dart';

class FirebaseAuthMethod {
  final FirebaseAuth _auth;
  FirebaseAuthMethod(this._auth);
  User get user => _auth.currentUser!;

  Future<UserCredential> phoneSignIn(
      BuildContext context, String phoneNumber) async {
    final completer = Completer<UserCredential>();
    TextEditingController otpController = TextEditingController();
    bool isCompleterCompleted = false; // Add a flag

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          if (!isCompleterCompleted) {
            isCompleterCompleted = true;
            final userCredential = await _auth.signInWithCredential(credential);
            completer.complete(userCredential);
          }
        },
        verificationFailed: (e) {
          if (!isCompleterCompleted) {
            isCompleterCompleted = true;
            showSnackBar(context, e.message!);
            completer.completeError(e);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          showOtpDialog(
            otpController: otpController,
            context: context,
            onPressed: () async {
              if (!isCompleterCompleted) {
                isCompleterCompleted = true;
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: otpController.text.trim(),
                );
                final userCredential1 =
                    await _auth.signInWithCredential(credential);
                completer.complete(userCredential1);
                Navigator.of(context).pop();
              }
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!isCompleterCompleted) {
            isCompleterCompleted = true;
            completer.completeError('Verification timed out');
          }
        },
      );
    } catch (e) {
      print('Authentication failed: $e');
      if (!isCompleterCompleted) {
        completer.completeError(e);
      }
      rethrow;
    }

    return completer.future;
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove('uid');
      Provider.of<UserProvider>(context, listen: false).user = UserModal(
          name: '',
          address1: '',
          address2: '',
          phoneNumber: '',
          uid: '',
          pinCode: '');
      Navigator.pushNamed(context, LoginPage.routeName);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }
}
