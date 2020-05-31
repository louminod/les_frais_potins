import 'package:les_frais_potins/src/models/references/user_role.dart';
import 'package:les_frais_potins/src/tools/converters.dart';

class User {
  final uid;
  final emailVerified;
  final email;

  User({this.uid, this.emailVerified, this.email});
}

class UserData {
  String uid;
  String pseudo;
  UserRole role;

  UserData({this.uid, this.pseudo, this.role});

  UserData.fromJson(String uid, Map<String, dynamic> parsedJson) {
    this.uid = uid;
    this.pseudo = parsedJson["pseudo"];
    this.role = Converters.stringToUserRole(parsedJson["role"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'pseudo': this.pseudo,
      'role': this.role.toString(),
    };
  }
}
