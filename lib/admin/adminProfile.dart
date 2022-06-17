import 'dart:ui';

import 'package:antibullying_suicideprevention/profileEdit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow[300]!,
            Colors.greenAccent[100]!,
            Colors.blue[300]!,

          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar:AppBar(title: const Text('Profile'),),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              else{
                var document = snapshot.data;
                return Stack(
                  children: [


                    Column(
                      children: [
                        const SizedBox(height:50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius:40,
                              backgroundImage: document?['image'] ==''? null : NetworkImage(document?['image']),
                              child: document?['image'] == ''?const Icon(Icons.person_outline_outlined,size: 50,): Container(),
                            ), ],
                        ),
                        const SizedBox(height:20),
                        Text(
                          document?['name'],
                          style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),

                        const SizedBox(height:30),

                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          ),
                          height: 300,
                          width: 350,

                          child: ListView(
                            children: [

                              const SizedBox(height:30),


                              Container(
                                padding: EdgeInsets.only(left:50.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                      Text('Email',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                                      const SizedBox(height:10),
                                      Text(document?['email'],style:TextStyle(fontSize: 18)),

                                      const SizedBox(height:30),
                                    ]

                                ),
                              ),
                            ],
                          ),
                        ),




                      ],
                    )
                  ],
                );

              }
            },

          ),
        ),
      ),
    );
  }


}
