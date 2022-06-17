import 'dart:ui';

import 'package:antibullying_suicideprevention/ReportBullying/reportBullyModel.dart';
import 'package:antibullying_suicideprevention/ReportBullying/reportDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class reportListYear{
  final String years;
  final List<reportListMonth> dataMonth;
  reportListYear({required this.years, required this.dataMonth});
}

class reportListMonth{
  final String month;
  final List<reportListData> data;
  reportListMonth({required this.month, required this.data});
}

class reportListData{
  final String bullyEvents;
  final DateTime eventDate;
  final String docID;
  final String status;

  reportListData( {required this.bullyEvents, required this.eventDate, required this.docID,required this.status,});
}


class ViewReport extends StatefulWidget {
  const ViewReport({Key? key}) : super(key: key);
  @override
  State<ViewReport> createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> {

Map<String, List<reportListData>> Monthdata = {};
Map<String, List<reportListMonth>> YearData = {};

List<reportListMonth> dataMonth =[];
List<reportListYear> dataYear =[];


_groupMonthReports(List<reportListData> dayReports){
  dayReports.forEach((element) {
    String date =DateFormat('yyyyMMMM').format(element.eventDate);
    print(element.eventDate);

    if (Monthdata[date] == null) Monthdata[date] = [];
    Monthdata[date]?.add(element);

  });

}

_groupYearReport(List<reportListMonth> _monthReports){
  _monthReports.forEach((element) {
    String date = element.month.substring(0,4);
    if (YearData[date] == null) YearData[date] = [];
    YearData[date]?.add(element);
  });
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
        appBar: AppBar(title: Text('Reports'),),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream:  FirebaseFirestore.instance
                .collection('userReportHistory')
                .where('userID',isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              else{
                List<reportListData> data =[];
                Monthdata.clear();
                YearData.clear();
                var documents =snapshot.data;
                for(int i =0; i<documents?.docs.length;i++){
                  DateTime date = DateTime.parse(documents?.docs[i]['date_incident']);
                  data.add(reportListData(bullyEvents: documents?.docs[i]['activities'], eventDate:date, docID:documents?.docs[i]['DocID'], status: documents?.docs[i]['status']));
                }

                _groupMonthReports(data);
                dataMonth =[];

                Monthdata.forEach((k, v) => dataMonth.add(reportListMonth( month: k, data:v,)));
                _groupYearReport(dataMonth);
                dataYear =[];
                YearData.forEach((k, v) => dataYear.add(reportListYear( years: k, dataMonth: v)));


                return Column(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: dataYear.map(buildYearTile).toList(),

                    ),

                  ],
                );

              }


            },
          ),


        )

    ),);

  }

Widget buildYearTile(reportListYear yearlyReports){
  return ListTileTheme(
    tileColor: Colors.red,
    child:ExpansionTile(
      title: Text(yearlyReports.years,style: TextStyle(color: Colors.white),),
      children: yearlyReports.dataMonth.map((tile) => buildTile(tile)).toList(),
    ),
  );
}


Widget buildTile(reportListMonth monthlyReports){
    return ListTileTheme(
      tileColor: Colors.grey[200],
      child:ExpansionTile(
      title: Text(monthlyReports.month.substring(4)),
      children: monthlyReports.data.map((tile) => buildListTile(tile)).toList(),
    ),
    );
  }


Widget buildListTile(reportListData dayReports){
  return  ListTileTheme(
    tileColor: Colors.white,
    child:  ListTile(
    title: Text(dayReports.bullyEvents),
    subtitle: Text('Date: ' + DateFormat('yyyy-MM-dd').format(dayReports.eventDate) ),
    trailing: const Icon(Icons.arrow_forward_ios_rounded),


    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>  viewReportDetail(docID:  dayReports.docID)),);


    },
  ),
  );

}

}
