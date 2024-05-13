import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:successage/chats/chat_list.dart';
import 'package:successage/mentor/reviews.dart';
import 'package:successage/screen/auth.dart';
import 'package:successage/mentor/profile_page.dart';
import 'package:successage/utils/setting_page.dart';

import '../screen/screen_mentor_or_mentee.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late FirebaseAuth.User _user;
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
  AuthService auth = AuthService();

  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: _fetchMentorDataStream(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No data available');
        } else {
          return Drawer(
            backgroundColor: Theme.of(context).colorScheme.background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    // Your drawer content
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        );
                      },
                      child: DrawerHeader(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    snapshot.data!['ppic'],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text("${snapshot.data!['fname']}"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        title: const Text('HOME'),
                        leading: const Icon(Icons.home),
                        onTap: () {
                          Navigator.pop(context);
                          // Add logic for navigating to home page
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        title: const Text('SETTINGS'),
                        leading: const Icon(Icons.settings),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsPage()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25,),
                      child: ListTile(
                        title: const Text("CHATS"),
                        leading: const Icon(Icons.chat),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatList(),
                              ));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, bottom: 25),
                      child: ListTile(
                        title: const Text("R E V I E W S"),
                        leading: const Icon(Icons.rate_review),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const Reviews(),
                          ));
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    title: const Text('L O G O U T'),
                    leading: const Icon(Icons.home),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Connfirm Sign Out'),
                              content: Text('Confirm Sign Out'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('No')),
                                TextButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    auth.signOut();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => ScreenLogin(),
                                        ),
                                        (route) => false);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
