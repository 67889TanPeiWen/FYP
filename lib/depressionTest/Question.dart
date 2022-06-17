import 'package:flutter/material.dart';

class Question extends StatelessWidget {

  final String questionText;
  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(5.0,5.0),
                  blurRadius: 10.0,
                  spreadRadius: 2.0
              ),
            ],
          ),
        child: Text(questionText,
        style: TextStyle(fontSize: 20,),
        textAlign: TextAlign.center,),
        ),
        SizedBox(height: 30,)
    ]
    );
  }
}
