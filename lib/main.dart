// import 'package:dental_care/pgs/ds_home.dart';
import 'package:dental_care/pgs/p_home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // try{
    //   UsersDB.db_I.getUser(0);
    // }
    // on Exception{
    //   print("Toot");
    // }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomeP(username: "Karim.qq", id: 1), //"Patient" or "Dental Student"
      // Login(type: "Patient")
      // Login(type: "Dental Student")
      // LoginSelector()
    );
  }
}