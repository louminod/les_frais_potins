import 'dart:convert';

import 'package:http/http.dart' as http;

class PseudoService {
  Future<String> generatePseudo() async {
    final response = await http.get('https://randomuser.me/api/?nat=fr');
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['results'][0]['name']['first'] +
          " " +
          data['results'][0]['name']['last'];
    } else {
      throw Exception('Failed to load album');
    }
  }
}
