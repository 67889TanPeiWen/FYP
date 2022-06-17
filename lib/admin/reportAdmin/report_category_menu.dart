import 'package:antibullying_suicideprevention/ReportBullying/viewReport.dart';
import 'package:antibullying_suicideprevention/admin/general/SidebarMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'caseDetail.dart';


class CasesCategory extends StatefulWidget {
  const CasesCategory({Key? key}) : super(key: key);

  @override
  State<CasesCategory> createState() => _CasesCategoryState();
}

class _CasesCategoryState extends State<CasesCategory> {

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
              Colors.greenAccent[100]!,
              Colors.blue,

            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: const SidebarMenuAdmin(),
          appBar: AppBar(title: Text('Bully Cases'),),
          body:  SingleChildScrollView(
            child: StreamBuilder(
              stream:  FirebaseFirestore.instance
                  .collection('bullyReports').
              orderBy('created',descending: true)
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

                    Timestamp ts = snapshot.data!.docs[i]['created'];
                    DateTime dt= DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch);
                    data.add(reportListData(bullyEvents: documents?.docs[i]['activities'], eventDate:dt, docID:documents?.docs[i]['DocID'], status: documents?.docs[i]['status']));
                  }

                  _groupMonthReports(data);
                  dataMonth =[];
                  print(Monthdata);

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
/*
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      String event = snapshot.data!.docs[index]['activities'];
                      String status =  snapshot.data!.docs[index]['status'];

                      Timestamp ts = snapshot.data!.docs[index]['created'];
                      DateTime dt= DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch);
                      String createdDate = DateFormat("dd/MM/yyyy hh:mm").format(dt);
                      String docID =  snapshot.data!.docs[index]['DocID'];


                      return listReport(index,event,createdDate,status,docID);
                    },



                  )
*/
                    ],
                  );

                }


              },
            ),


          )
      )
    );

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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text('Date: ' + DateFormat('dd/MM/yyyy hh:mm').format(dayReports.eventDate) ),
              Text('Status: '+ dayReports.status ),

            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),


          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>  caseDetail(docID: dayReports.docID,)),);
          },
        ));
  }

}
