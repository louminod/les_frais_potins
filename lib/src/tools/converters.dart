import 'package:les_frais_potins/src/models/references/potin_status.dart';
import 'package:les_frais_potins/src/models/references/user_role.dart';

class Converters {
  static PotinStatus stringToPotinStatus(String string) {
    PotinStatus statusConverted = null;
    // ignore: missing_return
    PotinStatus.values.forEach((status) {
      if (status.toString() == string) {
        statusConverted = status;
      }
    });

    return statusConverted;
  }

  static UserRole stringToUserRole(String string) {
    UserRole roleConverted = null;
    // ignore: missing_return
    UserRole.values.forEach((role) {
      if (role.toString() == string) {
        roleConverted = role;
      }
    });

    return roleConverted;
  }
}
