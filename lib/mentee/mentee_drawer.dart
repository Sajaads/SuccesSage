import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:successage/chats/chat_list.dart';
import 'package:successage/mentee/mentee_profile_page.dart';
import 'package:successage/mentor/reviews.dart';
import 'package:successage/screen/auth.dart';
import 'package:successage/mentor/profile_page.dart';
import 'package:successage/utils/setting_page.dart';

import '../screen/screen_mentor_or_mentee.dart';
import 'mentee_chat_list.dart';

class MenteeDrawer extends StatefulWidget {
  MenteeDrawer({Key? key}) : super(key: key);

  @override
  State<MenteeDrawer> createState() => _MenteeDrawerState();
}

class _MenteeDrawerState extends State<MenteeDrawer> {
  late FirebaseAuth.User _user;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.FirebaseAuth.instance.currentUser!;
  }

  Stream<Map<String, dynamic>> _fetchMentorDataStream() {
    return FirebaseFirestore.instance
        .collection('mentee')
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
                              builder: (context) => const MenteeProfilePage()),
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
                        title: const Text('H O M E'),
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
                        title: const Text('S E T T I N G S'),
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
                      padding: const EdgeInsets.only(
                        left: 25,
                      ),
                      child: ListTile(
                        title: const Text("C H A T S"),
                        leading: const Icon(Icons.chat),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MenteeChatList(),
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
                              title: Text('Confirm Sign Out'),
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
