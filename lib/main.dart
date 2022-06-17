import 'dart:ui';

import 'package:antibullying_suicideprevention/SignupScreen.dart';

import 'LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
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
      child:Scaffold(
      backgroundColor: Colors.transparent ,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
          const Padding(
            padding: EdgeInsets.only(top: 130.0),
            child: Text('Antibullying and Suicide Prevention',style: TextStyle(fontSize: 40),textAlign: TextAlign.center,),
          ),

            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: MaterialButton(
                minWidth: double.infinity,
                child: const Text('Sign in', style: TextStyle(fontSize: 30),),
                height:60,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)
                ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> LoginScreen()),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 50,left: 3),
              child: MaterialButton(
                minWidth: double.infinity,
                child: const Text('Sign up', style: TextStyle(fontSize: 30),),
                height:60,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)
                ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> SignupScreen()),
                  );
                },
              ),
            )

          ],

        )
    ),);
  }
}



