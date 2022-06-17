import 'dart:ui';

import 'package:antibullying_suicideprevention/videoPlaying/videoModel.dart';
import 'package:antibullying_suicideprevention/videoPlaying/videoPlayingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:antibullying_suicideprevention/videoPlaying/Other/tabber_widget.dart';


class VideoMenu extends StatefulWidget {
  const VideoMenu({Key? key}) : super(key: key);

  @override
  State<VideoMenu> createState() => _VideoMenuState();
}

class _VideoMenuState extends State<VideoMenu> {

  int depressionLevel (String phrase){
    int level = 0;
    switch(phrase){
      case 'no depression':
        level =0;
        break;
      case 'mild depression':
        level =1;
        break;
      case 'moderate depression':
        level =2;
        break;
      case 'moderately severe depression':
        level =3;
        break;
      case 'severe depression':
        level =4;
        break;
    }
    return level;


  }


  //Video List
  Map<String, List<videoModel>> musicVideos = {};
  Map<String, List<videoModel>> breathVideos = {};
  Map<String, List<videoModel>> meditateVideos = {};

  List<videoModel> relaxVideoList =[];
  List<videoModel> breathVideoList =[];
  List<videoModel> meditateVideoList =[];



  _videoList( Map<String, List<videoModel>> map,List<videoModel> _videoData){
    _videoData.forEach((element) {
      if (map[element.type] == null) map[element.type] = [];
      map[element.type]?.add(element);
    });
  }


  @override
  Widget build(BuildContext context) => TabBarWidget(
    tabs: [
      Tab(text: 'Recommendation'),
      Tab(text: 'Discovery'),
      Tab(text: 'Playlist',)
    ],
    children: [
      recommendVideo(),
      discovery(),
      playList(),
    ],
  );


