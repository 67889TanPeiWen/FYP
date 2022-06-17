import 'dart:ui';
import 'package:antibullying_suicideprevention/MoodTrack/mood.dart';
import 'package:antibullying_suicideprevention/MoodTrack/moodEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SelectedMood extends StatelessWidget {
  final DateTime date;
   String moodDesp ='';
  SelectedMood({required this.date});

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
        appBar: AppBar(title: Text('New Entry'),),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text("How was your day?", textAlign:TextAlign.center, style: TextStyle(fontSize: 20),),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              color: Colors.white,
              margin: EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: Mood.values.map((mood)=>
                    InkResponse(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            mood_icon(mood),
                            semanticsLabel: mood.toString(),
                            height: 70.0,
                            width: 70.0,
                            color:  mood_color(mood),
                          ),
                          Text(mood_name(mood),style: TextStyle(color: mood_color(mood)),)
                        ],
                      ),
                      onTap:(){
                        moodDesp = mood_name(mood);
                        Navigator.push(context, MaterialPageRoute(
                            settings: RouteSettings(name: "/NewEntry"),
                            builder: (context)=>NewEntry(date: date, moodText:mood_name(mood))));

                      },
                    ),
                ).toList(),
              ),
            )

          ],
        ),
      )
    );


  }
}
