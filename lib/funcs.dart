import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';

class Validators {
  static bool sLength(String s, int failLength) => s.length <= failLength;
}

class Convertors {
  static String toSHA256(String s) => sha256.convert(utf8.encode(s)).toString();
}

class WidgetOnError {
  static Widget upError(bool b) => 
    b?Align(
        alignment: Alignment.centerLeft,
        child: Text("This can't be empty.",
              style: TextStyle(color: Colors.red,),
        ),
      ):SizedBox(height: 0,);
}

class GeneralFuncs {
  static int calcAge(DateTime bd){
    final DateTime td = DateTime.now();
    return (td.year-bd.year)+(((td.day-bd.day)>=0 && (td.month-bd.month)>=0)?0:-1);
  }

  static Future<File> saveImg(String imPath) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String fName = basename(imPath);
    return File(imPath).copy(File("${dir.path}/$fName").path);
  }
}