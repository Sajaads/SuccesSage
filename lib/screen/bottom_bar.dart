
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:successage/mentee/mentee_home_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _selectedIndex=0;
  static final List<Widget> _widgetOptions =<Widget>[
    HomeMentee(),
    const Text("Calender"),
    const Text("Chatting"),
    const Text("Settings")
  ];
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: const Color(0xFF526480),
        items: const [
          BottomNavigationBarItem(icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),label: "Home"),
          BottomNavigationBarItem(icon: Icon(FluentSystemIcons.ic_fluent_calculator_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_calculator_filled),label: "search"),
          BottomNavigationBarItem(icon: Icon(FluentSystemIcons.ic_fluent_chat_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_chat_filled),label: "ticket"),
          BottomNavigationBarItem(icon: Icon(FluentSystemIcons.ic_fluent_settings_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_settings_filled),label: "profile"),
        ],
      ),
    );
  }
}
