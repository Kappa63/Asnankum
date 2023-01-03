// import 'package:dental_care/db/samples/sample_forms.dart';
// import 'package:scroll_snap_list/scroll_snap_list.dart';
// import 'package:dental_care/db/models/dental_form.dart';
// import 'package:dental_care/db/dental_forms_db.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:developer';

class HomeDS extends StatefulWidget {
  const HomeDS({super.key, required this.username});

  final String username;

  @override
  State<HomeDS> createState() => _HomeDSState();
}

enum Sex {
  male,
  female,
}

class _HomeDSState extends State<HomeDS> {

  // final List<DentalForm> _forms = [SampleForms.completeForm1, SampleForms.noAllergiesForm2, 
  //                                  SampleForms.noAppointmentForm1, SampleForms.noImgForm1,
  //                                  SampleForms.allMissingForm1, SampleForms.completeForm3];

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
          child: Card(
            child: Padding(
            padding: EdgeInsets.only(
              top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
              child: ExpansionTile(
                title: Text('Birth of Universe'),
                children: [
                Text('Big Bang'),
                Text('Birth of the Sun'),
                Text('Earth is Born'),
                ],
              ),
            ),
          )
      //     child: Column(
      //       children: [
      //         SizedBox(height: 20,),

      //         SizedBox(
      //           height: 900,
      //           child: ScrollSnapList(
      //             dynamicItemSize: true,
      //             dynamicItemOpacity: 0.7,
      //             itemCount: _forms.length,
      //             scrollDirection: Axis.vertical,
      //             itemSize: 600,
      //             itemBuilder:(ctx, i) {
      //               DentalForm form = _forms[i];
      //               return SizedBox(
      //                 width: 300,
      //                 height: 400,
      //                 child: Card(
      //                   elevation: 6,
      //                   shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), 
      //                                                 borderRadius: BorderRadius.circular(20)),
      //                   child: ClipRRect(
      //                     borderRadius: BorderRadius.circular(20),
      //                     child: Column(
      //                       children: [
      //                         form.imgPath==null? SizedBox(
      //                                               height: 300,
      //                                               width: 300,
      //                                               child: Icon(Icons.image_not_supported,
      //                                                           size: 40,)
      //                                             ):
      //                                             Image.asset(form.imgPath!, 
      //                                                         fit: BoxFit.cover,
      //                                                         width: 500,
      //                                                         height: 300,
      //                                             ),
      //                         SizedBox(height: 10,),
      //                         Text("${form.firstName} ${form.lastName} (${form.age}${form.sex=='male'?'M':'F'})",
      //                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
      //                         SizedBox(height: 15,),
      //                         Row(
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           children: [
      //                             Text(form.status?"CHECKED!":"UNCHECKED", 
      //                                  style: TextStyle(color: form.status?Colors.green:Colors.red,
      //                                                   fontWeight: FontWeight.bold)
      //                                 ),
      //                             SizedBox(width: 15,),
      //                             Text(DateFormat("dd-MM-yyyy").format(form.creationDT)),
      //                           ],
      //                         )
      //                       ],
      //                     ),
      //                   )
      //                 ),
      //               );
      //             },
      //             onItemFocus:(i) {},
      //           ),
      //         ),
      //       ],
      //     ),
        ),
      ),
    );
  }
}