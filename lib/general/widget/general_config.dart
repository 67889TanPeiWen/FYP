
import 'package:antibullying_suicideprevention/general/model/dropDownItem.dart';
import 'package:antibullying_suicideprevention/general/model/dropDown_config.dart';
import 'package:antibullying_suicideprevention/main.dart';
import 'package:antibullying_suicideprevention/profileUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




Widget appBarMenu(BuildContext context){
  return Padding(
      padding: const EdgeInsets.only(right:  10.0),
      child: PopupMenuButton<MenuItem>(
        onSelected:(item) => onSelectedItem(context, item),
          icon:const Icon(Icons.account_circle_rounded),
          itemBuilder:(context) =>[
            ...MenuItems.firstItem.map(buildMenuItem).toList(),
            const PopupMenuDivider(),
            ...MenuItems.divideItem.map(buildMenuItem).toList(),

          ]
      )
  );



}

PopupMenuItem<MenuItem> buildMenuItem(MenuItem item) => PopupMenuItem<MenuItem>(
  value: item,
    child: Row(
    children: [
      Icon(item.icon, color: Colors.black,),
      Text(item.text),
    ],
  )
);




void onSelectedItem(BuildContext context, MenuItem item){
  switch(item){
    case MenuItems.dropDownMenuProfile:
      Navigator.of(context).push(MaterialPageRoute(
          builder:(context) => UserProfile()));
    break;

    case MenuItems.logout:
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder:(context) => Home()),
        (route)=>false);
    FirebaseAuth.instance.signOut();
    break;
  }

}