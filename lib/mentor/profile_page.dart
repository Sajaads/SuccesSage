import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/utils/app_layouts.dart';
import 'package:successage/mentor/edit_page.dart';
import 'package:successage/utils/textfield.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late FirebaseAuth.User _user;
  List<TextEditingController> _controllers = [TextEditingController()];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.FirebaseAuth.instance.currentUser!;
  }

  Stream<Map<String, dynamic>> _fetchMentorDataStream() {
    return FirebaseFirestore.instance
        .collection('mentor')
        .doc(_user.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('Document does not exist');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Profile Setting"),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<Map<String, dynamic>>(
          stream: _fetchMentorDataStream(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Center(child: Text("No data available"));
            } else {
              return Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                      margin: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF00B2E7),
                              Color(0xFFE064F7),
                              Color(0xFFFF8D6C)
                            ],
                            transform: GradientRotation(pi/4),
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                color: Colors.grey.shade400,
                                offset: Offset(5, 5)
                            )
                          ]
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(snapshot.data!['ppic']),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${snapshot.data!['fname']}",
                                  style: Styles.headline4),
                              Text(" ${snapshot.data!['lname']}",
                                  style: Styles.headline4),
                            ],
                          ),
                          Text(
                            "${snapshot.data!['email']}",
                            style: Styles.headline3.copyWith(color: Colors.black),
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.25),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EditPage()));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Edit Profile ",style: Styles.headline3.copyWith(color: Theme.of(context).colorScheme.primary),),
                                    Icon(Icons.edit)
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                      margin: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                color: Colors.grey.shade400,
                                offset: Offset(5, 5)
                            )
                          ]
                      ),
                      child: Column(
                        children: [
                          // Display text fields using ListView.builder
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _controllers.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: MyTextField(
                                        textController: _controllers[index],
                                        hintText: "experience ${index + 1}",
                                      ),
                                    ),
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.cancel, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            _controllers.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10), // Add some space between the text fields and the date picker
                          // Add the date picker
                          ElevatedButton(
                            onPressed: () {
                              // Show the date picker dialog
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                            },
                            child: Text('Select Experience Duration'),
                          ),
                          SizedBox(height: 10), // Add some space between the date picker and the add button
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _controllers.add(TextEditingController()); // Add new text field controller
                              });
                            },
                          ),
                        ],
                      ),

                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    ));
  }
}
