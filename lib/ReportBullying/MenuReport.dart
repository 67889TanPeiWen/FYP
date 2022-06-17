import 'package:antibullying_suicideprevention/ReportBullying/Reporting/FormReport.dart';
import 'package:antibullying_suicideprevention/ReportBullying/viewReport.dart';
import 'package:flutter/material.dart';

class MenuBullying extends StatelessWidget {
  const MenuBullying({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Container(
       decoration:  BoxDecoration(
         gradient: LinearGradient(
           colors: [
             Colors.yellow[400]!,
             Colors.indigo[600]!,

           ],
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,

         ),
       ),
       child:  Scaffold(
         backgroundColor: Colors.transparent,
           appBar: AppBar(title: Text('Report Bullying')),
           body: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children:  [

               Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: 5,
                 ),
                 child: MaterialButton(
                   minWidth: double.infinity,
                   child: const Text(
                     'I want to report',
                     style: TextStyle(fontSize: 30),
                   ),
                   height:60,
                   color: Colors.greenAccent,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(40)
                   ),
                   onPressed: (){
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context)=> ReportBully()),
                     );
                   },
                 ),
               ),

               Padding(

                 padding: EdgeInsets.only(top: 50,left: 3),

                 child: MaterialButton(
                   minWidth: double.infinity,
                   child: const Text(
                     'View my Report',
                     style: TextStyle(fontSize: 30),
                   ),
                   height:60,
                   color: Colors.greenAccent,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(40)
                   ),
                   onPressed: (){
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context)=> ViewReport()),
                     );
                   },
                 ),
               )

             ],


           )
       )
     );


  }
}





