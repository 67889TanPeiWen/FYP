import 'package:flutter/material.dart';
import 'package:antibullying_suicideprevention/depressionTest/Answer.dart';
import 'package:antibullying_suicideprevention/depressionTest/Question.dart';


class Quiz extends StatelessWidget {
  final List<Map<String,Object>>questions;
  final int questionNum;
  final Function answerQuestion;

  Quiz({Key ? key, required this.questions, required this.questionNum, required this.answerQuestion});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //To show question
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),

        ),
        SizedBox(height: 20,),

        Question(questions[questionNum]['questionText'] as String),
        ...(questions[questionNum]['answers'] as List<Map<String, Object>>)
        .map((answer){
          return Answer(()=> answerQuestion(answer['score']),answer['text'] as String);
        }).toList()
      ]
    );
  }
}
