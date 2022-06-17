import 'dart:ui';

import 'package:antibullying_suicideprevention/admin/addNewAdmin.dart';
import 'package:antibullying_suicideprevention/admin/adminHome.dart';
import 'package:antibullying_suicideprevention/admin/adminProfile.dart';
import 'package:antibullying_suicideprevention/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SidebarMenuAdmin extends StatelessWidget {
  const SidebarMenuAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance
        .collection('bullyReports').orderBy('created',descending: true)
        .snapshots();

    return StreamBuilder(
      stream:  FirebaseFirestore.instance
          .collection('User').doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        else{
          var document = snapshot.data;
          return  Drawer(
            child: Material(
              color: Colors.blueGrey[900],
              child: ListView(
                children: [
                 buildHeader(context, document['image'], document['name'], document['email']),
                  SizedBox(height: 20),

                  buildMenuItem(
                    text: 'Home',
                    icon:Icons.home,
                    onClicked: () => selectedItem(context,0),
                  ),

                  buildMenuItem(
                    text: 'Profile',
                    icon:Icons.account_circle,
                    onClicked: () => selectedItem(context,1),
                  ),

                  buildMenuItem(
                    text: 'Add new admin',
                    icon:Icons.person_add,
                    onClicked: () => selectedItem(context,2),

                  ),
                  Divider(color: Colors.white70,),
                  buildMenuItem(
                    text: 'Log out',
                    icon:Icons.logout,
                    onClicked: () => selectedItem(context,3),

                  ),
                ],
              ),
            ),
          );
        }
      },
    );


  }

  Widget buildHeader(BuildContext context, image, name,email) => Container(
    color: Colors.blue[700],
    padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 24
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius:40,
          backgroundImage: image ==''? null : NetworkImage(image),
          child: image == ''?Icon(Icons.person_outline_outlined,size: 50,): Container(),
        ),
        SizedBox(width:20),
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             SizedBox(height:20),
             Text(name,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
             SizedBox(height:10),

             Text(email,style: TextStyle(color: Colors.white)),
             SizedBox(height:20),
           ],
         )




      ],
    ),
  );

  Widget buildMenuItem({required String text, required IconData icon,  VoidCallback? onClicked}){
    const styleColor = Colors.white;
    const hoverColor = Colors.white60;
    return ListTile(
      leading: Icon(icon,color: styleColor,),
      title: Text(text, style: TextStyle(color: styleColor),),
      hoverColor: hoverColor,
      onTap:onClicked,
    );
  }

  void selectedItem(BuildContext context, int index){
    Navigator.of(context).pop();
    switch(index){
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) =>const adminHome() )
        ));
        break;

      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) =>const AdminProfile() )
        ));
        break;

      case 2:
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => const AddAdmin() )
        ));
        break;

      case 3:
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => Home() )
        ));
        break;
    }

  }

}



