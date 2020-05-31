import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:les_frais_potins/src/models/potin.dart';
import 'package:les_frais_potins/src/models/references/potin_status.dart';
import 'package:les_frais_potins/src/models/user.dart';

final _potinTable = "potins";
final _userDataTable = "usersData";

class DatabaseService {
  final userUid;

  DatabaseService({this.userUid});

  // POTINS

  final CollectionReference _potinsCollection =
      Firestore.instance.collection(_potinTable);

  Stream<List<Potin>> get potinsCreated {
    return _potinsCollection.snapshots().map(
        (snapshot) => _potinsListFromSnapshot(snapshot, PotinStatus.CREATED));
  }

  Stream<List<Potin>> get potinsValidated {
    return _potinsCollection.snapshots().map(
        (snapshot) => _potinsListFromSnapshot(snapshot, PotinStatus.VALIDATED));
  }

  List<Potin> _potinsListFromSnapshot(
      QuerySnapshot snapshot, PotinStatus potinStatus) {
    return snapshot.documents
        .map((doc) {
          return Potin.fromJson(doc.documentID, doc.data);
        })
        .where((potin) => potin.status == potinStatus)
        .toList();
  }

  Future<void> insertPotin(Potin potin) async {
    return await _potinsCollection.document().setData(potin.toJson());
  }

  Future<void> updatePotin(Potin potin) async {
    return await _potinsCollection
        .document(potin.uid)
        .updateData(potin.toJson());
  }

  Future<void> deletePotin(Potin potin) async {
    return await _potinsCollection.document(potin.uid).delete();
  }

  // USERS

  final CollectionReference _usersDataCollection =
      Firestore.instance.collection(_userDataTable);

  Stream<UserData> get userData {
    return _usersDataCollection.document(userUid).snapshots().map(
      (DocumentSnapshot doc) {
        return UserData.fromJson(doc.documentID, doc.data);
      },
    );
  }

  Future<void> insertUserData(UserData userData) async {
    return await _usersDataCollection
        .document(userUid)
        .setData(userData.toJson());
  }

  Future<void> updateUserData(UserData userData) async {
    return await _usersDataCollection
        .document(userUid)
        .updateData(userData.toJson());
  }
}
