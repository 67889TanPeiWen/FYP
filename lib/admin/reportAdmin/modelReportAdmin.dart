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
  final String status;
  final DateTime eventDate;
  final String docID;

  reportListData({required this.bullyEvents, required this.eventDate, required this.docID, required this.status});
}
