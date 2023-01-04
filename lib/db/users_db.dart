import 'package:dental_care/db/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer';

class UsersDB {
  static final UsersDB db_I = UsersDB._init();

  static Database? _db;

  UsersDB._init();

  Future<Database> get db async {
    if(_db != null) return _db!;

    _db = await _initDB("users.db");
    return _db!;
  }

  Future<Database> _initDB(String f_name) async {
    final db_path = await getDatabasesPath();
    final file_path = join(db_path, f_name); 
    log(file_path);
    return await openDatabase(file_path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db_, int v) async {
    log("creating...");
    await db_.execute('''CREATE TABLE $users_table (
                            ${UserFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
                            ${UserFields.type} TEXT NOT NULL,
                            ${UserFields.username} TEXT NOT NULL,
                            ${UserFields.password} TEXT NOT NULL,
                            ${UserFields.loginState} BOOLEAN NOT NULL
                         )''');

    await db_.execute('''INSERT INTO $users_table 
                            (${UserFields.type}, ${UserFields.username},
                            ${UserFields.password}, ${UserFields.loginState})
                          VALUES ("Patient", "TestPatient1",
                                  "1772d0119cc344f719853b2c032c2921398636766efd3ed2ffbad1c798e2bd97",
                                  FALSE),

                                ("Patient", "TestPatient2",
                                  "ce012bbb6a075d2c91e4da607fcbbb9b9c4a3d3a9a9b5e2889f24fdb1d9952f5",
                                  FALSE),

                                ("Dental Student", "TestDS1",
                                  "1772d0119cc344f719853b2c032c2921398636766efd3ed2ffbad1c798e2bd97",
                                  FALSE),

                                ("Dental Student", "TestDS2",
                                  "ce012bbb6a075d2c91e4da607fcbbb9b9c4a3d3a9a9b5e2889f24fdb1d9952f5",
                                  FALSE)''');
  }

  Future<User> insert(User user) async {
    final db_ = await db_I.db;

    final id = await db_.insert(users_table, user.Serialize());

    return user.replicate(id: id);
  }

  Future<User> getUser_byID(int id) async {
    final db_ = await db_I.db;

    final user = await db_.query(users_table, columns: UserFields.vals, 
                                where: "${UserFields.id} = ?", whereArgs: [id]);

    if(user.isEmpty)
      throw Exception("Id $id not found");
      
    return User.Deserialize(user.first);
  }

  Future<User> getUser_byLogin(String username, String password, String type) async {
    final db_ = await db_I.db;

    final user = await db_.query(users_table, columns: UserFields.vals, 
                                where: '''${UserFields.username} = ? AND 
                                          ${UserFields.password} = ? AND
                                          ${UserFields.type} = ?''', 
                                whereArgs: [username, password, type]);

    if(user.isEmpty)
      throw Exception("User not found");
      
    return User.Deserialize(user.first);
  }

  Future<User?> getLoggedIn() async {
    final db_ = await db_I.db;

    final user = await db_.query(users_table, columns: UserFields.vals, 
                                where: '''${UserFields.loginState} = ?''', 
                                whereArgs: [1]);

    return user.isEmpty?null:User.Deserialize(user.first);
  }

  Future<int> update(User user) async {
    final db_ = await db_I.db;

    return db_.update(users_table, user.Serialize(), 
                      where: "${UserFields.id} = ?", whereArgs: [user.id]);
  }

  Future<int> delete(int id) async {
    final db_ = await db_I.db;

    return await db_.delete(users_table, where: "${UserFields.id} = ?", whereArgs: [id]);
  }

  Future close() async {
    final db_ = await db_I.db;

    db_.close;
  }
}