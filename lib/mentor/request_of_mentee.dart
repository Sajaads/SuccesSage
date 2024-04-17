import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:successage/utils/app_layouts.dart';

class RequestOfMentee extends StatefulWidget {
  const RequestOfMentee({Key? key}) : super(key: key);

  @override
  State<RequestOfMentee> createState() => _RequestOfMenteeState();
}

class _RequestOfMenteeState extends State<RequestOfMentee> {
  List<String> selectedNames =[];
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    if(_isCollapsed)
      {
        return SizedBox.shrink();//if collapsed,return an empty SizedBox
      }
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Styles.highlighedbuttonColor,
      
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: AssetImage(
                          "assets/neymar.jpg"
                      )
                  )
              ),
            ),
            Text("Sanet"),
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    selectedNames.add("sanet");
                    setState(() {

                      _isCollapsed=true;
                    });

                  },
                    child: Icon(Icons.check,color: Colors.orange,)),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      _isCollapsed=true;
                    });

                  },
                    child: Icon(Icons.close,color: Colors.orange,)),
              ],
            )
          ],
        ),
      );
  }
}
