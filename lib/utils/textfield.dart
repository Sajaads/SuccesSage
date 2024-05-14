import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final ValueChanged<String>? onChanged; // New onChanged callback
  final String labelText;
  final String fieldName;
  final String defaultValue;
  MyTextField(
      {Key? key,
      required this.textController,
      required this.hintText,
      this.onChanged,
      required this.labelText,
      required this.fieldName,
        required this.defaultValue,
      })
      : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  String _hintText = '';

  @override
  void initState() {
    super.initState();
    // Set default value to controller if it's empty
    if (widget.textController.text.isEmpty && widget.defaultValue != null) {
      widget.textController.text = widget.defaultValue!;
    }
  }
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
        onChanged: (value) {
          setState(() {
            _hintText = value.isEmpty ? widget.hintText : value;
          });
        }, // Call the onChanged callback
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: InputBorder.none, // Remove border
          contentPadding: EdgeInsets.zero, // Remove default padding
        ),
      ),
    );
  }
}
