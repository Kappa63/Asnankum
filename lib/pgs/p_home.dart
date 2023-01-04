import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:dental_care/db/models/dental_form.dart';
import 'package:dental_care/pgs/login_selector.dart';
import 'package:dental_care/db/dental_forms_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dental_care/db/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dental_care/db/users_db.dart';
import 'package:dental_care/funcs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'dart:io';

class HomeP extends StatefulWidget {
  const HomeP({super.key, required this.username, required this.id});

  final String username;
  final int id;

  @override
  State<HomeP> createState() => _HomePState();
}

enum Sex {
  male,
  female,
}

class _HomePState extends State<HomeP> {

  late Future _dataGet;

  List<DentalForm> myForms = List.empty(growable: true);
  List<bool> myFormsState = List.empty(growable: true);

  Future getForms() async {
    myForms = await DentalFormsDB.db_I.getForm_byPatientID(super.widget.id);

    myFormsState = List.filled(myForms.length, false);
    if(myForms.isNotEmpty)
      myFormsState[0] = true;
  }
  
  Sex? _sex;
  File? _img;

  DateTime _birth = DateTime(2003, 6, 15);

  final _fnControl = TextEditingController();
  final _lnControl = TextEditingController();

  final _cControl = TextEditingController();
  final _aControl = TextEditingController();

  int curStep = 0;

  StepState pd_StepState() {
    bool dComp = _fnControl.text.trim().isNotEmpty && _lnControl.text.trim().isNotEmpty && _sex!=null;

    return curStep<0? StepState.indexed:
                      (curStep==0? StepState.editing:
                                   (dComp? StepState.complete:
                                           StepState.error));
  }

  StepState i_StepState() =>
    curStep<1? StepState.indexed:
               (curStep==1? StepState.editing:
                            (_cControl.text.trim().isNotEmpty? StepState.complete:
                                                               StepState.error));
  
  bool chk_formCompletion() =>
    ((i_StepState() == StepState.complete) && (pd_StepState() == StepState.complete));

  Future createAppointment() async {
    String aTrim = _aControl.text.trim();
    DentalForm nForm = await DentalFormsDB.db_I.insert(DentalForm(creationDT: DateTime.now(),
                                              patientID: widget.id,
                                              firstName: _fnControl.text.trim(), 
                                              lastName: _lnControl.text.trim(), 
                                              age: GeneralFuncs.calcAge(_birth), 
                                              sex: _sex!.name, 
                                              allergies: aTrim.isEmpty?null:aTrim, 
                                              desc: _cControl.text.trim(), 
                                              imgPath: _img!=null?_img!.path:null, 
                                              status: false, 
                                              appointmentDT: null, 
                                              dentistID: null, 
                                              dentistName: null));

    _fnControl.clear();
    _lnControl.clear();

    _cControl.clear();
    _aControl.clear();

    _sex = null;
    _img = null;

    _birth = DateTime(2003, 6, 15);

    curStep = 0;

    myForms.add(nForm);

    _dataGet = getForms();
    setState(() {});
  }

