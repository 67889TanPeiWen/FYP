

import 'dart:convert';
import 'dart:math';

import 'package:antibullying_suicideprevention/FunctionScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class Result extends StatelessWidget {
  int testScore;
  final Function resetHandler;

  Result( this.testScore, this.resetHandler) ;

  String get resultWord{
    String resultText = '';
    if(testScore >= 20 && testScore <28){
      resultText ='severe depression';
    }
    else if(testScore >= 15 && testScore <20)
    {
      resultText ='moderately severe depression';
    }
    else if(testScore >= 10 && testScore <15)
    {
      resultText ='moderate depression';
    }
    else if(testScore >= 5 && testScore <10)
    {
      resultText ='mild depression';
    }
    else
    {
      resultText ='no depression';
    }

    return resultText;
  }

  String get dialogMessage{
    String Message = '';
    if(testScore >= 20 && testScore <28){
      Message ='Your situation is very dangerous. An email was sent to your counsellor';
    }
    else if(testScore >= 15 && testScore <20)
    {
      Message ='Your situation is dangerous. An email was sent to your counsellor';
    }
    else if(testScore >= 10 && testScore <15)
    {
      Message ='You are now depressed. Please go to look for counselling';
    }
    else if(testScore >= 5 && testScore <10)
    {
      Message ='You have minor depression symptoms. ';
    }
    else
    {
      Message ='Congratulation, your mental health is good.';
    }

    return Message;
  }


  String get emailMessage{
    String emailMessage = '';
    if(testScore >= 20 && testScore <28){
      emailMessage ='Your child/student has severe depression. Please call for proper treatment immediately';
    }
    else if(testScore >= 15 && testScore <20)
    {
      emailMessage ='Your child/student has severe depression. Please keep track';
    }
    else if(testScore >= 10 && testScore <15)
    {
      emailMessage ='Your child/student has depression. Pay attention to his/her mental condition';
    }


    return emailMessage;
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
         Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[200],
            boxShadow: const [
            BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(1, 3), // changes position of shadow
            ),
            ],
            ),



        child: Column(
        children: [
        /*  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Column(
              children: [
                AlertDialog(
                  title: Text(dialogMessage),
                  actions: [
                    TextButton(
                        child: Text('close'),
                        onPressed:(){
                        // Navigator.of(context).popAndPushNamed(Test().toString());
                          print(Navigator.of(context));

                        }
                    )
                  ],
                ),
              ],
            ),
          ),*/
          Container(
          child: Text("Result",style: TextStyle(fontSize: 30),),
        ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(resultWord,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                    ),
                  ),
                ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Score: ' '$testScore',
            style: TextStyle(
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),

        ],
        ),
        ),
        SizedBox(height: 30,),



        ElevatedButton(
          child: Text("Confirm"),
          /*onPressed: () {
            add();
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> FunctionScreen()),
            );
            },*/ // onPressed
        onPressed: () async {
          String toEmail ='';
          String fromEmail ='';
          String name ='';

          add();

          FirebaseFirestore fstore =FirebaseFirestore.instance;
          FirebaseAuth auth = FirebaseAuth.instance;

          if(testScore >=20) {
            await fstore.collection('User').doc(auth.currentUser?.uid).get()
                .then((datasnapshot) {
              // print(datasnapshot.data()!['name']);
              name = datasnapshot.data()!['name'];
              fromEmail = datasnapshot.data()!['email'];
              toEmail = datasnapshot.data()!['guardian_email'];
            });

            String emailContent = emailMessage;
            sendEmail(name: name,
                to: toEmail,
                from: fromEmail,
                message: emailContent);
          }
          showAlertDialog(context);
        },
        ),
    ]



    );


  }


  void add() {
    final DateFormat formatter = DateFormat("yyyy-MM-dd");
    final DateFormat formatterDoc = DateFormat("yyyyMMdd");
    String? currentID =FirebaseAuth.instance.currentUser?.uid;

    String docName = currentID! + formatterDoc.format(DateTime.now());

    FirebaseFirestore.instance
        .collection('depressionResult')
        .doc(docName)
        .set({
      'DocID':docName,
       'userID' :FirebaseAuth.instance.currentUser?.uid,
       'resultscore': testScore,
      'resultphrase': resultWord,
      'created': formatter.format(DateTime.now()),
    });



  }

  void showAlertDialog(BuildContext context) {
    print('Yes');
    AlertDialog alert =  AlertDialog(
      title: Text(dialogMessage),
      actions: [
        TextButton(
            child: Text('close'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> FunctionScreen()),
              );
            }
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
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



