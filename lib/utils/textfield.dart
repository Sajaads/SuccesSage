import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;

  MyTextField({Key? key, required this.textController, required this.hintText})
      : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Background color
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: TextField(
        controller: widget.textController,
        readOnly: false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none, // Remove border
          contentPadding: EdgeInsets.zero, // Remove default padding
        ),
      ),
    );
  }
}
