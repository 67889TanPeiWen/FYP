
import 'dart:ui';

import 'package:antibullying_suicideprevention/FunctionScreen.dart';
import 'package:antibullying_suicideprevention/dprsnTestNew.dart';
import 'package:flutter/material.dart';
import 'SignupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin/adminHome.dart';
import 'forgetPassword.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginState createState() => LoginState();

}


class LoginState extends State<LoginScreen> {
  final signInKey = GlobalKey<FormState>();

  TextEditingController passwordController =  TextEditingController();
  TextEditingController emailController = TextEditingController();
  String errorMessage ='';
  bool isVisible =false;

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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: true,
              title: Text('AntiBullying and Suicide Prevention'),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: Column(
                          children: [
                            Column(
                              children:[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    SizedBox(height: 25,),
                                    Text('Login', style: TextStyle(fontSize : 40, fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,),
                                    SizedBox(height: 10,),
                                    // Icon(Icons.account_circle_outlined,size:70)
                                  ],
                                ),
                                Visibility(
                                  visible: isVisible,
                                  child:  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.grey,
                                                offset: Offset(5.0,5.0),
                                                blurRadius: 10.0,
                                                spreadRadius: 2.0
                                            ),
                                          ],
                                          border: Border.all(
                                              color: Colors.red
                                          ),
                                          borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                                        ),
                                        child: Text(errorMessage,style: const TextStyle(color: Colors.black, fontSize: 16),)
                                    ),
                                  ),

                                ),


                                Form(
                                  key: signInKey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                    child: Column(
                                      children: [
                                        emailLoginInput(label: 'email', controller: emailController),
                                        makeLoginInput(label: 'password',controller: passwordController,obsureText: true),
                                      ],),
                                ),),



                                Padding(
                                  padding:EdgeInsets.symmetric(horizontal:10),
                                  child:
                                  TextButton(
                                    child: Text('Forget Password?'),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  forgetPassword()),);
                                      },),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 3,left: 3),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red[400],
                                        padding: EdgeInsets.symmetric(horizontal:70, vertical: 10),

                                      ),
                                      child: const Text( 'Sign in',style: TextStyle(fontSize : 20),),
                                      onPressed: () async{
                                        if(signInKey.currentState!.validate()){

                                          try{
                                          FirebaseFirestore fstore =FirebaseFirestore.instance;
                                          FirebaseAuth auth = FirebaseAuth.instance;
                                          await  auth.signInWithEmailAndPassword(
                                              email: emailController.value.text.trim(),
                                              password: passwordController.value.text).then((uid) => {
                                                fstore.collection('User').doc(auth.currentUser?.uid).get().then((value){
                                                  String role =value.data()?['role'];

                                                  if(role == 'user'){
                                                    fstore.collection('depressionResult').where("userID", isEqualTo:auth.currentUser?.uid).get()
                                                        .then((value) {
                                                      if (value.size > 0){
                                                        Navigator.push(context,MaterialPageRoute(builder: (context) => FunctionScreen()));}
                                                      else {
                                                        Navigator.push(context,MaterialPageRoute(builder: (context) =>const testNewUser()));
                                                      }
                                                    });
                                                  }
                                                  else{
                                                    Navigator.push(context,MaterialPageRoute(builder: (context) =>const adminHome()));
                                                  }


                                                }),


                                              /*  ,*/
                                            errorMessage='',
                                          isVisible = false,

                                          });
                                        } on FirebaseAuthException catch(error){
                                          //errorMessage = error.message!;
                                            errorMessage = 'Incorrect email or password';
                                            isVisible = true;
                                        }

                                        }
                                        setState(() {});
                                        },
                                    ),
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Do not have an account? "),
                                    TextButton(
                                      child: Text('Sign up', style: TextStyle(color: Colors.blue[800]),),
                                      onPressed: ()
                                      {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>  SignupScreen()),);
                                        },
                                    ),
                                  ],)
                              ],),
                          ])
                  )
              )
          ),
        )
    );
  }
}




  Widget makeLoginInput({label,controller,obsureText = false}){
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
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(),
          ),
          validator: (value){
            if(value!.isEmpty) {
              return 'Pleas enter password';
            }
            return null;
          },
        ),
        SizedBox(height: 10,)

      ],
    );
  }

  Widget emailLoginInput({label,controller,obsureText = false}){
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
          enabledBorder: const OutlineInputBorder(
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
