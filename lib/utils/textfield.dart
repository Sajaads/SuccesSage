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
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      readOnly: !isEditing,
      decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: IconButton(onPressed: () {setState(() {
            isEditing=!isEditing;
          }
          );},
              icon: Icon(Icons.edit)),
        fillColor: Colors.white,
        filled: true

      ),
    );
  }
}
