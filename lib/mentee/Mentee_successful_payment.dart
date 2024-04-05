import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:successage/utils/app_layouts.dart';

class MenteeSuccessPayment extends StatelessWidget {
  const MenteeSuccessPayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.highlighedbuttonColor,
        title: Text("Payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: AssetImage(
                          "assets/paymentsuccess.png"
                      )
                  )
              ),
            ),
            Text("Payment Success !",style: Styles.textline1.copyWith(color: Styles.highlighedbuttonColor),)
          ],
        ),
      ),
    );
  }
}
