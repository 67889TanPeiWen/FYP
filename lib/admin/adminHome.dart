import 'package:antibullying_suicideprevention/admin/reportAdmin/report_category_menu.dart';
import 'package:antibullying_suicideprevention/admin/reportAdmin/viewMyCases.dart';
import 'package:flutter/material.dart';
import 'general/SidebarMenu.dart';

class adminHome extends StatefulWidget {
  const adminHome({Key? key}) : super(key: key);

  @override
  State<adminHome> createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
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
          appBar: AppBar(title: const Text('Home'),),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                padding: const EdgeInsets.only(top: 3, left: 3),

                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amberAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const CasesCategory()));
                  },
                  child: const Text('View All Cases',style: TextStyle(color: Colors.black)),),
              ),

              const SizedBox(height: 20,),


              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amberAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const ViewMyCases()));
                  },
                  child: const Text('View My Cases',style: TextStyle(color: Colors.black),),),
              ),


            ],
          ),
        )
    );
  }
}