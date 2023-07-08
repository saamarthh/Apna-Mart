import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    Key? key,
    required this.userInput,
    required this.hintTitle,
    required this.keyboardType,
    required this.hideText,
  }) : super(key: key);

  final TextEditingController userInput;
  final String hintTitle;
  final TextInputType keyboardType;
  final bool hideText;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  String? get errorText {
    // at any time, we can get the text from _controller.value.text
    final text = widget.userInput.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    // return null if the text is valid
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                bottom: 2,
              ),
              child: Text(
                widget.hintTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextField(
              onChanged: (text) {
                setState(() => text);
              },
              obscureText: widget.hideText,
              controller: widget.userInput,
              autocorrect: false,
              enableSuggestions: false,
              autofocus: false,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                errorText: errorText,
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.orange)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xff005acd))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
