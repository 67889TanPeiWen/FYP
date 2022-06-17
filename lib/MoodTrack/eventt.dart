import 'dart:convert';

import 'package:flutter/foundation.dart';

class Events{
  final String mood;
  final DateTime date;
  final String feeling;
  final String notes;
  final String userId;
  final String docID;
  final String urlRecord;

  Events({
    required this.docID,
    required this.mood,
    required this.feeling,
    required this.notes,
    required this.date,
    required this.userId,
    required this.urlRecord

  });


}

