import 'package:apna_mart/utility/textfield.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/utility/showSnackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';

class Signup extends StatefulWidget {
  static const routeName = 'signup';

  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController address3Controller = TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: ((context, userProviderModel, child) => Scaffold(
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: ListView(
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

                          String userid = userProviderModel.getUserUid();

                          Map<String, dynamic> body = {
                            'uid': userid,
                            'name': nameController.text,
                            'address1':address1Controller.text,
                            'address2':address2Controller.text,
                            'address3':address3Controller.text,
                            'phoneNumber': userProviderModel
                                .userCredential.user!.phoneNumber
                          };
                          userProviderModel.addUser(userid, body);
                          showSnackBar(context, 'User Added Successfully');
                          Navigator.pushReplacementNamed(
                              context, Dashboard.routeName);
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
