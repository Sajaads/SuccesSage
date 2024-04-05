import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:successage/mentee/Mentee_session_card.dart';
import 'package:successage/utils/app_layouts.dart';

class SessionBooking extends StatefulWidget {
  const SessionBooking({Key? key}) : super(key: key);

  @override
  State<SessionBooking> createState() => _SessionBookingState();
}

class _SessionBookingState extends State<SessionBooking> {
  int selectedOption = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Choose your Session"),
              ],
            ),
            SizedBox(height: 20,),
            MenteeSessionCard(),
            SizedBox(height: 15,),
            MenteeSessionCard()
          ],
        ),
      ),
    );
  }
}
