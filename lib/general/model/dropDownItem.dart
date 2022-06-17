import 'package:antibullying_suicideprevention/general/model/dropDown_config.dart';
import 'package:flutter/material.dart';

class MenuItems{

  static const List<MenuItem> firstItem =[
    dropDownMenuProfile
  ];

  static const List<MenuItem> divideItem =[
    logout
  ];

  static const dropDownMenuProfile= MenuItem(
    text: 'Profile',
    icon: Icons.account_circle_outlined
  );

  static const logout = MenuItem(
      text: 'Log out',
      icon: Icons.logout,
  );
}