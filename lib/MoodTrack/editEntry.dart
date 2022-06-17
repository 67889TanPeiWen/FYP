import 'dart:io';
import 'dart:ui';

import 'package:antibullying_suicideprevention/MoodTrack/EntryDetail.dart';
import 'package:antibullying_suicideprevention/MoodTrack/calender.dart';
import 'package:antibullying_suicideprevention/general/api/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:antibullying_suicideprevention/MoodTrack/eventt.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';

class EditEntry extends StatefulWidget {
  Events event;
  EditEntry({Key? key, required this.event}) : super(key: key);

  @override
  State<EditEntry> createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  TextEditingController feelController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  List<String> feelingList =['Happy','Sad','Angry','Unlucky','Lucky','Meh','Other'];
  String? feeling;
  String feelingSelected ='';
  bool showOther = false;

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
  String fileName ='';

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
        appBar: AppBar(title:Text('Edit Entry Detail')),
        body: Column(
          children: [
            SizedBox(height: 10,),
            Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

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


                    const Text('Feeling', style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5,),

                    DropdownButtonFormField<String>(
                      iconSize: 20,
                      value: feeling,
                      hint:  Text(widget.event.feeling),
                      items: feelingList.map(buildMenuItem).toList(),
                      onChanged: (value) => setState((){
                        feeling = value;
                        feelingSelected = feeling!;
                        showOther = false;

                        if(value =='Other'){
                          showOther = true;
                          feelController.text = '';
                        }

                      } ),
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
                    Container(
                      child: showOther == false ? null : Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5,),
                              TextFormField(
                                controller: feelController,
                                decoration:  const InputDecoration(
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

                            ],)
                      ),
                    ),

                  ],)
            ),
            SizedBox(height: 30,),
            editField(initValue: widget.event.notes, fieldLabel: 'Description', textController: noteController),


            ElevatedButton(
                child: Text('Confirm'),
                onPressed:() async {
                  String url ='';
                  url =await uploadAudio();

                  showDialog(
                    context: context,
                    builder: (BuildContext context)=>AlertDialog(
                      content: Text('Updated Successful'),
                      actions: [
                        TextButton(
                            child: Text('ok'),
                            onPressed: () async {

                                FirebaseStorage.instance.refFromURL(widget.event.urlRecord).delete();
                              await FirebaseFirestore.instance.collection('moodJournal').doc(widget.event.docID).update(
                                  {
                                    'feelings': feelingSelected == ''?  widget.event.feeling : feelingSelected == 'Other'? feelController.text: feelingSelected,
                                    'notes': noteController.text.isEmpty  ? widget.event.notes : noteController.text,
                                    'recording': url,

                                  });

                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Calendar()));
                            }
                        ),
                      ],
                    ),
                  );


                }
            )

          ],
        ),
      ),
    ) ;

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


}

Widget editField( { initValue,required String fieldLabel, required TextEditingController textController}){
  return  Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(fieldLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5,),

          TextFormField(
            maxLines: 3,
            minLines: 1,
            controller: textController,
            decoration:  InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText:  initValue =='' ?  'Empty':initValue,
              contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              border: const OutlineInputBorder(),
            ),
          ),

        ],)
  );
}


DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
  value: item,
  child: Text(item),
);





