import 'package:les_frais_potins/src/models/references/potin_status.dart';
import 'package:les_frais_potins/src/tools/converters.dart';

class Potin {
  String uid;
  String userUid;
  String validatorUid;
  String title;
  String content;
  String resume;
  DateTime creation;
  PotinStatus status;
  int nbLike;
  int nbDislike;
  int nbFakeNews;

  Potin(
      {this.uid,
      this.userUid,
      this.validatorUid,
      this.title,
      this.content,
      this.creation,
      this.status,
      this.resume,
      this.nbLike,
      this.nbDislike,
      this.nbFakeNews});

  Potin.fromJson(String uid, Map<String, dynamic> parsedJson) {
    this.uid = uid;
    this.userUid = parsedJson['userId'];
    this.validatorUid = parsedJson['validatorUid'];
    this.title = parsedJson['title'];
    this.content = parsedJson['content'];
    this.resume = parsedJson['resume'];
    this.creation = DateTime.parse(parsedJson['creation']);
    this.status = Converters.stringToPotinStatus(parsedJson['status']);
    this.nbLike = parsedJson['nbLike'];
    this.nbDislike = parsedJson['nbDislike'];
    this.nbFakeNews = parsedJson['nbFakeNews'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'content': this.content,
      'creation': this.creation.toString(),
      'userId': this.userUid,
      'validatorUid': this.validatorUid,
      'status': this.status.toString(),
      'resume': this.resume,
      'nbLike': this.nbLike,
      'nbDislike': this.nbDislike,
      'nbFakeNews': this.nbFakeNews,
    };
  }
}
