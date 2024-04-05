import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/utils/app_info_list.dart';
import 'package:successage/utils/app_layouts.dart';

class HighlightedMentee extends StatelessWidget {
  final Map<String, dynamic> Mentor;

  const HighlightedMentee({Key? key, required this.Mentor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 7, // Blur radius
              offset: Offset(0, 3), // Offset in x and y directions
            ),
          ],
          color: const Color.fromARGB(255, 161, 198, 215),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            child: Column(
              children: <Widget>[
                Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image:
                                      AssetImage("assets/${Mentor['image']}"))),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Mentor['name'],
                            style: Styles.headline2,
                          ),
                          Text(
                            Mentor['title'],
                            style: Styles.headline3,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(Mentor['rating'].toString())
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.blueAccent),
                        child: Text(
                          'View Profile',
                          style: Styles.ButtonText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.lightBlue),
                        child: Text(
                          'Book Session',
                          style: Styles.ButtonText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
