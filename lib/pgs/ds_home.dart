import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:dental_care/db/models/dental_form.dart';
import 'package:dental_care/pgs/login_selector.dart';
import 'package:dental_care/db/dental_forms_db.dart';
import 'package:dental_care/db/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dental_care/db/users_db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:io';

class HomeDS extends StatefulWidget {
  const HomeDS({super.key, required this.user});

  final User user;

  @override
  State<HomeDS> createState() => _HomeDSState();
}

enum Sex {
  male,
  female,
}

class _HomeDSState extends State<HomeDS> {

  late Future _dataGet;

  List<DentalForm> myForms = List.empty(growable: true);
  List<DentalForm> rdyForms = List.empty(growable: true);

  List<bool> myFormsState = List.empty(growable: true);
  List<bool> rdyFormsState = List.empty(growable: true);

  Future getForms() async {
    myForms = await DentalFormsDB.db_I.getForm_byDrID(super.widget.user.id!);
    rdyForms = await DentalFormsDB.db_I.getForm_byDrID(null);

    myFormsState = List.filled(myForms.length, false, growable: true);
    rdyFormsState = List.filled(rdyForms.length, false, growable: true);
    if(myForms.isNotEmpty)
      myFormsState[0] = true;
    if(rdyForms.isNotEmpty)
      rdyFormsState[0] = true;
  }

  @override
  void initState() {
    super.initState();

    _dataGet = getForms();
  }

  @override
  Widget build(BuildContext ctx){
    return FutureBuilder(
      future: _dataGet,
      builder: (ctx, snap) {
        if(snap.connectionState == ConnectionState.done)
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 6,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
              toolbarOpacity: 0.9,
              toolbarHeight: 40,
              backgroundColor: Colors.blue[300],
              title: Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue[300]),
                                       shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),),)
                           ),
                    onPressed: () async {
                      User loggedUsr = await UsersDB.db_I.getUser_byID(widget.user.id!);
                      await UsersDB.db_I.update(loggedUsr.replicate(loginState: false));
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginSelector()), 
                                                  (Route<dynamic> route) => false);
                    },
                    child: Row(
                      children: [
                        Text("Log out", style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Icon(Icons.logout, size: 16,),
                      ],
                    )
                  ),
                  Expanded(
                    child: SizedBox(width: 10,),
                  ),
                  Icon(Icons.person),
                  SizedBox(width: 10,),
                  Text("Logged in as ${widget.user.username}", 
                       style: GoogleFonts.oswald(fontSize: 20,),),
                  SizedBox(width: 10,)
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
                      height: 318,
                      child: 
                        myForms.isEmpty?
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
                            itemCount: myForms.length,
                            itemSize: 200,
                            itemBuilder:(ctx, i) {
                              DentalForm form = myForms[i];
                              return SizedBox(
                                width: 200,
                                height: 318,
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
                                                            Image.file(File(form.imgPath!), 
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
                                        form.status? Row(
                                          children: [
                                            Expanded(
                                                child: ElevatedButton(
                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                  onPressed: () async {
                                                    DentalForm nForm = form.replicate(status: false);
                                                    myForms[i] = nForm;
                                                    await DentalFormsDB.db_I.update(nForm);
                                                    setState(() {});
                                                  }, 
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Text("Remove Check", 
                                                                style: TextStyle(fontWeight: FontWeight.bold,
                                                                                fontSize: 13),),
                                                  )
                                                ),
                                              ),
                                          ],
                                        ):
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                onPressed: () async {
                                                  DentalForm nForm = form.replicate(appointmentDT: DateTime.fromMicrosecondsSinceEpoch(9254),
                                                                                    dentistID: -785,
                                                                                    dentistName: "dbs78s");
                                                  
                                                  await DentalFormsDB.db_I.update(nForm);
                                                  myFormsState.removeAt(i);
                                                  myForms.removeAt(i);
                                                  rdyForms.add(nForm);
                                                  rdyFormsState.add(false);
                                                  setState(() {});
                                                }, 
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: Text("Remove", 
                                                              style: TextStyle(fontWeight: FontWeight.bold,
                                                                              fontSize: 13),),
                                                )
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                                                onPressed: () async {
                                                  DentalForm nForm = form.replicate(status: true);
                                                  myForms[i] = nForm;
                                                  await DentalFormsDB.db_I.update(nForm);
                                                  setState(() {});
                                                }, 
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                                  child: Text("Check", 
                                                              style: TextStyle(fontWeight: FontWeight.bold,
                                                                              fontSize: 13),),
                                                )
                                              ),
                                            ),
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
                      height: 362,
                      child: 
                        rdyForms.isEmpty?
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
                            scrollPhysics: ClampingScrollPhysics(),
                            itemCount: rdyForms.length,
                            dynamicItemSize: true,
                            dynamicSizeEquation: (d) {
                              return 0.9 - min(d.abs() / 500, 0.2);
                            },
                            scrollDirection: Axis.vertical,
                            dynamicItemOpacity: 0.7,
                            itemSize: 375,
                            itemBuilder: (ctx, i) {
                              DentalForm form = rdyForms[i];
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
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft, 
                                          child: Text("Details:", 
                                                      style: TextStyle(fontSize: 18, 
                                                                        fontStyle: FontStyle.italic,
                                                                        fontWeight: FontWeight.bold))),
                                      ),
                                      (rdyFormsState[i]?
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(18, 2, 2, 10),
                                          child: Column(
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
                                        ):
                                        SizedBox(height: 0,)),
                                      SizedBox(height: 10,),
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

                                                DentalForm nForm = form.replicate(appointmentDT: appointmentDate,
                                                                                        dentistID: widget.user.id!,
                                                                                        dentistName: "${widget.user.firstName} ${widget.user.lastName}");
                                                
                                                await DentalFormsDB.db_I.update(nForm);
                                                
                                                rdyFormsState.removeAt(i);
                                                rdyForms.removeAt(i);
                                                myForms.add(nForm);
                                                myFormsState.add(false);
                                                setState(() {});
                                              }, 
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 14),
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
                              rdyFormsState = rdyFormsState.map((e) => false).toList();
                              rdyFormsState[i] = true;
                            },
                          ),
                    ),
                  ],
                ),
              )
            ),
          );
        else if (snap.hasError) 
          throw Exception("Missing Data: Snap Error");
        else 
          return Center(child: CircularProgressIndicator());
        
      }
    );
  }
}