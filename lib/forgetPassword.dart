import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgetPassword extends StatefulWidget {
  const forgetPassword({Key? key}) : super(key: key);

  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
  final forgetKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

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
        appBar: AppBar(title: Text('Reset password')),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children:[
                              SizedBox(height:10),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.lock,size: 70)
                                ],
                              ),
                              SizedBox(height:10),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  children: [

                                  ],
                                ),
                              ),

                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Column(
                                      children:[

                                        Form(
                                          key: forgetKey,

                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: emailController,
                                                decoration: const InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  labelText: 'Email',
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
                                                    return 'Pleas enter email';
                                                  }
                                                  return null;
                                                },
                                              ),

                                            ],
                                          ),
                                        )
                                      ]
                                  )
                              ),
                              SizedBox(height:10),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  padding: EdgeInsets.only(top: 3,left: 3),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),),
                                  child: ElevatedButton(
                                    child: const Text( 'Reset Password',style: TextStyle(fontSize : 20),),
                                    onPressed: () async {
                                      await FirebaseAuth.instance.sendPasswordResetEmail(
                                          email: emailController.text.trim());
                                    },
                                  ),
                                ),
                              ),


                            ],
                          ),
                        ])
                )
            )
        ),
      )
    );
  }
}
