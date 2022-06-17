import 'package:flutter/material.dart';
import 'package:antibullying_suicideprevention/depressionTest/Quiz.dart';
import 'package:antibullying_suicideprevention/depressionTest/Result.dart';
import 'package:mailer/mailer.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final _questions = const [
    {
      'questionText': 'Little interest or pleasure in doing things?',
      'answers': [
        {'text': 'Not at all', 'score': 0},
        {'text': 'Several days', 'score': 1},
        {'text': 'More than half the days', 'score': 2},
        {'text': 'Nearly every day', 'score': 3},
      ],
    },
    {
      'questionText': 'Feeling down, depressed, or hopeless?',
      'answers': [
        {'text': 'Not at all', 'score': 0},
        {'text': 'Several days', 'score': 1},
        {'text': 'More than half the days', 'score': 2},
        {'text': 'Nearly every day', 'score': 3},
      ],
    },
    {
      'questionText':
      'Trouble falling or staying asleep, or sleeping too much?',
      'answers': [
        {'text': 'Not at all', 'score': 0},
        {'text': 'Several days', 'score': 1},
        {'text': 'More than half the days', 'score': 2},
        {'text': 'Nearly every day', 'score': 3},
      ],
    },
    {
      'questionText': 'Feeling tired or having little energy?',
      'answers': [
        {'text': 'Not at all', 'score': 0},
        {'text': 'Several days', 'score': 1},
        {'text': 'More than half the days', 'score': 2},
        {'text': 'Nearly every day', 'score': 3},
      ],
    },
    {
      'questionText': 'Poor appetite or overeating?',
      'answers': [
        {'text': 'Not at all', 'score': 0},
        {'text': 'Several days', 'score': 1},
        {'text': 'More than half the days', 'score': 2},
        {'text': 'Nearly every day', 'score': 3},
      ],
    },
    {
      'questionText':
      'Feeling bad about yourself - or that you are a failure or have let yourself or your family down?',
      'answers': [
        {'text': 'Not at all', 'score': 0},
        {'text': 'Several days', 'score': 1},
        {'text': 'More than half the days', 'score': 2},
        {'text': 'Nearly every day', 'score': 3},
      ],
    },
    {
      'questionText':
      'Trouble concentrating on things, such as reading the newspaper or watching television?',
      'answers': [
        {'text': 'Not at all', 'score': 0},
        {'text': 'Several days', 'score': 1},
        {'text': 'More than half the days', 'score': 2},
        {'text': 'Nearly every day', 'score': 3},
      ],
    },
    {
      'questionText':
      'Moving or speaking so slowly that other people could have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?',
      'answers': [
        {'text': 'Not at all', 'score': 0},
        {'text': 'Several days', 'score': 1},
        {'text': 'More than half the days', 'score': 2},
        {'text': 'Nearly every day', 'score': 3},
      ],
    },
    {
      'questionText':
      'Thoughts that you would be better off dead, or of hurting yourself in some way?',
      'answers': [
        {'text': 'Not at all', 'score': 0},
        {'text': 'Several days', 'score': 1},
        {'text': 'More than half the days', 'score': 2},
        {'text': 'Nearly every day', 'score': 3},
      ],
    },
  ];

  var _questionIndex = 0;
  var _totalScore = 0;
  var _title = 'Question 1';
  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;

    print(_questionIndex);
    setState(() {
      if(_questionIndex <8) {
        _title ="Question " + (_questionIndex+2).toString();
      } else {
        _title ="Result";
      }
      _questionIndex = _questionIndex + 1;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow[400]!,
            Colors.indigo[600]!,

          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

        ),
      ),
      child:Scaffold(
        backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(_title),centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: _questionIndex < _questions.length?
              Quiz(questions: _questions, questionNum: _questionIndex, answerQuestion: _answerQuestion)
                  : Center(child: Result(_totalScore, _resetQuiz)),
            ),
          )
      ) ,
    ) ;

  }
}
