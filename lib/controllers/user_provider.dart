import 'package:apna_mart/controllers/models.dart';
import 'package:apna_mart/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  late UserCredential userCredential;
  UserModal user = UserModal(
      name: '',
      address1: '',
      address2: '',
      phoneNumber: '',
      uid: '',
      pinCode: '',
      isFirstTime: true,
      loyaltyPoints: 0);
  String uid = '';

  void setUserCredential(UserCredential userCredential) {
    this.userCredential = userCredential;
    notifyListeners();
  }

  UserCredential getUserCredential() {
    return userCredential;
  }

  String getUserUid() {
    return this.uid;
  }

  void setUid(String uid) {
    this.uid = uid == '' ? userid! : uid;
    notifyListeners();
  }

  Future<void> fetchUser(String userid) async {
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
          pinCode: data['pinCode'],
          isFirstTime: data['isFirstTime'],
          loyaltyPoints: data['loyaltyPoints']);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addUser(String userid, Map<String, dynamic> user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .set(user);
      this.user = UserModal(
          name: user['name'],
          address1: user['address1'],
          address2: user['address2'],
          phoneNumber: user['phoneNumber'],
          uid: user['uid'],
          pinCode: user['pinCode'],
          isFirstTime: user['isFirstTime'],
          loyaltyPoints: user['loyaltyPoints']);
      this.uid = userid;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateLoyaltyPoints(double points, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .update({'loyaltyPoints': points});
    } catch (error) {
      print(error);
    }
  }
}
