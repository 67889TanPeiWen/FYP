
import 'dart:io';

import 'package:antibullying_suicideprevention/ReportBullying/MenuReport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../../FunctionScreen.dart';
import '../../general/api/firebase_api.dart';
class ReportBully extends StatefulWidget {
  const ReportBully({Key? key}) : super(key: key);

  @override
  State<ReportBully> createState() => _ReportBullyState();
}

class _ReportBullyState extends State<ReportBully> {
  final bullyFormKey = GlobalKey<FormState>();
  String? location;
  String? event;
  String docID ='';
  File? image;
  bool showOther = false;

  String locationSaved = '';


  bool isAnonymous = false;
  final currentYear = DateTime.now().year;
  final destination = '';
  final venueList = ['FIT','CAIS','Kolej Dahlia','Kolej Allamanda','Kolej Sakura','Kolej Cempaka','Other'];
  final bullyEvent = ['Physical bullying','Cyberbullying'];

  TextEditingController _bullyNameControl = TextEditingController();
  TextEditingController _venueControl = TextEditingController();
  final TextEditingController _dateControl = TextEditingController();
  TextEditingController _descriptioneControl = TextEditingController();

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);

    }on PlatformException catch(e){
      print('Failed to pick image: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bully Report')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: bullyFormKey,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Container(
                      child: const Text ("Report Form", style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),
                    ),
                      SizedBox(height: 30,),

                      Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40
                      ),
                      child: Column(
                        children: [
                          reportFormField(label:'Bully name', control: _bullyNameControl),
                          const SizedBox(height: 10,),
                          DropdownButtonFormField<String>(
                            value: event,
                            iconSize: 20,
                            items: bullyEvent.map(buildMenuItem).toList(),
                            onChanged: (value) => setState(() => event = value),
                            validator: (value) => value == null ? 'field required' : null,
                            decoration: const InputDecoration(
                              labelText: 'Bullying Activities',
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

                          DropdownButtonFormField<String>(
                            value: location,
                            iconSize: 20,
                            items: venueList.map(buildMenuItem).toList(),
                            onChanged: (value) => setState(() {
                              location = value;
                              showOther = false;
                              locationSaved = location!;
                              if(location == 'Other'){
                                showOther = true;
                                _venueControl.text ='';
                              }
                            }),
                            validator: (value) => value == null ? 'field required' : null,
                            decoration: const InputDecoration(
                              labelText: 'Location',
                              contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Container(
                            child: showOther == false? null: reportFormField(control: _venueControl),
                          ),
                        //  reportFormField(label:'Venue', control: _venueControl),
                          const SizedBox(height: 10,),

                          TextFormField(
                            readOnly: true,
                            controller: _dateControl,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.calendar_today_rounded),
                              labelText: 'Date of incident',
                              contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              DateTime? pickDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:DateTime(currentYear),
                                lastDate: DateTime(2050),
                              );
                              if(pickDate!=null){
                                setState(() {
                                  _dateControl.text = DateFormat("yyyy-MM-dd").format(pickDate);

                                });
                              }

                            },

                            validator: (date){
                              if(date!.isEmpty) {
                                return 'Field is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10,),

                          TextFormField(
                            controller: _descriptioneControl,
                            minLines: 6,
                            keyboardType:  TextInputType.multiline,
                            maxLines: 6,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children:[
                        SizedBox(width: 40,),

                        image != null? Image.file(image!,scale: 10.0) :  Icon(Icons.add_a_photo,size: 70,),
                        SizedBox(width: 40,),

                        ElevatedButton(
                            child: Text('Add photo'),
                        onPressed: () => pickImage(),

                      ),

                      ]
                    ),

                    Row(
                        children:[
                          SizedBox(width: 40,),

                          Container(
                            alignment: Alignment.centerLeft,
                            child:Switch(
                              value: isAnonymous,
                              onChanged: (value) {
                                setState(() {
                                  isAnonymous= value;
                                });
                                },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ),
                          Text('Report as Anonymous'),
                        ]),
                    ElevatedButton(
                      child: Text("Submit"),
                      onPressed: (){
                        if(bullyFormKey.currentState!.validate()){
                          uploadFile(destination);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              content: Text('Submit Successful'),
                              actions: [
                                TextButton(
                                  child: Text('ok'),
                                  onPressed: ()  async {
                                    String? currentID =FirebaseAuth.instance.currentUser?.uid;

                                    String reporter ='';
                                    if(isAnonymous == false) {
                                          await FirebaseFirestore.instance
                                              .collection('User')
                                              .doc(currentID)
                                              .get()
                                              .then((value) {
                                            reporter = value.data()?['name'];
                                          });
                                        }

                                        String url ='';
                                    if(image != null){
                                      String fireImagePath =basename(image!.path);
                                      var ref = FirebaseStorage.instance.ref('files/$fireImagePath');
                                      url = await ref.getDownloadURL();
                                    }

                                    add(url,reporter);

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FunctionScreen()),);
                                  }
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    )
                  ],


                ),
)              ],
            ),
          ),
        ),
      ),
    );
  }


  void add(String url,String reporter) {
    final DateFormat formatter = DateFormat("yyyy-MM-dd");
    final DateFormat formatterDoc = DateFormat("yyyyMMdd");
    String? currentID =FirebaseAuth.instance.currentUser?.uid;
    String eventCode ='';
    if(event == 'Physical bullying'){
      eventCode ='PB';
    }
    else if(event =='Cyberbullying'){
      eventCode ='CB';
    }
    else{
      eventCode ='O';
    }
    DateTime createdTime = DateTime.now();


    String caseID = eventCode + createdTime.microsecondsSinceEpoch.toString();

    FirebaseFirestore.instance.collection('bullyReports').doc(caseID).set({
      'DocID':caseID,
      'userID' :FirebaseAuth.instance.currentUser?.uid,
      'bully_name': _bullyNameControl.text,
      'activities': event,
      'venue': locationSaved == 'Other'? _venueControl.text : locationSaved,
      'date_incident' : _dateControl.text,
      'description': _descriptioneControl.text,
      'isAnonymous': isAnonymous,
      'reporter': reporter,
      'image': url,
      'status': 'Not assigned',
      'holder': 'None',
      'created': DateTime.now(),
    });


    FirebaseFirestore.instance.collection('userReportHistory').doc(caseID).set({
      'DocID':caseID,
      'userID' :FirebaseAuth.instance.currentUser?.uid,
      'bully_name': _bullyNameControl.text,
      'activities': event,
      'venue': locationSaved == 'Other'? _venueControl.text : locationSaved,
      'date_incident' : _dateControl.text,
      'description': _descriptioneControl.text,
      'isAnonymous': isAnonymous,
      'reporter': reporter,
      'image': url,
      'status': 'Not assigned',
      'holder': 'None',
      'created': DateTime.now(),
    });



  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(item),
  );


  Future uploadFile(String destination) async{
    if (image == null) return;
    final imageFile = basename(image!.path);
    destination = 'files/$imageFile';
    FirebaseApi.uploadImage(destination, image!);
  }
}


Widget reportFormField({label,control}){
  return  TextFormField(
    controller: control,
    decoration: InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      border: const OutlineInputBorder(),
    ),
    validator: (value){
      if(value!.isEmpty) {
        return 'Field is required';
      }
      return null;
    },
  );
}


