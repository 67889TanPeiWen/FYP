import 'package:flutter/material.dart';


class Answer extends StatelessWidget {
  final Function selectHandler;
  final String answerText;

  Answer(this.selectHandler,this.answerText);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
        width: double.infinity,
        child:ElevatedButton(
        child: Text(answerText, style: TextStyle(fontSize: 20)),
        onPressed: () => selectHandler(),
      ),
    ),
        SizedBox(height: 20,)

    ]);
  }
}
