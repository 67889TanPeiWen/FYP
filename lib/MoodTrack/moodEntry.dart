import 'dart:io';
import 'dart:ui';
import 'package:antibullying_suicideprevention/MoodTrack/calender.dart';
import 'package:antibullying_suicideprevention/general/api/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';


class NewEntry extends StatefulWidget {
  final DateTime date;
  final String moodText;

  NewEntry({required this.date, required this.moodText});

  @override
  State<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {

  String? feeling;
  bool showOther = false;


  List<String> feelingList =['Happy','Sad','Angry','Unlucky','Lucky','Meh','Other'];

  TextEditingController feelController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String feel ='';

  final DateFormat formatter = DateFormat("yyyy-MM-dd");
  final DateFormat formatterDoc = DateFormat("yyyyMMdd");
  String fileName ='';

  @override
  void initState(){
    initRecorder();
    super.initState();
  }

  @override
  void dispose(){
    recorder.closeRecorder();
    super.dispose();
  }

  //Recording part
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  File? audioFile;
  UploadTask? audioTask;

  Future initRecorder() async{
    final status = await Permission.microphone.request();
    if(status!= PermissionStatus.granted){
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;

    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future record() async{
    String? currentID =FirebaseAuth.instance.currentUser?.uid;

    fileName = currentID! + DateTime.now().millisecondsSinceEpoch.toString()+'.aac';
    if(!isRecorderReady) return;
    await recorder.startRecorder(toFile: fileName);
    print(fileName);

  }

  Future stop() async{
    if(!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    audioFile = File(path!);
    print(audioFile);
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
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('New Entry'),),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 30,),
                      Container(
                        margin: EdgeInsets.only(bottom: 30.0),
                        child: Text("Date:     "+formatter.format(widget.date),style: TextStyle(fontSize: 20),),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 30.0),
                        child: Text("Mood:     "+widget.moodText,style: TextStyle(fontSize: 20),),
                      ),

                      StreamBuilder<RecordingDisposition>(
                        stream: recorder.onProgress,
                        builder: (context,snapshot){
                          final duration = snapshot.hasData? snapshot.data!.duration:Duration.zero;
                          
                          String twoDigits(int n) => n.toString().padLeft(2, "0");
                          final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
                          final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
                          return Text('$twoDigitMinutes:$twoDigitSeconds');
                        },
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                      ),
                        onPressed: () async {
                          if(recorder.isRecording){
                            await stop();
                            setState(() {});
                          } else{
                            await record();
                            setState(() {});
                          }
                          setState(() {});
                        },
                        child: Icon(recorder.isRecording? Icons.stop: Icons.mic,size: 80,),
                      ),



                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child:  Text("Feelings",textAlign: TextAlign.left,style: TextStyle(fontSize: 20),),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonFormField<String>(
                                iconSize: 20,
                                value: feeling,
                                items: feelingList.map(buildMenuItem).toList(),
                                onChanged: (value) => setState(() {
                                  feeling = value;
                                  showOther = false;

                                  if(value =='Other'){
                                    showOther = true;
                                    feelController.text = '';
                                  }
                                  feel = feeling!;
                                }),
                                decoration: const InputDecoration(
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
                              )
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),

                            child: showOther == false ? null : TextFormField(
                              controller:feelController,
                              decoration: const InputDecoration(
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
                            ),
                          ),

                          SizedBox(height: 50,),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child:  Text("Notes",textAlign: TextAlign.left,style: TextStyle(fontSize: 20),),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),

                            child:  TextFormField(
                              controller:noteController,
                              maxLines: 4,
                              minLines: 1,

                              decoration: const InputDecoration(
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
                            ),
                          ),
                          SizedBox(height: 20,),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: ElevatedButton (
                                child: Text('Save Entry'),
                                onPressed:() async{
                                  String url ='';

                                  url =await uploadAudio();
                                  showDialog(
                                      context: context,
                                    builder: (BuildContext context)=>AlertDialog(
                                      content: Text('Created Successful'),
                                      actions: [
                                        TextButton(
                                            child: Text('ok'),
                                            onPressed: () {
                                              print(url);
                                              String? currentID =FirebaseAuth.instance.currentUser?.uid;
                                              String docID =currentID!+formatterDoc.format(widget.date);

                                               FirebaseFirestore.instance
                                                  .collection('moodJournal')
                                                  .doc(docID)
                                                  .set({
                                                'id': docID,
                                                'userID': currentID,
                                                'recording':url,
                                                'mood': widget.moodText,
                                                'date': formatter.format(widget.date),
                                                'feelings':feel == 'Other'? feelController.text : feel,
                                                'notes':noteController.text,
                                                'created': DateTime.now()});

                                              setState(() {});
                                              Navigator.of(context).popUntil(ModalRoute.withName("/Calendar"));


                                              //Navigator.push(context,MaterialPageRoute(builder: (context)=> Calendar()));
                                            }
                                        ),
                                      ],
                                    ),
                                  );

                                }
                            ),
                          )
                        ],
                      ),

                    ],

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<String> uploadAudio() async{
    if (audioFile == null) return'';
    final imageFile = basename(audioFile!.path);
    String destination = 'files/audio/$imageFile';
    audioTask=  FirebaseApi.uploadAudio(destination, audioFile!);
    if(audioTask == null)return'';
    final snapshot = await audioTask!.whenComplete((){});
    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }


  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(item),
  );

}

