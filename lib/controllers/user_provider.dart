import 'package:apna_mart/controllers/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  late UserCredential userCredential;
  late UserModal user;

  String uid = '';

  void setUserCredential(UserCredential userCredential) {
    this.userCredential = userCredential;
    notifyListeners();
  }

  UserCredential getUserCredential() {
    return userCredential;
  }

  String getUserUid() {
    return userCredential.user!.uid;
  }

  void setUid(String uid) {
    this.uid = uid;
    notifyListeners();
  }

  void fetchUser(String userid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userid)
              .get();

      final data = snapshot.data()!;

      this.user = UserModal(
        name: data['name'],
        uid: userid,
        phoneNumber: data['phoneNumber'],
        address1: data['address1'],
        address2: data['address2'],
        address3: data['address3'],
      );
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void addUser(String userid, Map<String, dynamic> user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .set(user);
      // this.user = user;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
