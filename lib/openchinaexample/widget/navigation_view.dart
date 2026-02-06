import 'package:flutter/material.dart';

class NavigationView {
  final BottomNavigationBarItem item;
  final String title;
  // icon path
  final String iconPath;
  // selected icon path
  final String selectedIconPath;
  // is selected
  final bool isSelected;

  NavigationView({
    required this.title,
    required this.iconPath,
    required this.selectedIconPath,
    required this.isSelected,
  }) : item = BottomNavigationBarItem(
         icon: Image.asset(iconPath, width: 20.0, height: 20.0),
         activeIcon: Image.asset(selectedIconPath,width: 20.0,height: 20.0),
         label: title,
       );
}
