import 'package:apna_mart/screens/dashboard.dart';
import 'package:apna_mart/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apna_mart/main.dart';

class LoadingDashboard extends StatefulWidget {
  String? uid;
  String? phoneNumber;
  LoadingDashboard({this.uid, this.phoneNumber});
  static const routeName = 'load';
  @override
  State<LoadingDashboard> createState() => _LoadingDashboardState();
}

class _LoadingDashboardState extends State<LoadingDashboard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            return Dashboard();
          } else {
            return Signup(uid: widget.uid, phoneNumber: widget.phoneNumber,);
          }
        });
  }
}
