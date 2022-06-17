
import 'dart:ui';

import 'package:antibullying_suicideprevention/depressionTest/Test.dart';
import 'package:flutter/material.dart';

class testNewUser extends StatelessWidget {
  const testNewUser({Key? key}) : super(key: key);

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
          appBar: AppBar(title: Text('AntiBullying and Suicide Prevention')),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Center(
                child: Container(
                  width: 300,
                  height:70,
                  decoration: BoxDecoration(

                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.lightGreenAccent[400],
                      border:Border.all(color: Colors.black,width: 2),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(5.0,5.0),
                            blurRadius: 10.0,
                            spreadRadius: 2.0
                  ),
            ],
                  ),

                  child:Center(
                      child:Text("Let's start the depression test",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,)
                  ),
                ),
              ),

              SizedBox(height:20),
              Padding(
                padding: EdgeInsets.zero,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[400],
                    padding: EdgeInsets.symmetric(horizontal:70, vertical: 10),

                  ),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>Test()));
                },
                  child: Text("Start"),),
              )

            ],
          )
      )
    );

  }
}
