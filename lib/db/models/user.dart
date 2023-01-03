final String users_table = 'users';

class UserFields {
  static final List<String> vals = [id, type, username, password, loginState];

  static final String id = "_id";
  static final String type = "type";
  static final String username = "username";
  static final String password = "password";
  static final String loginState = "loginState";
}

class User {
  final int? id;
  final String type;
  final String username;
  final String password;
  final bool loginState;

  const User({
    this.id,
    required this.type,
    required this.username,
    required this.password,
    required this.loginState,
  });

  User replicate({
    int? id,
    String? type,
    String? username,
    String? password,
    bool? loginState,
  }) => User(id: id?? this.id, 
             type: type?? this.type,
             username: username?? this.username,
             password: password?? this.password,
             loginState: loginState?? this.loginState,);
             

  static User Deserialize(Map<String, Object?> dt) => User(
    id: dt[UserFields.id] as int?,
    type: dt[UserFields.type] as String,
    username: dt[UserFields.username] as String,
    password: dt[UserFields.password] as String,
    loginState: dt[UserFields.loginState] == 1,
  );

  Map<String, Object?> Serialize() => {
    UserFields.id: id,
    UserFields.type: type,
    UserFields.username: username,
    UserFields.password: password,
    UserFields.loginState: loginState ? 1:0,
  };
}