  @override
  void dispose() {
    _fnControl.dispose();
    _lnControl.dispose();
    _aControl.dispose();
    _cControl.dispose();
    super.dispose();
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
              backgroundColor: Colors.pink[300],
              title: Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[300]),
                                       shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),),)
                           ),
                    onPressed: () async {
                      User loggedUsr = await UsersDB.db_I.getUser_byID(widget.id);
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
                  Icon(Icons.medical_information),
                  SizedBox(width: 10,),
                  Text("Logged in as ${widget.username}", 
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
        
                    myForms.isEmpty?
                      SizedBox(height: 0,):
                      SizedBox(
                        height: 300,
                        child: ScrollSnapList(
                          dynamicItemSize: true,
                          dynamicItemOpacity: 0.7,
                          itemCount: myForms.length,
                          itemSize: 200,
                          itemBuilder:(ctx, i) {
                            DentalForm form = myForms[i];
                            return SizedBox(
                              width: 200,
                              height: 300,
                              child: Card(
                                elevation: 6,
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
                                    ],
                                  ),
                                )
                              ),
                            );
                          },
                          onItemFocus:(i) {

                          },
                        ),
                      ),
        
                    SizedBox(height: 40,),
        
                    Text("Add Appointment", style: GoogleFonts.balooPaaji2(fontSize: 30, 
                                                                          fontWeight: FontWeight.bold),),
        
                    Stepper(
                      physics: ClampingScrollPhysics(),
                      type: StepperType.vertical, 
                      currentStep: curStep,
                      onStepContinue: () async {
                        if(curStep >= 3){
                          await createAppointment();
                        } else
                          curStep++;
                        setState(() {});
                      },
                      onStepCancel: () {
                        curStep == 0 ? null:curStep--;
                        setState(() {});
                      },
                      onStepTapped: (value) {
                        curStep = value;
                        setState(() {});
                      },
                      controlsBuilder: (context, details) =>
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(onPressed: curStep<3||chk_formCompletion()?details.onStepContinue:null, child: Text(curStep<3?"Next":"Submit"))
                              ),
                    
                              SizedBox(width: 12,),
                    
                              if(curStep > 0)
                                Expanded(
                                  child: ElevatedButton(onPressed: details.onStepCancel, child: Text("Back"))
                                ),
                            ],
                          ),
                        ),
                      steps: [
                        Step(
                          title: Text("Personal Details"),
                          state: pd_StepState(),
                          isActive: curStep >= 0,
                          content: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _fnControl,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.pink.shade200),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        hintText: "First Name",
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                  
                                  Expanded(
                                    child: TextField(
                                      controller: _lnControl,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.pink.shade200),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        hintText: "Last Name",
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                  
                              SizedBox(height: 20,),
                              
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<Sex>(
                                      value: Sex.male,
                                      groupValue: _sex,
                                      selected: _sex == Sex.male,
                                      selectedTileColor: Colors.blue[100],
                                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), 
                                                                    borderRadius: BorderRadius.circular(30)),
                                      activeColor: Colors.black54,
                                      title: Row(
                                        children: [
                                          Icon(Icons.male),
                                          Text("Male")
                                        ]
                                      ),
                                      onChanged: (value) {
                                        _sex = value;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                  
                                  SizedBox(width: 10,),
                  
                                  Expanded(
                                    child: RadioListTile<Sex>(
                                      value: Sex.female,
                                      groupValue: _sex,
                                      selected: _sex == Sex.female,
                                      selectedTileColor: Colors.pink[100],
                                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white),
                                                                    borderRadius: BorderRadius.circular(30)),
                                      activeColor: Colors.black54,
                                      title: Row(
                                        children: [
                                          Icon(Icons.female),
                                          Text("Female")
                                        ]
                                      ),
                                      onChanged: (value) {
                                        _sex = value;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                  
                              SizedBox(height: 20,),
                              
                              ElevatedButton(
                                onPressed: () async {
                                  DateTime? birthDate = await showDatePicker(context: ctx, 
                                                                initialDate: _birth, 
                                                                firstDate: DateTime(1923), 
                                                                lastDate: DateTime(2023),);
                                  _birth = birthDate??_birth;
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cake),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text("${_birth.day}/${_birth.month}/${_birth.year}",
                                                    style: TextStyle(fontSize: 15),),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Step(
                          title: Text("Issue(s)"), 
                          state: i_StepState(),
                          isActive: curStep >= 1,
                          content: Column(
                            children: [
                              TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                minLines: 4,
                                controller: _cControl,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.pink.shade200),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: "Complaints (Describe Issue)",
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              ),
                  
                              SizedBox(height: 20,),
                  
                              TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                minLines: 2,
                                controller: _aControl,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.pink.shade200),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: "Allergies (If Applicable)",
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Step(
                          title: Text("Optional"),
                          state: curStep<2?StepState.indexed:(curStep==2?StepState.editing:StepState.complete),
                          isActive: curStep >= 2,
                          content: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          XFile? res = await ImagePicker().pickImage(source: ImageSource.gallery);
                                          
                                          if(res == null) return;
                                          
                                          _img = await GeneralFuncs.saveImg(res.path);
                                          setState(() {});
                                        } on PlatformException {
                                          log("Error. Image pick Fail");
                                        } on MissingPlatformDirectoryException {
                                          log("Error. Bad Directory");
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.image),
                                            SizedBox(width: 10),
                                            Text("Pick Image"),
                                          ],
                                        ),
                                      )
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          XFile? res = await ImagePicker().pickImage(source: ImageSource.camera);
                                          
                                          if(res == null) return;
                                          
                                          _img = await GeneralFuncs.saveImg(res.path);
                                          setState(() {});
                                        } on PlatformException {
                                          log("Error. Image pick Fail");
                                        } on MissingPlatformDirectoryException {
                                          log("Error. Bad Directory");
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.camera_alt),
                                            SizedBox(width: 10),
                                            Text("Open Camera"),
                                          ],
                                        ),
                                      )
                                    ),
                                  )
                                ],
                              ),
                
                              SizedBox(height: 15,),
                
                              _img==null?SizedBox(height: 0,):Image.file(_img!)
                
                            ],
                          ),
                        ),
                        Step(
                          title: Text("Complete"),
                          isActive: curStep >= 3,
                          content: 
                            chk_formCompletion()?
                              Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), 
                                                              borderRadius: BorderRadius.circular(20)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Column(
                                    children: [
                                      _img==null? SizedBox(
                                                            height: 200,
                                                            width: 200,
                                                            child: Icon(Icons.image_not_supported,
                                                                        size: 40,)
                                                          ):
                                                          Image.file(_img!, 
                                                                      fit: BoxFit.cover,
                                                                      width: 400,
                                                                      height: 200,
                                                          ),
                                      SizedBox(height: 10,),
                                      Text("${_fnControl.text.trim()} ${_lnControl.text.trim()} (${GeneralFuncs.calcAge(_birth)}${_sex==Sex.male?'M':'F'})",
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
                                          Text(DateFormat("dd-MM-yyyy").format(DateTime.now())),
                                        ],
                                      ),
                                      SizedBox(height: 12,),
                                      ExpansionTile(
                                        title: Text("details"),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(18, 2, 2, 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Complaint: ", 
                                                        style: TextStyle(fontWeight: FontWeight.bold),),
                                                    Text(_cControl.text.trim()),
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                if(_aControl.text.trim().isNotEmpty)
                                                  Row(
                                                    children: [
                                                      Text("Allergies: ", 
                                                          style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(_aControl.text.trim()),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ):
                              Column(
                                children: [
                                  Text("Missing Details", 
                                      style: TextStyle(color: Colors.red, 
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20),),
                                  SizedBox(height: 10,),
                                  Text("Please Make Sure All Data is Entered Correctly.", 
                                      style: TextStyle(color: Colors.red, 
                                                        fontSize: 12),),
                                ],
                              ),
                        ),
                      ]
                    ),
                  ],
                ),
              ),
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