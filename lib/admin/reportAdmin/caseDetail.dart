import 'dart:ui';

import 'package:antibullying_suicideprevention/admin/adminHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class caseDetail extends StatefulWidget {
  final String docID;

  const caseDetail({Key? key, required this.docID}) : super(key: key);

  @override
  State<caseDetail> createState() => _caseDetailState();
}

class _caseDetailState extends State<caseDetail> {
  String? caseHolder;

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
      appBar: AppBar(title: Text('Case Detail'),
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
                await FirebaseFirestore.instance.collection('bullyReports').doc(widget.docID).delete();
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
                String reporter =document['reporter'];
                return Column(
                  children: [
                    Form(child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        const SizedBox(height: 30,),
                        Text(document['activities'], style: TextStyle(fontSize: 30, fontWeight:FontWeight.bold),),
                        const SizedBox(height: 20,),
                        Container(
                          alignment: Alignment.center,
                          child: document['image']== '' ? null : Image.network(document['image'],scale:10,),
                        ),
                        const SizedBox(height: 20,),


                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('User')
                              .where('role', isEqualTo: 'admin')
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if(!snapshot.hasData){
                              return Center(child: CircularProgressIndicator());
                            }
                            else{
                              var documents = snapshot.data;
                              List<String> caseHolderList = [];
                              for(int i=0 ; i<documents?.docs.length;i++){
                                print(documents?.docs[i]['name']);
                                caseHolderList.add(documents?.docs[i]['name']);
                              }
                              return  DropdownButtonFormField<String>(
                                iconSize: 20,
                                value: caseHolder,
                                items: caseHolderList.map(buildMenuItem).toList(),
                                onChanged: (value) => setState(() => caseHolder = value),
                                validator: (value) => value == null ? 'field required' : null,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'Case Handler',
                                  contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              );

                            }


                          },),
                        const SizedBox(height: 20,),

                        reportField(label: 'Reporter',value: document['reporter'] =='' ? 'Anonymous':document['reporter']),
                        reportField(label: 'Bully name',value:document['bully_name']),
                        reportField(label: 'Location',value:document['venue']),
                        reportField(label: 'Date of incident',value:document['date_incident']),
                        reportField(label: 'Description',value:document['description'] =='' ? ' ': document['description']),


                        const SizedBox(height: 10,),
                        Container(alignment: Alignment.center,
                          child:ElevatedButton(
                            onPressed: ()  async {
                              await FirebaseFirestore.instance.collection('bullyReports').doc(document['DocID']).update(
                                  {
                                    'status': 'In progress',
                                    'holder': caseHolder,

                                  });

                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const adminHome()),);
                              FirebaseFirestore.instance.collection('Cases').doc(document['DocID']).set({
                                'DocID':document['DocID'],
                                'userID' :document['userID'],
                                'bully_name': document['bully_name'],
                                'activities': document['activities'],
                                'venue': document['venue'],
                                'date_incident' :document['date_incident'],
                                'description': document['description'],
                                'isAnonymous': document['isAnonymous'],
                                'reporter': document['reporter'],
                                'image': document['image'],
                                'status': 'In progress',
                                'holder': caseHolder,
                                'created': document['created'],
                                'updated': DateTime.now(),
                              });
                            },
                            child: Text('Confirm'),),)


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
              filled: true,
             fillColor: Colors.white,
             // label: Text(label),
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
