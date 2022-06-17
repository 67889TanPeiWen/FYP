import 'dart:ui';

import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
@override
_RegistrationState createState() => _RegistrationState();
}


class _RegistrationState extends State<SignupScreen>{
  final registerKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController guardEmailController = TextEditingController();

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
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('AntiBullying and Suicide Prevention')),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text ("Sign up", style:TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),),
                          const SizedBox(height: 20,),
                          Text("Create an Account",style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),),
                          SizedBox(height: 30,)
                        ],
                      ),
                      Form(
                        key:registerKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: [
                              makeInput(label: "Full Name",controller:nameController),
                              makeEmailInput(label: "Email",controller:emailController),
                              makeInput(label: "Password",controller:pwdController,obsureText: true),
                              makeInput(label: "Confirm Pasword",controller:confirmPwdController,obsureText: true),
                              makeEmailInput(label: "Guardian Email",controller:guardEmailController)

                            ],
                          ),
                        ),

                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: EdgeInsets.only(top: 3,left: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height:60,
                            onPressed: () {
                              if(registerKey.currentState!.validate()){
                                FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: pwdController.text).
                                then((value) {
                                  FirebaseFirestore.instance.collection("User")
                                      .doc(value.user!.uid).set({
                                    'name': nameController.value.text,
                                    'email': emailController.value.text,
                                    'guardian_email': guardEmailController.value.text,
                                    'role':'user',
                                  });
                                });
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>  LoginScreen()));

                              }



                            },
                            color: Colors.red[400],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                            ),
                            child: Text("Sign Up",style: TextStyle(
                              fontWeight: FontWeight.w600,fontSize: 16
                            ),),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Already have an account? "),
                          TextButton(
                            child: Text('Sign in', style: TextStyle(color: Colors.blue[800]),),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=> LoginScreen()),
                              );
                            },
                          )
                        ],

                      )

                    ],

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );


  }
}

Widget makeInput({label,controller,obsureText = false}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      SizedBox(height: 5,),
      TextFormField(
        obscureText: obsureText,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          border: OutlineInputBorder(),
        ),
        validator: (value){
          if(value!.isEmpty) {
            return 'Field is required';
          }
          return null;
        },
      ),
      SizedBox(height: 10,)

    ],
  );
}

Widget makeEmailInput({label,controller}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      SizedBox(height: 5,),
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          border: OutlineInputBorder(),
        ),
        validator: (value){
          if(value!.isEmpty) {
            return 'Field is required';
          }
          else if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)){
            return 'Please enter correct email format';
          }
          return null;
        },
      ),
      SizedBox(height: 10,)

    ],
  );
}

