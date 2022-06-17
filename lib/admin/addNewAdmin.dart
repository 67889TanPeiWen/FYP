import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddAdmin extends StatefulWidget {
  const AddAdmin({Key? key}) : super(key: key);

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final adminSignUpKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController adminNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Admin'),),
      body: Column(
        children: [
          SizedBox(height: 30,),

          const Text('Enter the admin name and email', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Form(
            key: adminSignUpKey,
            child:  Column(
              children: [
                SizedBox(height: 50,),
                TextFormField(
                  controller: adminNameController,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                    filled: true,
                    fillColor: Colors.white,
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
                    else if(!RegExp(r'^[a-z A-Z]').hasMatch(value)){
                      return 'Please enter correct name';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: emailController,

                  decoration: const InputDecoration(
                    label: Text('Email'),

                    filled: true,
                    fillColor: Colors.white,
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


              ],
            )
          ),

          ElevatedButton(onPressed: () async {

            if(adminSignUpKey.currentState!.validate()) {
              FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: 'temp1234').
              then((value) {
                FirebaseFirestore.instance.collection("User")
                    .doc(value.user!.uid).set({
                  'name': adminNameController.value.text,
                  'email': emailController.value.text,
                  'role':'admin',
                });

              });
              String emailContent = 'You are invited as admin of Antibullying and Suicide Prevention Application. The temp password is ''temp1234''';
              sendEmail(name: adminNameController.value.text,
                  to: emailController.value.text,
                  from: 'non-reply@antibullying_suicide_prevention.com',
                  message: emailContent);

            }
            }, child: Text('Invite'),)


        ],
      ),
    );

  }

Future sendEmail({
  required String name,
  required String to,
  required String from,
  required String message,
}) async{
  const serviceId ='service_ta3wz8n';
  const templateId ='template_k22nhmr';
  const userId ='l_YU6_-Y7sDCFijs0';

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(
    url,
    headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params' :{
        'user_name': name,
        'from_email':from,
        'to_email': to,
        'user_subject':'Notification from Antibullying and Suicide Prevention Application',
        'user_message':message,
      }
    }),
  );
  print(response.body);
}


}



