import 'package:apna_mart/controllers/user_provider.dart';
import 'package:apna_mart/main.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/utility/textfield.dart';
import 'package:apna_mart/utility/showSnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    var userProviderModel = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'User Info',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 30),
              TextInputField(
                userInput: nameController,
                hintTitle: 'Name',
                keyboardType: TextInputType.name,
                hideText: false,
              ),
              const SizedBox(height: 20),
              TextInputField(
                userInput: address1Controller,
                hintTitle: 'Address Line 1',
                keyboardType: TextInputType.streetAddress,
                hideText: false,
              ),
              const SizedBox(height: 20),
              TextInputField(
                userInput: address2Controller,
                hintTitle: 'Address Line 2',
                keyboardType: TextInputType.streetAddress,
                hideText: false,
              ),
              const SizedBox(height: 20),
              TextInputField(
                userInput: address3Controller,
                hintTitle: 'Address Line 3',
                keyboardType: TextInputType.streetAddress,
                hideText: false,
              ),
              ElevatedButton(
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
                    'address3': address3Controller.text,
                    'phoneNumber': userData['phoneNumber']
                  };

                  userProviderModel.addUser(userid!, body);
                  showSnackBar(context, 'Details updated Successfully!');
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
