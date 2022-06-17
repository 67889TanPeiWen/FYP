import 'dart:ui';

import 'package:antibullying_suicideprevention/admin/adminHome.dart';
import 'package:antibullying_suicideprevention/admin/reportAdmin/caseDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ViewMyCaseDetail extends StatefulWidget {
  final String docID;

  const ViewMyCaseDetail({Key? key, required this.docID}) : super(key: key);

  @override
  State<ViewMyCaseDetail> createState() => _ViewMyCaseDetailState();
}

class _ViewMyCaseDetailState extends State<ViewMyCaseDetail> {
  String? caseStatus ;
  String status ='';
  List<String> statusList =['In progress','Completed'];

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
        appBar: AppBar(title: Text('Report Detail'),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async{
                final confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Warning'),
                    content: Text('Are you sure you want to delete?'),
                    actions: [
                      TextButton(
                          child: Text('Delete'),
                          onPressed: () => Navigator.pop(context,true)
                      ),
                      TextButton(
                          child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700),),
                          onPressed: () => Navigator.pop(context,false)
                      ),
                    ],
                  ),) ?? false;
                print(confirm);
                if(confirm){
                  await FirebaseFirestore.instance.collection('Cases').doc(widget.docID).delete();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> adminHome()),
                  );
                }
              },

            )
          ],

        ),
        body: SingleChildScrollView(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('bullyReports')
                  .doc(widget.docID)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                else{
                  var document = snapshot.data;
                  caseStatus  =document['status'];

                  return Column(
                    children: [
                      Form(child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          const SizedBox(height: 10,),
                          Text(document['activities'], style: TextStyle(fontSize: 30, fontWeight:FontWeight.bold),),
                          const SizedBox(height: 20,),
                          Container(
                            alignment: Alignment.center,
                            child: document['image']== '' ? null : Image.network(document['image'],scale:10,),
                          ),

                          const SizedBox(height: 20,),

                          DropdownButtonFormField<String>(
                            iconSize: 20,
                            value: caseStatus,
                            items:statusList.map(buildMenuItem).toList(),
                            onChanged: (value) => setState((){
                              caseStatus = value;
                              status = caseStatus!;

                            } ),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Status',
                              contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10,),

                          reportField(label: 'Reporter',value: document['reporter'] =='' ? 'Anonymous':document['reporter']),
                          reportField(label: 'Bully name',value:document['bully_name']),
                          reportField(label: 'Location',value:document['venue']),
                          reportField(label: 'Date of incident',value:document['date_incident']),
                          reportField(label: 'Description',value:document['description'] =='' ? ' ': document['description']),
                          reportField(label: 'Case Handler',value:document['holder']),

                          const SizedBox(height: 10,),
                          Container(alignment: Alignment.center,
                            child:ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                              ),
                              onPressed: () async {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const adminHome()),);
                                await FirebaseFirestore.instance.collection('bullyReports').doc(document['DocID']).update(
                                    {
                                      'status': status,
                                    });
                                await FirebaseFirestore.instance.collection('Cases').doc(document['DocID']).update(
                                    {
                                      'status': status,
                                    });
                              },
                              child: Text('Update'),),)


                        ],),)

                    ],
                  );
                }

              },)


        ),

      ),
    );


  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(item),
  );


  Widget reportField({required String label,value}){
    return Column(
      children: [
        Container(
          // padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            readOnly: true,
            initialValue: value,
            decoration:  InputDecoration(
              // label: Text(label),
              filled: true,
              fillColor: Colors.white,
              prefixText: label + ": ",
              contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal:20),
              // border: const OutlineInputBorder(),
            ),
          ),
        )
      ],
    );

  }


}
