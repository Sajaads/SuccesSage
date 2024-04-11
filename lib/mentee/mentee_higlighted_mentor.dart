import 'package:flutter/material.dart';
import 'package:successage/mentee/mentee_profile.dart';

class HighlightedMentee extends StatelessWidget {
  final Map<String, dynamic> Mentor;

  const HighlightedMentee({Key? key, required this.Mentor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              color: Color.fromARGB(149, 153, 202, 223),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(Mentor['ppic']),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${Mentor['fname']} ${Mentor['lname']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('${Mentor['designation']}')
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Adjust alignment here
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: ((context) {
                            return MentorProfile(
                              Mentor: Mentor,
                            );
                          })));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 2, 48, 71), // Stylish button color
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30), // Rounded button corners
                          ),
                          elevation: 10,
                        ),
                        child: Text(
                          'View Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 223, 245, 255), // Stylish button color
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30), // Rounded button corners
                          ),
                          elevation: 10,
                        ),
                        child: Text(
                          'Book Session',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
