import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {

  final String txt;
  final Color color;
  final VoidCallback onPressed;

  LoginButton({required this.txt, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.only(top: 5, left: 70, right: 70),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)))),
        onPressed: onPressed,
        child: Text(
          txt,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}