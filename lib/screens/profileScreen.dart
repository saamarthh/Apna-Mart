import 'package:apna_mart/controllers/user_provider.dart';
import 'package:apna_mart/main.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/utility/textFormField.dart';
import 'package:apna_mart/utility/showSnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apna_mart/utility/loginButton.dart';

import 'dashboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const routeName = 'profile';
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController address3Controller = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  late Map<String, dynamic> userData;
  Future<void> getUserData() async {
    // Retrieve the user's profile data from Firebase
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();

    if (snapshot.exists) {
      // Populate the text controllers with the retrieved data
      userData = snapshot.data()!;
      nameController.text = userData['name'] ?? '';
      address1Controller.text = userData['address1'] ?? '';
      address2Controller.text = userData['address2'] ?? '';
      address3Controller.text = userData['address3'] ?? '';
      pincodeController.text = userData['pinCode'] ?? '';
    }
  }

  void getuserid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userid = pref.getString('uid');
    });
  }

  @override
  void initState() {
    getuserid();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProviderModel = UserProvider();
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Update Profile',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              const SizedBox(height: 30),
              TextInput(
                userInput: nameController,
                hintTitle: 'Name',
                keyboardType: TextInputType.name,
                hideText: false,
              ),
              const SizedBox(height: 20),
              TextInput(
                userInput: address1Controller,
                hintTitle: 'Address Line 1',
                keyboardType: TextInputType.streetAddress,
                hideText: false,
              ),
              const SizedBox(height: 20),
              TextInput(
                userInput: address2Controller,
                hintTitle: 'Address Line 2',
                keyboardType: TextInputType.streetAddress,
                hideText: false,
              ),
              const SizedBox(height: 20),
              TextInput(
                userInput: pincodeController,
                hintTitle: 'Pincode',
                keyboardType: TextInputType.number,
                hideText: false,
              ),
              LoginButton(
                txt: 'Update',
                color: Color(0xff005acd),
                onPressed: () async {
                  print(nameController.text);
                  print(address1Controller.text);
                  print(address2Controller.text);
                  print(address3Controller.text);

                  Map<String, dynamic> body = {
                    'uid': userid,
                    'name': nameController.text,
                    'address1': address1Controller.text,
                    'address2': address2Controller.text,
                    'phoneNumber': userData['phoneNumber']
                  };

                  // userProviderModel.addUser(userid!, body);
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userid)
                      .update(body);                 
                  showSnackBar(context, 'Details updated Successfully!');
                  Navigator.pushReplacementNamed(context, Dashboard.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
