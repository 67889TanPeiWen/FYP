
import 'dart:ui';
import 'package:antibullying_suicideprevention/ReportBullying/MenuReport.dart';
import 'package:antibullying_suicideprevention/general/widget/general_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:antibullying_suicideprevention/depressionTest/Test.dart';
import 'package:antibullying_suicideprevention/videoPlaying/VideoMenu.dart';
import 'package:antibullying_suicideprevention/MoodTrack/calender.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';


class Data{
  final double date;
  final double result;

  Data(this.date, this.result);
}

class FunctionScreen extends StatefulWidget {
  const FunctionScreen({Key? key}) : super(key: key);

  @override
  State<FunctionScreen> createState() => _FunctionScreenState();
}

class _FunctionScreenState extends State<FunctionScreen> {

  final DateFormat formatter = DateFormat("dd/MM/yyyy");
  List<FlSpot> moodChartList = [];

  final mySpots = [1.0,23.0,4.0,5.0].asMap().entries
      .map((it) => FlSpot(it.key.toDouble(),it.value,))
      .toList();

  List<FlSpot> mapData(List<Data> data){
    return data.asMap().entries.map((e){
      final index =e.key;
      final myData =e.value;
      return FlSpot(index.toDouble(),myData.result);
    }).toList();

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
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          appBarMenu(context),
        ],

      ),

      body:  SingleChildScrollView(

        child: StreamBuilder(
          stream:  FirebaseFirestore.instance
              .collection('depressionResult')
              .where('userID',isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .orderBy('created',descending: false)
              .snapshots(),

          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting){
              return const Text('Waiting');
            }
            else if (snapshot.hasData){
              int moodChartScore = 0;
              moodChartList.clear();
              var documents = snapshot.data;
              for(int i =0; i<documents?.docs.length;i++){

                DateTime date =DateTime.parse(documents?.docs[i]['created']);
                DateTime moodDate = DateTime(date.year, date.month, date.day);
                moodChartScore =documents?.docs[i]['resultscore'];
                moodChartList.add(FlSpot(moodDate.microsecondsSinceEpoch.toDouble(),moodChartScore.toDouble()));


              }


            }

            return Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50,),
                  Center(child: const Text('Depression Level Tracking Graph',style: TextStyle(fontSize: 24),),),
                  const SizedBox(height: 10,),

                  Container(
                    color: Colors.white,
                    width:350,
                    height:200,
                    child: LineChart(
                      LineChartData(
                        maxY: 27.0,
                        minY: 0,
                        borderData: FlBorderData(
                            show: true,
                            border:  const Border(
                                left: BorderSide(
                                    width: 1
                                ),
                                bottom: BorderSide(
                                  width: 1,
                                )
                            )
                        ),

                        lineTouchData: LineTouchData(
                          getTouchedSpotIndicator:
                              (LineChartBarData barData, List<int>spotIndexes){
                            return spotIndexes.map((spotIndex){
                              final spot = barData.spots[spotIndex];
                              if(spot.x ==0){
                                return null;
                              }
                            }).toList();
                          },

                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.blueAccent,
                              getTooltipItems: (List<LineBarSpot> touchedBarSpots){
                                return touchedBarSpots.map((barSpot){
                                  final flSpot = barSpot;
                                  if(flSpot.x ==0){
                                    return null;
                                  }

                                  DateTime date =DateTime.fromMicrosecondsSinceEpoch(flSpot.x.toInt());

                                  return LineTooltipItem(
                                    'Date: ${formatter.format(date)} \n',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Result: '+flSpot.y.toString(),
                                        style: TextStyle(
                                          color: Colors.grey[100],
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),

                                    ],
                                    textAlign:  TextAlign.left,
                                  );

                                }).toList();
                              }
                            ),
                            enabled: true
                        ),



                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                              spots:   moodChartList,
                              isStepLineChart: false,
                              barWidth: 3,
                              dotData: FlDotData(
                                show: true,
                              ),
                              belowBarData: BarAreaData(
                                show: false,
                              )
                          )],

                        titlesData: FlTitlesData(
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),

                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 20,
                              getTitlesWidget: (v, meta) {
                                return const Text('');
                              },
                              showTitles: true,
                            ),),

                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 3,

                            ),),
                        ),


                        gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: false,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value){
                              if(value == 1) {
                                return FlLine(
                                    color: Colors.deepOrange
                                );
                              }
                              else{
                                return FlLine(
                                    color: Colors.grey
                                );
                              }
                            }
                        ),



                      ),

                    ),
                  ),

                  const SizedBox(height: 20,),
                  Container(
                    color: Colors.limeAccent,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Activities",style: TextStyle(fontSize: 30),)
                      ],
                    ),
                  ),
                  const SizedBox(height:10),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        eventButton(label:'Report bullying', context: context, pageRoute: const MenuBullying(),icon: 'assets/stop-bullying.png'),
                        eventButton(label:'Mood Journal', context: context, routeName: "/Calendar", pageRoute: const Calendar(),icon: 'assets/journal.png'),
                      ],
                    ),
                  ),
                  const SizedBox(height:20),

                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: [
                        eventButton(label:'Depression Test', context: context, pageRoute: const Test(),icon: 'assets/test.png'),
                        eventButton(label:'Relaxing video', context: context, pageRoute:  const VideoMenu(),icon: 'assets/film.png'),

                      ],
                    ),
                  ),


                ]
            );
          },),
      ),

    ),
    );

  }


  Widget eventButton({  label,  context,  pageRoute,routeName, required String icon}){
    return Column(
        children:[
          SizedBox.fromSize(
            size: const Size(70,70),
            child: Material(
              color: Colors.amber[400],
              child: InkWell(
                splashColor: Colors.amber[600],
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    settings: routeName ==''? null: RouteSettings(name: routeName),
                      builder: (context)=> pageRoute),);
                },
                child: Image.asset(icon,scale: 10,),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10,),
          Text(label,style: const TextStyle(fontSize: 16),),


        ]
    );
  }

}

