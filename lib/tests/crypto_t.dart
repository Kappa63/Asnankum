import 'package:crypto/crypto.dart';
import 'dart:developer';
import 'dart:convert';

void main(){
  log(sha256.convert(utf8.encode("testing11")).toString());
}