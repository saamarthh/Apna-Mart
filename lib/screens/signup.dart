import 'package:apna_mart/utility/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:apna_mart/controllers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:apna_mart/utility/showSnackbar.dart';
import 'dashboard.dart';

class Signup extends StatefulWidget {
  static const routeName = 'signup';
  String? phoneNumber;
  String? uid;
  Signup({this.phoneNumber, this.uid});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: ((context, userProviderModel, child) => Scaffold(
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Fill in details',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 30),
                      TextInput(
                        userInput: nameController,
                        hintTitle: 'Name *',
                        keyboardType: TextInputType.name,
                        hideText: false,
                      ),
                      const SizedBox(height: 20),
                      TextInput(
                        userInput: address1Controller,
                        hintTitle: 'Address Line 1 *',
                        keyboardType: TextInputType.streetAddress,
                        hideText: false,
                      ),
                      const SizedBox(height: 20),
                      TextInput(
                        userInput: address2Controller,
                        hintTitle: 'Address Line 2 *',
                        keyboardType: TextInputType.streetAddress,
                        hideText: false,
                      ),
                      const SizedBox(height: 20),
                      TextInput(
                        userInput: pinCodeController,
                        hintTitle: 'Pincode *',
                        keyboardType: TextInputType.number,
                        hideText: false,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print(nameController.text);
                          print(address1Controller.text);
                          print(address2Controller.text);
                          print(pinCodeController.text);

                          Map<String, dynamic> body = {
                            'uid': widget.uid,
                            'name': nameController.text,
                            'address1': address1Controller.text,
                            'address2': address2Controller.text,
                            'pinCode': pinCodeController.text,
                            'phoneNumber': widget.phoneNumber,
                            'isFirstTime': true,
                            'loyaltyPoints': 0,
                          };
                          userProviderModel.addUser(widget.uid!, body);
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
