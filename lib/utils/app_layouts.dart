import 'package:flutter/material.dart';

Color primary = const Color.fromARGB(255, 201, 225, 237);

class Styles {
  static Color primaryColor = primary;
  static Color highlighedbuttonColor = const Color(0x5F84FFF4);
  static Color cardColor = const Color(0x4B4B9FC6);
  static TextStyle headline1 = TextStyle(
      fontSize: 30,
      color: Color.fromARGB(255, 0, 0, 0),
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
  static TextStyle ButtonText =
      TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold);
  static TextStyle ProfileName =
      TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w600);
  static TextStyle textline1 =
      TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w600);
  static TextStyle headline2 = TextStyle(
      fontSize: 16, color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w400);
  static TextStyle headline3 =
  TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w400);
  static TextStyle headline4 =
      TextStyle( fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold,);
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onDrawerIconTap;

  CustomAppBar({required this.title,required this.onDrawerIconTap});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: onDrawerIconTap,
      ),
      backgroundColor: const Color.fromARGB(255, 2, 48, 71),
      automaticallyImplyLeading: false,
    );
  }
}
