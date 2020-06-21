import 'dart:convert';
import 'package:http/http.dart' as http;


class TmapServices{
  static const String projectKey = 'l7xxfeeb42724e74475abf8c3e26028e9768';
  static Future<Map<String,dynamic>> getRoute() async{
    http.Response response = await http.post(
        'https://apis.openapi.sk.com/tmap/routes/pedestrian?',
        headers: {"version":"1"},
        body:{
          "appKey" : projectKey,
          "startX" : "126.977022",
          "startY" : "37.569758",
          "endX" : "126.997589",
          "endY" : "37.570594",
          "startName" : "origin",
          "endName" : "destination"
        }
    );
    Map<String,dynamic> values = jsonDecode(response.body);
    return values;
  }
}