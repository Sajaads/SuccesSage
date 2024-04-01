import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuggestionButton extends StatefulWidget {
  const SuggestionButton({Key? key}) : super(key: key);

  @override
  State<SuggestionButton> createState() => _SuggestionButtonState();
}

class _SuggestionButtonState extends State<SuggestionButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
          onPressed: (){},
          style: OutlinedButton.styleFrom(
              backgroundColor: Colors.yellow
          ),
          child: Text("Finance")),
    );
  }
}
