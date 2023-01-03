import 'package:google_fonts/google_fonts.dart';
import 'package:dental_care/pgs/login.dart';
import 'package:flutter/material.dart';


class LoginSelector extends StatefulWidget {
  const LoginSelector({super.key});

  @override
  State<LoginSelector> createState() => _LoginSelectorState();
}

class _LoginSelectorState extends State<LoginSelector> {

  @override
  Widget build(BuildContext ctx){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_pin_rounded, size: 100,),

              SizedBox(height: 70,),

              Text("Welcome!", 
                    style: GoogleFonts.balooPaaji2(fontSize: 60, fontWeight: FontWeight.bold),
                  ),
              
              SizedBox(height: 15,),

              Text("Who are you?",
                    style: TextStyle(fontSize: 20)),

              SizedBox(height: 25,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Login(type: "Dental Student")), 
                                                                             (Route<dynamic> route) => false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            Icon(Icons.medical_services_outlined,
                                 size: 100, color: Colors.black,),
                  
                            Text("Dental Student", style: TextStyle(fontWeight: FontWeight.bold, 
                                                             fontSize: 17,),
                                ),
                          ],
                        ),
                        ),
                    ),
                  ),

                  SizedBox(width: 80,),

                  GestureDetector(
                    onTap: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Login(type: "Patient")), 
                                                                             (Route<dynamic> route) => false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            Icon(Icons.airline_seat_flat_angled_outlined, 
                                 size: 100, color: Colors.black,),
                  
                            Text("Patient", style: TextStyle(fontWeight: FontWeight.bold, 
                                                             fontSize: 17,),
                                ),
                          ],
                        ),
                        ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}