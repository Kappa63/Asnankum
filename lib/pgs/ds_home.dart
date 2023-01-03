import 'package:dental_care/db/samples/sample_forms.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:dental_care/db/models/dental_form.dart';
import 'package:dental_care/db/dental_forms_db.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:io';

class HomeDS extends StatefulWidget {
  const HomeDS({super.key, required this.username, required this.id});

  final String username;
  final int id;

  @override
  State<HomeDS> createState() => _HomeDSState();
}

enum Sex {
  male,
  female,
}

class _HomeDSState extends State<HomeDS> {

  final List<DentalForm> _forms = [SampleForms.completeForm1, SampleForms.noAllergiesForm2, 
                                   SampleForms.noAppointmentForm1, SampleForms.noImgForm1,
                                   SampleForms.allMissingForm1, SampleForms.completeForm3];

  List<DentalForm>? myForms;
  List<DentalForm>? rdyForms;

  // @override
  // void initState() async {
  //   super.initState();
  //   myForms = await DentalFormsDB.db_I.getForm_byDrID(super.widget.id);
  //   rdyForms = await DentalFormsDB.db_I.getForm_byDrID(null);
  // }

  @override
  Widget build(BuildContext ctx){
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 6,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        toolbarOpacity: 0.9,
        toolbarHeight: 40,
        backgroundColor: Colors.pink[300],
        title: Row(
          children: [
            Icon(Icons.person),
            SizedBox(width: 10,),
            Text("Logged in as ${widget.username}", 
                        style: GoogleFonts.oswald(fontSize: 20,),),
          ],
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("My Applications", 
                              style: GoogleFonts.bebasNeue(fontSize: 40,
                                                           letterSpacing: 1.3,
                                                           fontWeight: FontWeight.bold),
                              ),
                ),
              ),

              SizedBox(height: 10,),

              SizedBox(
                height: 300,
                child: 
                  myForms==null?
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(
                        children: [
                          Text("No Applications", 
                                style: TextStyle(color: Colors.red, 
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30),),
                          SizedBox(height: 10,),
                          Text("Please Accept Some Applications First.", 
                                style: TextStyle(color: Colors.red, 
                                                fontSize: 16),),
                        ],
                      ),
                    ):
                    ScrollSnapList(
                      dynamicItemSize: true,
                      dynamicItemOpacity: 0.7,
                      itemCount: _forms.length,
                      itemSize: 200,
                      itemBuilder:(ctx, i) {
                        DentalForm form = _forms[i];
                        return SizedBox(
                          width: 200,
                          height: 300,
                          child: Card(
                            elevation: 40,
                            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), 
                                                          borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Column(
                                children: [
                                  form.imgPath==null? SizedBox(
                                                        height: 210,
                                                        width: 200,
                                                        child: Icon(Icons.image_not_supported,
                                                                    size: 40,)
                                                      ):
                                                      Image.asset(form.imgPath!, 
                                                                  fit: BoxFit.cover,
                                                                  width: 200,
                                                                  height: 210,
                                                      ),
                                  SizedBox(height: 10,),
                                  Text("${form.firstName} ${form.lastName} (${form.age}${form.sex=='male'?'M':'F'})",
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                  SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(form.status?"CHECKED!":"UNCHECKED", 
                                          style: TextStyle(color: form.status?Colors.green:Colors.red,
                                                            fontWeight: FontWeight.bold)
                                          ),
                                      SizedBox(width: 15,),
                                      Text(DateFormat("dd-MM-yyyy").format(form.creationDT)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ),
                        );
                      },
                      onItemFocus:(i) {},
                    ),
              ),

              SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Free Applications", 
                              style: GoogleFonts.bebasNeue(fontSize: 40, 
                                                           letterSpacing: 1.3,
                                                           fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              SizedBox(
                height: 500,
                child: 
                  rdyForms==null?
                    Padding(
                      padding: const EdgeInsets.only(top: 170),
                      child: Column(
                        children: [
                          Text("No Applications", 
                                style: TextStyle(color: Colors.red, 
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30),),
                          SizedBox(height: 10,),
                          Text("Please Wait For New Applications.", 
                                style: TextStyle(color: Colors.red, 
                                                fontSize: 16),),
                        ],
                      ),
                    ):
                    ScrollSnapList(
                      itemCount: _forms.length,
                      dynamicItemSize: true,
                      dynamicSizeEquation: (d) {
                        return 0.9 - min(d.abs() / 500, 0.2);
                      },
                      scrollDirection: Axis.vertical,
                      dynamicItemOpacity: 0.7,
                      itemSize: 375,
                      itemBuilder: (ctx, i) {
                        DentalForm form = _forms[i];
                        return Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), 
                                                        borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              children: [
                                form.imgPath == null? SizedBox(
                                                      height: 200,
                                                      width: 200,
                                                      child: Icon(Icons.image_not_supported,
                                                                  size: 40,)
                                                    ):
                                                    Image.file(File(form.imgPath!), 
                                                                fit: BoxFit.cover,
                                                                width: 700,
                                                                height: 200,
                                                    ),
                                SizedBox(height: 10,),
                                Text("${form.firstName} ${form.lastName} (${form.age}${form.sex=='male'?'M':'F'})",
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                SizedBox(height: 15,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("UNCHECKED", 
                                          style: TextStyle(color: Colors.red,
                                                          fontWeight: FontWeight.bold)
                                        ),
                                    SizedBox(width: 15,),
                                    Text(DateFormat("dd-MM-yyyy").format(form.creationDT)),
                                  ],
                                ),
                                SizedBox(height: 12,),
                                ExpansionTile(
                                  key: GlobalKey(),
                                  title: Text("details"),
                                  childrenPadding: const EdgeInsets.fromLTRB(18, 2, 2, 10),
                                  children: [
                                    Row(
                                      children: [
                                        Text("Complaint: ", 
                                              style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text(form.desc),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    if(form.allergies!=null)
                                      Row(
                                        children: [
                                          Text("Allergies: ", 
                                              style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text(form.allergies!),
                                        ],
                                      ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          DateTime nowDate = DateTime.now();
                                          DateTime? appointmentDate = await showDatePicker(context: ctx, 
                                                          initialDate: nowDate, 
                                                          firstDate: nowDate, 
                                                          lastDate: DateTime(2024),);
                                          if(appointmentDate == null) return;
                                          
                                          DentalFormsDB.db_I.update(form.replicate(appointmentDT: appointmentDate,
                                                                                   dentistID: widget.id,
                                                                                   dentistName: widget.username));
                                        }, 
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          child: Text("Accept", 
                                                      style: TextStyle(fontWeight: FontWeight.bold,
                                                                      fontSize: 18),),
                                        )
                                      ),
                                    )
                                  ]
                                ),
                              ],
                            ),
                          )
                        );
                      },
                      onItemFocus: (i) {
                        
                      },
                    ),
              ),
            ],
          )
        ),
      ),
    );
  }
}