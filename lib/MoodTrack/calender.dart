import 'dart:collection';
import 'dart:ui';

import 'package:antibullying_suicideprevention/FunctionScreen.dart';
import 'package:antibullying_suicideprevention/MoodTrack/CalendarDayBuild.dart';
import 'package:antibullying_suicideprevention/MoodTrack/EntryDetail.dart';
import 'package:antibullying_suicideprevention/MoodTrack/selectedMood.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:antibullying_suicideprevention/MoodTrack/eventt.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

import 'moodEntry.dart';


class _moodBarData{
  final Color color;
  final double value;
  final String moodType;

  const _moodBarData(this.color,this.value, this.moodType);
}


class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final DateTime now = DateTime.now();
  bool sameDate = true;

  FirebaseFirestore fstore =FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final DateFormat formatter = DateFormat("yyyy-MM-dd");

   Map<DateTime,List<Events>> selectedEvent ={};


  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay  = DateTime.now();
  DateTime _focusDay = DateTime.now();

  @override
  void initState(){
    selectedEvent ={ };
    super.initState();

  }

  List<Events> getEvents(DateTime date){
    return selectedEvent[date] ?? [];
  }


  Color mood_color(String mood) {
    switch (mood) {
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


  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }



  LinkedHashMap<DateTime, List<Events>> _groupedEvents = LinkedHashMap<DateTime,List<Events>>();

  List <Events> _selectedEvents =[];


  _groupEvents(List<Events> events) {
    _groupedEvents = LinkedHashMap(equals: isSameDate, hashCode: getHashCode);
    events.forEach((event) {
      DateTime date =
      DateTime(event.date.year, event.date.month, event.date.day);
      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      _groupedEvents[date]?.add(event);

    });
  }






  Stream<QuerySnapshot> eventsStream =
  FirebaseFirestore.instance.collection('moodJournal').where("userID", isEqualTo:FirebaseAuth.instance.currentUser?.uid).snapshots();
  Map<DateTime, String> dayBuild = {};

  bool isSameDate(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }


   var dataList = [];

  BarChartGroupData generateBarGroup(
      int x,
      Color color,
      double value,
      ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 16,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child:  Container(
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow[300]!,
            Colors.greenAccent[100]!,
            Colors.blue[300]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),),

      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Mood Journal"),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Mood Track'),
            Tab(text: 'Daily Journal'),
          ],),),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: StreamBuilder(
                stream:    FirebaseFirestore.instance.collection('moodJournal').where("userID", isEqualTo:FirebaseAuth.instance.currentUser?.uid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  else{
                    dayBuild.clear();
                    var documents =snapshot.data;
                    int awesome =0;
                    int good =0;
                    int neutral =0;
                    int bad =0;
                    int awful =0;

                    for(int i =0; i<documents?.docs.length; i++){
                      switch(documents?.docs[i]['mood']) {
                        case 'Awesome':
                          {
                            awesome = awesome + 1;
                            break;
                          }
                        case 'Good':
                          {
                            good = good + 1;
                            break;
                          }
                        case 'Neutral':
                          {
                            neutral = neutral + 1;
                            break;
                          }
                        case 'Bad':
                          {
                            bad = bad + 1;
                            break;
                          }
                        case 'Awful':
                          {
                            awful = awful + 1;
                            break;
                          }
                      }

                      dataList=[
                        _moodBarData(Colors.green, awesome.toDouble(),'Awesome'),
                        _moodBarData(Colors.lightGreen, good.toDouble(),'Good'),
                        _moodBarData(Colors.blue, neutral.toDouble(),'Neutral'),
                        _moodBarData(Colors.orange, bad.toDouble(),'Bad'),
                        _moodBarData(Colors.red, awful.toDouble(),'Awful'),

                      ];





                    }
                    return Column(
                        children:[
                          SizedBox(height: 70,),
                          Center(child: const Text('Mood Counter Graph',style: TextStyle(fontSize: 30),),),

                          SizedBox(
                              width: 400,
                              height: 350,
                              child: Padding(
                              padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 24, bottom: 12),
                              child:  documents?.docs.length == 0? const Center(child: Text('No Data',style: TextStyle(fontSize: 40)),): BarChart(

                                  BarChartData(
                                      titlesData: FlTitlesData(
                                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),

                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            reservedSize: 20,
                                            getTitlesWidget: (v, meta) {
                                              final index = v.toInt();
                                              return  Text(dataList[index].moodType, style: TextStyle(fontWeight: FontWeight.bold),);

                                            },
                                            showTitles: true,
                                          ),),

                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            interval: 5,

                                          ),),
                                      ),
                                      borderData: FlBorderData(
                                      border: const Border(
                                        top: BorderSide.none,
                                        right: BorderSide.none,
                                        left: BorderSide(width: 1),
                                        bottom: BorderSide(width: 1),
                                      )),

                                      groupsSpace: 10,
                                      barGroups: dataList.asMap().entries.map((e) {
                                        final index = e.key;
                                        print(index);
                                        final data = e.value;
                                        print(data);

                                        return generateBarGroup(index, data.color,data.value);
                                  }).toList()
                                  )
                                  ),


                            )

                          ),
                        ]

                    );





                  }
                },
              ),

            ),
            SingleChildScrollView(
              child: StreamBuilder(
                stream:  eventsStream,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                  if(snapshot.hasData){
                    dayBuild.clear();
                    var documents =snapshot.data;
                    List<Events> event =[];

                    for(int i =0; i<documents?.docs.length; i++){
                      DateTime dateEntry =DateTime.parse(documents?.docs[i]['date']);
                      dayBuild.addEntries( [MapEntry(dateEntry,documents?.docs[i]['mood']),]);
                      event.add(Events(
                          docID:documents?.docs[i]['id'],
                          mood:documents?.docs[i]['mood'],
                          feeling:documents?.docs[i]['feelings'],
                          notes:documents?.docs[i]['notes'],
                          date:dateEntry,
                          userId:documents?.docs[i]['userID'],
                          urlRecord:documents?.docs[i]['recording']

                      ),
                      );
                    }
                    _groupEvents(event);
                    DateTime selectedDate = _focusDay;
                    _selectedEvents = _groupedEvents[selectedDate] ?? [];
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        color: Colors.white54,
                        child: CalendarCarousel<Event>(
                          height: 400,
                          width: MediaQuery.of(context).size.width,
                          dayPadding: 3.0,
                          daysHaveCircularBorder: true,
                          thisMonthDayBorderColor: Colors.black,
                          isScrollable: false,
                          todayButtonColor: Colors.transparent,
                          todayBorderColor: Colors.pink[700]!,
                          selectedDayButtonColor: Colors.yellow[300]!,
                          selectedDayBorderColor:Colors.yellow[800]! ,
                          customDayBuilder: customBuilder,
                          selectedDateTime: _focusDay,

                          onDayPressed: (DateTime date, List<Event> events) {
                            setState(() {
                              _focusDay = date;
                              isSameDate(_focusDay,date);
                            } );

                          },

                        ),

                      ),

                      SizedBox(height: 20,),
                      _selectedEvents.isEmpty ?
                      ListTile(
                        tileColor: Colors.white70,
                        title: Text("No entry yet"),
                        trailing: Icon(Icons.add),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              settings: RouteSettings(name: "/SelectedMood"),
                              builder: (context)=>  SelectedMood(date: _focusDay)));},
                      ) :
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _selectedEvents.length,
                        itemBuilder: (BuildContext context, int index) {
                          Events moodEvent = _selectedEvents[index];
                          return ListTile(
                            tileColor: Colors.white70,
                            title: Text(moodEvent.mood),
                            subtitle: Text(formatter.format(moodEvent.date)),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context)=>  EntryDetail(events:moodEvent)),);
                            },
                          );
                        },),

                      Padding(
                          padding: EdgeInsets.only(top: 10,left: 3),
                          child: ElevatedButton(
                            child: Text('Go back to homepage'),
                            onPressed: () async {

                              Navigator.push(context, MaterialPageRoute(builder: (context)=>  FunctionScreen()),);


                            },)
                      )
                    ],);
                },
              ),

            ),
          ],
        )

      ),
    ),
  );



  Widget customBuilder(bool isSelectable, int index, bool isSelectedDay, bool isToday, bool isPrevMonthDay, TextStyle textStyle, bool isNextMonthDay, bool isThisMonthDay, DateTime day,)
  {
    final color = (dayBuild[day]!=null) ? mood_color(dayBuild[day]!) : Colors.transparent;
    if (!isToday && (!isThisMonthDay || day.millisecondsSinceEpoch > now.millisecondsSinceEpoch)) {
      return CalendarDay(
        child: Text(day.day.toString(), style: TextStyle(color: Colors.grey, fontSize: 12.0)),
        color: Colors.transparent,
        isToday: false,
      );
    } else {
      return CalendarDay(
        child: Text(day.day.toString(), style: TextStyle(color: textStyle.color, fontSize: 12.0)),
        color:  color ,
        isToday: isToday,
      );
    }
  }
}
