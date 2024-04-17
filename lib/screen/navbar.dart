import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:successage/mentee/mentee_home_screen.dart';
import 'package:successage/mentor/mentor_home_screen.dart';
import 'package:successage/screen/demo.dart';
import 'package:successage/screen/demo1.dart';

class PersistenBottomNavBarDemo extends StatelessWidget {
  @override
  final String uid;
  final String collection;
  PersistenBottomNavBarDemo(
      {Key? key, required this.uid, required this.collection});
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistent Bottom Navigation Bar Demo',
      home: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: MentorHomeScreen(uid: uid, collection: collection),
            item: ItemConfig(
              icon: Icon(Icons.home),
              title: "Home",
            ),
          ),
          PersistentTabConfig(
            screen: MyWidget(),
            item: ItemConfig(
              icon: Icon(Icons.message),
              title: "Messages",
            ),
          ),
          PersistentTabConfig(
            screen: MyWidget2(),
            item: ItemConfig(
              icon: Icon(Icons.settings),
              title: "Settings",
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style1BottomNavBar(
          navBarConfig: navBarConfig,
        ),
      ),
    );
  }
}
