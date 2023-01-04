import 'package:dental_care/pgs/login_selector.dart';
import 'package:dental_care/db/models/user.dart';
import 'package:dental_care/db/users_db.dart';
import 'package:dental_care/pgs/ds_home.dart';
import 'package:dental_care/pgs/p_home.dart';
import 'package:flutter/material.dart';


class PageDirector extends StatefulWidget {
  const PageDirector({super.key});


  @override
  State<PageDirector> createState() => _PageDirectorState();
}

class _PageDirectorState extends State<PageDirector> {

  late Future _getLoggedUser;

  User? loggedUsr;

  Future getUser() async {
    loggedUsr = await UsersDB.db_I.getLoggedIn();
  }

  @override
  void initState() {
    super.initState();

    _getLoggedUser = getUser();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: FutureBuilder(
        future: _getLoggedUser,
        builder: (ctx, snap) {
          if(snap.connectionState==ConnectionState.done)
            if(loggedUsr==null)
              return LoginSelector();
            else
              if(loggedUsr!.type == "Patient")
                return HomeP(username: loggedUsr!.username, id: loggedUsr!.id!);
              else
                return HomeDS(username: loggedUsr!.username, id: loggedUsr!.id!);
          else if (snap.hasError)
            throw Exception("Missing Data: Snap Error");
          else 
            return Center(child: CircularProgressIndicator());
        }, 
      ),
    );
  }
}