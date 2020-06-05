import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:les_frais_potins/src/models/references/user_role.dart';
import 'package:les_frais_potins/src/models/user.dart';
import 'package:les_frais_potins/src/services/database_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(
            uid: user.uid,
            email: user.email,
            emailVerified: user.isEmailVerified)
        : null;
  }

  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future<User> get currentUser async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    return _userFromFirebaseUser(firebaseUser);
  }

  Future<dynamic> signIn(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (error) {
      return error;
    }
  }

  Future<dynamic> signUp(String pseudo, String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      try {
        await DatabaseService(userUid: user.uid).insertUserData(UserData(
          pseudo: pseudo,
          role: UserRole.USER,
        ));
        await AuthenticationService().sendEmailVerification();
      } catch (error) {
        print(error);
      }

      return user;
    } catch (error) {
      return error;
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<bool> changePassword(String password) async {
    bool result = false;
    FirebaseUser user = await _firebaseAuth.currentUser();
    await user.updatePassword(password).then((_) {
      result = true;
    }).catchError((error) {
      print(error);
    });
    return result;
  }

  Future<void> deleteUser() async {
    bool result = false;
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.delete().then((_) {
      result = true;
    }).catchError((error) {
      print("User can't be delete" + error.toString());
    });
    return result;
  }

  Future<void> sendPasswordResetMail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return null;
  }
}
