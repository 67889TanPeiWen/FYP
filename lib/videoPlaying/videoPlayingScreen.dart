import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:antibullying_suicideprevention/videoPlaying/videoPlayer.dart';
import 'package:video_player/video_player.dart';


class VideoPlaying extends StatefulWidget {
  final String filepath;
  final String title;
  final String thumb;

  const VideoPlaying({Key? key, required this.title, required this.filepath, required this.thumb}) : super(key: key);

  @override
  State<VideoPlaying> createState() => _VideoPlayingState();
}

class _VideoPlayingState extends State<VideoPlaying> {
  late VideoPlayerController controller;
  bool isFavor =false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset(widget.filepath)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_){setState(() {});});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  void toggleFavorite(){
    setState(() {
      if(isFavor){
        isFavor=false;
      }
      else{
        isFavor=true;

      }

    });
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = controller.value.volume == 0;

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
      child:   Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            const SizedBox(height: 32),

            VideoPlayerWidget(controller: controller),
            const SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              color: Colors.white70,
              child:   Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller != null && controller.value.isInitialized)
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.red,
                      child: IconButton(
                        icon: Icon(
                          isMuted ? Icons.volume_mute : Icons.volume_up,
                          color: Colors.white,
                        ),
                        onPressed: () => controller.setVolume(isMuted ? 1 : 0),
                      ),
                    ),

                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('favouriteVideo')
                        .where('userID',isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .where('video',isEqualTo: widget.title)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(!snapshot.hasData){
                        return const Center(child: CircularProgressIndicator());
                      }
                      else{

                        String docID = '';

                        var document = snapshot.data;
                        if(document?.docs.length !=0){
                          isFavor = document?.docs[0]['isFavourite'];
                          docID =document?.docs[0]['DocID'];
                        }
                        else{
                          isFavor=false;
                        }

                        return  IconButton(
                            icon:(isFavor?
                            Icon(Icons.favorite): Icon(Icons.favorite_border_outlined)),
                            color: Colors.red,
                            onPressed:() =>  setState(()  {
                              if(isFavor){
                                isFavor=false;
                                print(docID);
                                FirebaseFirestore.instance.collection('favouriteVideo').doc(docID).delete();

                              }
                              else{
                                isFavor=true;
                                String docName =  FirebaseFirestore.instance.collection('favouriteVideo').doc().id;

                                FirebaseFirestore.instance.collection('favouriteVideo').doc(docName).set({
                                  'DocID':docName,
                                  'userID' :FirebaseAuth.instance.currentUser?.uid,
                                  'video': widget.title,
                                  'location':widget.filepath,
                                  'thumb':widget.thumb,
                                  'isFavourite': true,
                                  'created': DateTime.now(),
                                });
                              }

                            })

                        );

                      }
                    },)
                ],
              )
            ),


          ],
        ),

      ),
    );


  }
}

