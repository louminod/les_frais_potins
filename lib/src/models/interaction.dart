import 'package:les_frais_potins/src/models/references/interaction_type.dart';
import 'package:les_frais_potins/src/tools/converters.dart';

class Interaction {
  String uid;
  String userUid;
  String potinUid;
  InteractionType interactionType;

  Interaction({this.uid, this.userUid, this.potinUid, this.interactionType});

  Interaction.fromJson(String uid, Map<String, dynamic> parsedJson) {
    this.uid = uid;
    this.userUid = parsedJson['userUid'];
    this.potinUid = parsedJson['potinUid'];
    this.interactionType =
        Converters.stringToInteractionType(parsedJson['interactionType']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userUid': this.userUid,
      'potinUid': this.potinUid,
      'interactionType': this.interactionType.toString(),
    };
  }
}
