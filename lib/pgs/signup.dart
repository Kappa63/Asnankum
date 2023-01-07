import 'package:dental_care/db/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dental_care/error_states.dart';
import 'package:dental_care/db/users_db.dart';
import 'package:dental_care/pgs/ds_home.dart';
import 'package:dental_care/pgs/p_home.dart';
import 'package:dental_care/pgs/login.dart';
import 'package:dental_care/funcs.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key, required this.type});

  final String type;

  @override
  State<Signup> createState() => _SignupState();
}

enum Sex {
  male,
  female,
}

class _SignupState extends State<Signup> {

  @override
  void dispose() {
    _uControl.dispose();
    _pControl.dispose();
    _fnControl.dispose();
    _lnControl.dispose();
    super.dispose();
  }

  final _fnControl = TextEditingController();
  final _lnControl = TextEditingController();

  final _uControl = TextEditingController();
  final _pControl = TextEditingController();

  Sex? _sex;

  DateTime _birth = DateTime(2003, 6, 15);

  Future signUp() async {
    String fName = _fnControl.text.trim();
    String lName = _lnControl.text.trim();

    String usr = _uControl.text.trim();
    String pwd = _pControl.text.trim();

    SignupErrorManager.fn_Error = Validators.sLength(fName, 0);
    SignupErrorManager.ln_Error = Validators.sLength(lName, 0);

    SignupErrorManager.u_Error = Validators.sLength(usr, 0);
    SignupErrorManager.p_Error = Validators.sLength(pwd, 0);

    SignupErrorManager.s_Error = _sex==null;

    if(SignupErrorManager.p_Error || SignupErrorManager.u_Error ||
       SignupErrorManager.fn_Error || SignupErrorManager.ln_Error ||
       SignupErrorManager.s_Error){
      setState(() {});
      return;
    }

    User loggedUsr = await UsersDB.db_I.insert(User(type: widget.type, 
                                                    username: usr, 
                                                    password: Convertors.toSHA256(pwd), 
                                                    loginState: true, 
                                                    firstName: fName, 
                                                    lastName: lName, 
                                                    bday: _birth, 
                                                    sex: _sex!.name));

    if(widget.type == "Patient")
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomeP(user: loggedUsr,)), 
                                  (Route<dynamic> route) => false);
    else
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomeDS(user: loggedUsr,)), 
                                    (Route<dynamic> route) => false);
    _uControl.clear();
    _pControl.clear();
    _fnControl.clear();
    _lnControl.clear();
    _sex = null;
    _birth = DateTime(2003, 6, 15);
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext ctx){
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 6,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        toolbarOpacity: 0.9,
        toolbarHeight: 40,
        backgroundColor: Colors.blue[300],
        centerTitle: true,
        title: Text("ASNANKUM", 
                    style: GoogleFonts.oswald(fontSize: 20, letterSpacing: 1),),
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.type=="Patient"?Icons.airline_seat_flat_angled_outlined:Icons.medical_services_outlined, size: 140,),
          
                
                SizedBox(height: 8,),
          
                Text("Please Enter Your Details",
                      style: TextStyle(fontSize: 20)),
          
                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  controller: _fnControl,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: SignupErrorManager.fn_Error?Colors.red:Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue.shade200),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: "First Name",
                                    hintStyle: TextStyle(color: SignupErrorManager.fn_Error?Colors.red[300]:null),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                ),
                          
                                SizedBox(height: 3,),
                          
                                WidgetOnError.upError(SignupErrorManager.fn_Error)
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
    
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  controller: _lnControl,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: SignupErrorManager.ln_Error?Colors.red:Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue.shade200),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: "Last Name",
                                    hintStyle: TextStyle(color: SignupErrorManager.ln_Error?Colors.red[300]:null),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                ),
                          
                                SizedBox(height: 3,),
                          
                                WidgetOnError.upError(SignupErrorManager.ln_Error)
                              ],
                            ),
                          ),
                        ],
                      ),
    
                    SizedBox(height: 20,),
                    
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<Sex>(
                                value: Sex.male,
                                groupValue: _sex,
                                selected: _sex == Sex.male,
                                selectedTileColor: Colors.blue[100],
                                shape: RoundedRectangleBorder(side: BorderSide(color: SignupErrorManager.s_Error?Colors.red:Colors.white), 
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
                                selectedTileColor: Colors.blue[100],
                                shape: RoundedRectangleBorder(side: BorderSide(color: SignupErrorManager.s_Error?Colors.red:Colors.white),
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

                        SizedBox(height: 3,),

                        WidgetOnError.upError(SignupErrorManager.s_Error)
                      ],
                    ),
      
                    SizedBox(height: 20,),
                    
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue[200]),
                                       shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),)
                           ),
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
                    ),
                    ],
                  ),
                ),

                SizedBox(height: 15,),

                // Username Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      TextField(
                        controller: _uControl,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: SignupErrorManager.u_Error?Colors.red:Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "Username",
                          hintStyle: TextStyle(color: SignupErrorManager.u_Error?Colors.red[300]:null),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),

                      SizedBox(height: 3,),

                      WidgetOnError.upError(SignupErrorManager.u_Error)
                    ],
                  ),
                ),
                SizedBox(height: 15,),

                // Password Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      TextField(
                        controller: _pControl,
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: SignupErrorManager.p_Error?Colors.red:Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(color: SignupErrorManager.p_Error?Colors.red[300]:null),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),

                      SizedBox(height: 3,),

                      WidgetOnError.upError(SignupErrorManager.p_Error)
                    ],
                  ),
                ),
          
                SizedBox(height: 10,),
          
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue[300]),
                                       shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),)
                           ),
                    onPressed: signUp,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add, color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("Sign Up",
                               style: TextStyle(color: Colors.white, 
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,),),
                          SizedBox(width: 10,),
                        ],
                      )
                    ),
                  ),
                ),

                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                          style: TextStyle(fontWeight: FontWeight.bold),),
                    
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Login(type: widget.type)), 
                                                                               (Route<dynamic> route) => false);
                      },
                      child: Text(" Login",
                            style: TextStyle(color: Colors.blue, 
                                            fontWeight: FontWeight.bold,),
                          ),
                    ),
                  ],
                ),

                SizedBox(height: 30,),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a ${widget.type}?",
                          style: TextStyle(fontWeight: FontWeight.bold),),
                    
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Signup(type: widget.type=='Patient'?'Dental Student':'Patient')), 
                                                                               (Route<dynamic> route) => false);
                      },
                      child: Text(" Switch to ${widget.type=='Patient'?'Dental Student':'Patient'}",
                            style: TextStyle(color: Colors.blue, 
                                            fontWeight: FontWeight.bold,),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}