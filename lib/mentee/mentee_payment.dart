import 'package:flutter/material.dart';
import 'package:successage/mentee/Mentee_successful_payment.dart';

import '../utils/app_layouts.dart';

class MenteePayment extends StatefulWidget {
  const MenteePayment({Key? key}) : super(key: key);

  @override
  State<MenteePayment> createState() => _MenteePaymentState();
}

class _MenteePaymentState extends State<MenteePayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.highlighedbuttonColor,
        title: const Center(child: Text('Payment')),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Confirm your payment",style: Styles.headline2,),
            ],
          ),
          SizedBox(height: 10,),
          Container(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              decoration: BoxDecoration(
                color: Styles.highlighedbuttonColor,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  Text("Mock Interview",style: Styles.textline1,),
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.calendar_month,color: Colors.black38,),
                              Text("07-Dec-2023")
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.timer,color: Colors.black38,),
                              Text("07:30 pm - 08:30pm"),
                            ],
                          )
                        ],
                      ),
                      Text("150/-",style: Styles.textline1,)
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
                width: 1.0
              )
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("UPI Payent",style: Styles.headline2,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage(
                                  "assets/gpay.jpeg"
                              )
                          )

                      ),
                    ),
                    Text("Google Pay"),
                    ElevatedButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>MenteeSuccessPayment())
                      );
                    },
                        child: Text("PAY")),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
