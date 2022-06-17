import 'package:antibullying_suicideprevention/FunctionScreen.dart';
import 'package:antibullying_suicideprevention/ReportBullying/reportBullyModel.dart';
import 'package:antibullying_suicideprevention/general/api/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class viewReportDetail extends StatefulWidget {
  final String docID;
  const viewReportDetail({Key? key, required this.docID}) : super(key: key);

  @override
  State<viewReportDetail> createState() => _viewReportDetailState();
}

class _viewReportDetailState extends State<viewReportDetail> {

  String _urlImage='' ;



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
      child:   Scaffold(
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
                  await FirebaseFirestore.instance.collection('userReportHistory').doc(widget.docID).delete();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> FunctionScreen()),
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
                  print(document['image']);

                  return Column(
                    children: [
                      Form(child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          const SizedBox(height: 30,),
                          Container(
                            child: document['image']== '' ? null : Image.network(document['image'],scale:10,),
                          ),
                          const SizedBox(height: 10,),

                          reportField(label:'Event',value:document['activities']),
                          reportField(label:'Reported as anonymous ',value:document['isAnonymous'] == true? 'Yes' : 'No'),
                          reportField(label:'Bully name',value:document['bully_name']),
                          reportField(label:'Location',value:document['venue']),
                          reportField(label:'Date of incident',value:document['date_incident']),
                          reportField(label:'Description',value:document['description'] == ''? ' ' : document['description']),




                        ],),)

                    ],
                  );
                }

              },)


        ),

      ),
    );
    Scaffold(
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
                await FirebaseFirestore.instance.collection('userReportHistory').doc(widget.docID).delete();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> FunctionScreen()),
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
                print(document['image']);

                return Column(
                  children: [
                    Form(child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: [
                        const SizedBox(height: 30,),
                        Container(
                          child: document['image']== '' ? null : Image.network(document['image'],scale:10,),
                        ),
                        const SizedBox(height: 10,),

                        reportField(label:'Event',value:document['activities']),
                        const SizedBox(height: 10,),
                        reportField(label:'Bully name',value:document['bully_name']),
                        const SizedBox(height: 10,),
                        reportField(label:'Location',value:document['venue']),
                        const SizedBox(height: 10,),
                        reportField(label:'Date of incident',value:document['date_incident']),
                        const SizedBox(height: 10,),
                        reportField(label:'Description',value:document['description'] == ''? ' ' : document['description']),




                      ],),)

                  ],
                );
              }

            },)


      ),

    );

  }

}


Widget reportField({required String label,value}){
  return  TextFormField(
    readOnly: true,
    initialValue: value,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      prefixText: label + ": ",
      contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
    ),
    validator: (value){
      if(value!.isEmpty) {
        return 'Field is required';
      }
      return null;
    },
  );
}
