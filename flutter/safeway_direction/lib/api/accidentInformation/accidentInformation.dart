import 'dart:convert';

import 'package:http/http.dart' as http;
class AccidentInformation{
  
  static Future<Map<String,dynamic>> getAccidentInformation() async{
    http.Response response = await http.get("http://3.34.194.177:8088/secret/api/frequently");
    Map<String,dynamic> result = jsonDecode(response.body);

    return result;
  }
}