import 'dart:convert';

import 'package:flutter/foundation.dart';

class ChartData{
  final DateTime date;
 final int result;
 // final String userID;

  ChartData({
  required this.date,
 required this.result,
  //  required this.userID,

  });
  factory ChartData.fromMap(Map data) {
    return ChartData(
     date: data['created'],
    result: data['resultscore'],
   //   userID: data['userID']
    );
  }

  factory ChartData.fromDS(String id, Map<String, dynamic> data){
    return ChartData(
      date:DateTime.parse(data['created']),
      result : data['resultscore'],
    //   userID: data['userID']

    );
  }

  Map<String, dynamic> toMap() => {
   'created': date,
   'resultscore': result,
    //'userID':    userID


};


  String toJson() => json.encode(toMap());

  factory ChartData.fromJson(String source) =>
      ChartData.fromMap(json.decode(source));








}