  Widget discovery(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        StreamBuilder(
          stream:  FirebaseFirestore.instance.collection('video').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            else {
              musicVideos.clear();
              breathVideos.clear();
              meditateVideos.clear();

              relaxVideoList =[];
              breathVideoList =[];
              meditateVideoList =[];

              var documents = snapshot.data;
              for(int i =0; i<documents?.docs.length;i++){
                String type =documents?.docs[i]['type'];
                String title =documents?.docs[i]['title'];
                String thumb =documents?.docs[i]['thumb'];
                String location =documents?.docs[i]['location'];
                print(thumb);

                if( documents?.docs[i]['type']=='music') {
                  relaxVideoList.add(videoModel(thumb:thumb, location: location, type: type, title: title));
                }

                else if( documents?.docs[i]['type']=='breathing') {
                  breathVideoList.add(videoModel(thumb:thumb, location: location, type: type, title: title));
                }
                else
                {
                  meditateVideoList.add(videoModel(thumb:thumb, location: location, type: type, title: title));
                }


              }
              return DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: const TabBar(
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(text: 'Music'),
                        Tab( text: 'Breathing Technique'),
                        Tab(text: 'Mediation'),
                      ],
                    ),
                  ),
                  Container(
                    height: 500,
                    decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                    ),
                    child:  TabBarView(
                      children: [
                        buildRelaxMusic(),
                        buildBreathTech(),
                        buildMediate(),

                      ],
                    ),
                  )
                ],
              ),
            );
            }
          },
        ),
      ],
    );

  }
  Widget recommendVideo(){
    return  SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('depressionResult')
              .where('userID',isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .orderBy('created',descending: false)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {


            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            else{

              return Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('video')
                        .where('level',isEqualTo: depressionLevel(snapshot.data?.docs.last['resultphrase']))
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic>  snap) {

                      if (!snap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      else{

                        return  Column(children: [

                          Container(
                            padding: EdgeInsets.only(top: 20),
                            alignment: Alignment.topLeft,
                            child: Text('Recommended for you',style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),),

                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snap.data?.docs.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 20),
                                        tileColor: Colors.white54,
                                        selectedTileColor: Colors.blue,
                                        title: Row(
                                            children:[
                                              Image.network(snap.data?.docs[index]['thumb'],width:100),
                                              Container(
                                                padding: const EdgeInsets.only(left: 30),
                                                child:  Text(snap.data?.docs[index]['title'],style: const TextStyle(fontWeight: FontWeight.bold)),
                                              ),

                                            ]
                                        ),
                                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>  VideoPlaying(
                                            title: snap.data?.docs[index]['title'],
                                            filepath: snap.data?.docs[index]['location'],
                                            thumb: snap.data?.docs[index]['thumb'],)),);
                                        },
                                      ),
                                    );


                                  }
                              ),

                          ),


                        ],);

                      }
                    },
                  )
                ],);

            }

          },)

    );
  }

  Widget playList(){
    return SingleChildScrollView(
        child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('favouriteVideo')
        .where('userID',isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          else{
            return  Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20),
                          tileColor: Colors.white54,
                          selectedTileColor: Colors.blue,
                          title: Row(
                              children:[
                                Image.network(snapshot.data?.docs[index]['thumb'],width:100),
                                Container(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(snapshot.data?.docs[index]['video'],style: const TextStyle(fontWeight: FontWeight.bold)),

                                )

                              ]),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>  VideoPlaying(
                              title: snapshot.data?.docs[index]['video'],
                              filepath: snapshot.data?.docs[index]['location'],
                              thumb: snapshot.data?.docs[index]['thumb'],)),);
                          },
                        ),
                      );


                    }
                    ),

              ),
            ],);
          }
          },
        ));
  }


  Widget buildRelaxMusic() {
    return ListView(
      shrinkWrap: true,

      children:  relaxVideoList.map(buildMusicListTile).toList(),
    );
  }
  Widget buildBreathTech() {
    return ListView(
      children:  breathVideoList.map(buildBreathTechListTile).toList(),
    );
  }

  Widget buildMediate() {
    return ListView(
      children:  meditateVideoList.map(buildMediateListTile).toList(),
    );
  }

  Widget buildMusicListTile(videoModel relaxVideoList){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child:ListTile(
        //contentPadding: EdgeInsets.symmetric(vertical: 20),
        tileColor: Colors.white54,
        title: Row(
          children: [
            Image.network(relaxVideoList.thumb.toString(),width:100),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(relaxVideoList.title,style: const TextStyle(fontWeight: FontWeight.bold),),
            )
          ],
        ),
        trailing:  const Icon(Icons.arrow_forward_ios_rounded),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlaying(
            title: relaxVideoList.title,
            filepath: relaxVideoList.location,
            thumb: relaxVideoList.thumb,
              ))
          );
        },

      ),
    );

  }

  Widget buildBreathTechListTile(videoModel breathVideoList){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child:ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        tileColor: Colors.white54,
        selectedTileColor: Colors.blue,
        title: Row(
          children: [
            Image.network(breathVideoList.thumb.toString(),width:100),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(breathVideoList.title,style: const TextStyle(fontWeight: FontWeight.bold),),
            )
          ],
        ),
        trailing:  const Icon(Icons.arrow_forward_ios_rounded),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlaying(
            title: breathVideoList.title,
            filepath: breathVideoList.location,
            thumb: breathVideoList.thumb,
          ))
          );
        },

      ),
    );

  }

  Widget buildMediateListTile(videoModel meditateVideoList){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child:ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        tileColor: Colors.white54,
        selectedTileColor: Colors.blue,
        title: Row(
          children: [
            Image.network(meditateVideoList.thumb.toString(),width:100),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(meditateVideoList.title,style: const TextStyle(fontWeight: FontWeight.bold),),
            )
          ],
        ),
        trailing:  const Icon(Icons.arrow_forward_ios_rounded),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlaying(
            title: meditateVideoList.title,
            filepath: meditateVideoList.location,
            thumb: meditateVideoList.thumb,
          ))
          );
        },

      ),
    );

  }



}

