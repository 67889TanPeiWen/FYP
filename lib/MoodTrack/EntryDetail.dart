import 'dart:io';
import 'dart:ui';

import 'package:antibullying_suicideprevention/MoodTrack/calender.dart';
import 'package:antibullying_suicideprevention/MoodTrack/editEntry.dart';
import 'package:antibullying_suicideprevention/MoodTrack/eventt.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';


class EntryDetail extends StatefulWidget {
  Events events;

  EntryDetail({Key? key, required this.events}) : super(key: key);

  @override
  State<EntryDetail> createState() => _EntryDetailState();
}

class _EntryDetailState extends State<EntryDetail> {

  //Audio Player
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration =Duration.zero;
  Duration position = Duration.zero;

  String moodAssetPath(String mood){
    switch(mood){
      case 'Awesome': {
        return 'assets/MoodIcons/Excited_Smiley_Face.svg';
      }
      case 'Good': {
        return 'assets/Happy_Face.svg';
      }
      case 'Neutral': {
        return 'assets/Neutral_Face.svg';
      }
      case 'Bad': {
        return 'assets/Bad_Face.svg';
      }
      case 'Awful': {
        return 'assets/Awful_Face.svg';
      }
    }
    return '';
  }
  Color moodColor(String mood){
    switch(mood){
      case 'Awesome': {
        return Colors.green;
      }
      case 'Good': {
        return Colors.lightGreen;
      }
      case 'Neutral': {
        return Colors.blue;
      }
      case 'Bad': {
        return Colors.orange;
      }
      case 'Awful': {
        return Colors.red;
      }
    }

    return Colors.transparent;
  }

  @override
  void initState(){
    super.initState();

    setAudio();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.PLAYING;
        });
      }
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });

  }

  Future setAudio()async{
    widget.events.urlRecord;
    final url =widget.events.urlRecord;
     audioPlayer.setUrl(url);

  }



  @override
  void dispose(){
    audioPlayer.dispose();
    super.dispose();
  }

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
            appBar: AppBar(
              title: Text('Entry Detail'),
              actions: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async{
                    final confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Warning'),
                        content: Text('Are you sure you want to delete?'),
                        actions: [
                          TextButton(
                              child: Text('Delete'),
                              onPressed: () => Navigator.pop(context,true)
                          ),
                          TextButton(
                              child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700),),
                              onPressed: () => Navigator.pop(context,false)
                          ),
                        ],
                      ),) ?? false;
                    print(confirm);
                    if(confirm){
                      await FirebaseFirestore.instance.collection('moodJournal').doc(widget.events.docID).delete();
                      if(widget.events.urlRecord !='') {
                        FirebaseStorage.instance.refFromURL(widget.events.urlRecord).delete();
                      }
                      Navigator.pop(
                        context,
                        MaterialPageRoute(builder: (context)=> Calendar()),
                      );
                    }
                  },

                )
              ],
            ),
            body:Column(children: [
              Container(
                color: Colors.white,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 10),
                    ListTile(
                      leading:SvgPicture.asset(
                        moodAssetPath(widget.events.mood),
                        height: 70.0,
                        width: 70.0,
                        color:  moodColor(widget.events.mood),
                      ),
                      title: Text(
                        widget.events.mood,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      subtitle:  Text(DateFormat("EEEE, dd MMMM, yyyy").format(widget.events.date)),
                    ),

                    SizedBox(height: 20),

                    ListTile(
                        leading: Text('Feelings :') ,
                        title: showFeeling()
                    ),

                    ListTile(
                        leading: Text('Notes :') ,
                        title: showNotes()
                    ),

                  ],
                ),
              ),


              Column(
                children: widget.events.urlRecord ==''? []:[
                 Slider(
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (double value) async{
                    final position = Duration(seconds: value.toInt());
                    await audioPlayer.seek(position);
                    await audioPlayer.resume();
                  },

                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                    children: [
                      Text(formatTime(position)),
                      Text(formatTime(duration-position)),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 35,
                  child: IconButton(
                    icon: Icon(isPlaying? Icons.pause:Icons.play_arrow),
                    iconSize: 50,
                    onPressed:() async{
                      if(isPlaying){
                        await audioPlayer.pause();
                      }
                      else{
                        await audioPlayer.resume();
                      }

                    },
                  ),
                )
              ],),
              ElevatedButton(
                  child: Text('Edit Entry'),
                  onPressed:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> EditEntry(event: widget.events)));
                  }
              )
            ],)

        )
    );
  }


  String formatTime(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if(duration.inHours>0) hours,
      minutes,
      seconds
    ].join(':');

  }
  Widget showFeeling(){
    if(widget.events.feeling.isNotEmpty)
      return  Text(widget.events.feeling);
    return Text('Empty');

  }

  Widget showNotes(){
    if(widget.events.notes.isNotEmpty)
      return  Text(widget.events.notes);
    return Text('Empty');

  }
}
