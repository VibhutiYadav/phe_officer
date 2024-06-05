import 'package:flutter/material.dart';
import 'package:handpump_supervisor/view/screens/my_work_screen.dart';

import '../../helper/images.dart';
import 'dashboard_view.dart';
import 'edit_profile.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    DashboardView(),
    MyWorkScreen(),
    EditProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            selectedLabelStyle: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            selectedFontSize: 22,
            unselectedFontSize: 15,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            backgroundColor: Colors.blue,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  ProjectImages.darkhome,
                  color: Colors.white,
                  height: 25,
                  width: 25,
                ),
                icon: Image.asset(
                  ProjectImages.home,
                  color: Colors.white,
                  height: 25,
                  width: 25,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  ProjectImages.file,
                  height: 30,
                  width: 30,
                ),
                label: 'My Work',
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  ProjectImages.userDark,
                  color: Colors.white,
                  height: 25,
                  width: 25,
                ),
                icon: Image.asset(
                  ProjectImages.user,
                  color: Colors.white,
                  height: 25,
                  width: 25,
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
