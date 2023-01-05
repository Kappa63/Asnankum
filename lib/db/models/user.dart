final String users_table = 'users';

class UserFields {
  static final List<String> vals = [id, type, username, password, loginState,
                                    firstName, lastName, bday, sex];

  static final String id = "_id";
  static final String type = "type";
  static final String username = "username";
  static final String password = "password";
  static final String loginState = "loginState";
  static final String firstName = "firstName";
  static final String lastName = "lastName";
  static final String bday = "bday";
  static final String sex = "sex";
}

class User {
  final int? id;
  final String type;
  final String username;
  final String password;
  final bool loginState;
  final String firstName;
  final String lastName;
  final DateTime bday;
  final String sex;

  const User({
    this.id,
    required this.type,
    required this.username,
    required this.password,
    required this.loginState,
    required this.firstName,
    required this.lastName,
    required this.bday,
    required this.sex,
  });

  User replicate({
    int? id,
    String? type,
    String? username,
    String? password,
    bool? loginState,
    String? firstName,
    String? lastName,
    DateTime? bday,
    String? sex,
  }) => User(id: id?? this.id, 
             type: type?? this.type,
             username: username?? this.username,
             password: password?? this.password,
             loginState: loginState?? this.loginState,
             firstName: firstName?? this.firstName,
             lastName: lastName?? this.lastName,
             bday: bday?? this.bday,
             sex: sex?? this.sex,);
             

  static User Deserialize(Map<String, Object?> dt) => User(
    id: dt[UserFields.id] as int?,
    type: dt[UserFields.type] as String,
    username: dt[UserFields.username] as String,
    password: dt[UserFields.password] as String,
    loginState: dt[UserFields.loginState] == 1,
    firstName: dt[UserFields.firstName] as String,
    lastName: dt[UserFields.lastName] as String,
    bday: DateTime.parse(dt[UserFields.bday] as String),
    sex: dt[UserFields.sex] as String,
  );

  Map<String, Object?> Serialize() => {
    UserFields.id: id,
    UserFields.type: type,
    UserFields.username: username,
    UserFields.password: password,
    UserFields.loginState: loginState ? 1:0,
    UserFields.firstName: firstName,
    UserFields.lastName: lastName,
    UserFields.bday: bday.toIso8601String(),
    UserFields.sex: sex,
  };
}