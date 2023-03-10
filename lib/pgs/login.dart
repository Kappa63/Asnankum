import 'package:dental_care/db/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dental_care/error_states.dart';
import 'package:dental_care/db/users_db.dart';
import 'package:dental_care/pgs/ds_home.dart';
import 'package:dental_care/pgs/p_home.dart';
import 'package:dental_care/pgs/signup.dart';
import 'package:dental_care/funcs.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.type});

  final String type;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  void dispose() {
    _uControl.dispose();
    _pControl.dispose();
    super.dispose();
  }

  final _uControl = TextEditingController();
  final _pControl = TextEditingController();

  Future logIn() async {
    String usr = _uControl.text.trim();
    String pwd = _pControl.text.trim();

    LoginErrorManager.u_Error = Validators.sLength(usr, 0);
    LoginErrorManager.p_Error = Validators.sLength(pwd, 0);

    if(LoginErrorManager.p_Error || LoginErrorManager.u_Error){
      setState(() {});
      return;
    }

    try {
      
      User loggedUsr = await UsersDB.db_I.getUser_byLogin(usr, Convertors.toSHA256(pwd), widget.type);
      await UsersDB.db_I.update(loggedUsr.replicate(loginState: true));
      LoginErrorManager.bl_Error = false;
      if(widget.type == "Patient")
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomeP(user: loggedUsr,)), 
                                    (Route<dynamic> route) => false);
      else
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomeDS(user: loggedUsr)), 
                                      (Route<dynamic> route) => false);
      _uControl.clear();
      _pControl.clear();
    } on Exception {
      LoginErrorManager.bl_Error = true;
      setState(() {});
      return;
    }
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
          
                SizedBox(height: 25,),
          
                Text("Welcome!", 
                      style: GoogleFonts.balooPaaji2(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                
                SizedBox(height: 15,),
          
                Text("Ready to LOGIN?",
                      style: TextStyle(fontSize: 20)),
          
                SizedBox(height: 20,),
          
                // Username Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      TextField(
                        controller: _uControl,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: LoginErrorManager.u_Error?Colors.red:Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "Username",
                          hintStyle: TextStyle(color: LoginErrorManager.u_Error?Colors.red[300]:null),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),

                      SizedBox(height: 3,),

                      WidgetOnError.upError(LoginErrorManager.u_Error)
                    ],
                  ),
                ),
                SizedBox(height: 20,),
          
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
                            borderSide: BorderSide(color: LoginErrorManager.p_Error?Colors.red:Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(color: LoginErrorManager.p_Error?Colors.red[300]:null),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),

                      SizedBox(height: 3,),

                      WidgetOnError.upError(LoginErrorManager.p_Error)
                    ],
                  ),
                ),
          
                SizedBox(height: 10,),
          
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue[200]),
                                       shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),)
                           ),
                    onPressed: logIn,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("Log In",
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
                    Text("Don't have an account?",
                          style: TextStyle(fontWeight: FontWeight.bold),),
                    
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Signup(type: widget.type)), 
                                                                               (Route<dynamic> route) => false);
                      },
                      child: Text(" Create One",
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
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Login(type: widget.type=='Patient'?'Dental Student':'Patient')), 
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