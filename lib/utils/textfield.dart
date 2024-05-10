import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController textController = TextEditingController();
   MyTextField({Key? key,required this.textController}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return TextField(
      decoration: InputDecoration(
        labelText: 'Enter the text',
        border: OutlineInputBorder(),
      ),
      onTap: (){

      },
    );
  }
}
