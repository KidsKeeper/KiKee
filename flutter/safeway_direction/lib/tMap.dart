import 'dart:convert';
import 'dart:ffi';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class TmapServices{
  static const String projectKey = "l7xx4e2c5a4554b145d28a4b11ec631adfe5";

  static Future<Map<String,dynamic>> getRoute(LatLng origin, LatLng destination, {List<LatLng> passList}) async {
// 파라미터 설명 :각각 출발지, 도착지, 경유지(List) 정보
  
  Map<String, dynamic> requestData ={
      "appKey" : projectKey,
      "startX" : origin.longitude, // 경도
      "startY" : origin.latitude,
      "endX" : destination.longitude,
      "endY" : destination.latitude,
      "startName" : "origin", // 출발지 한글 장소명을 적어도 되나 url encoding 필요 
      "endName" : "destination"
    };
    

    String body = "";
    for(var key in requestData.keys)
        body += (key + '=' + requestData[key].toString() + '&');
    body = body.substring(0,body.lastIndexOf('&'));

  if(passList != null){
    for(LatLng iter in passList) // 경유지 정보 추가. 최대 5곳 가능
      body += (iter.longitude.toString() + ',' + iter.latitude.toString() + '_');
    body = body.substring(0, body.lastIndexOf('_'));
  }

  body = Uri.encodeFull(body);

  http.Response response = await http.post('https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json',
    headers: {
      "Accept-Language" : "ko",
      "Content-Type" : "application/x-www-form-urlencoded"
    },
    body: body
  );
  Map values = jsonDecode(response.body);

  return values;
  }

  static Future<Map<String,dynamic>> test(LatLng position) async {
    http.Response response = await http.get("https://apis.openapi.sk.com/tmap/road/nearToRoad?version=1&appKey=$projectKey&lat=${position.latitude}&lon=${position.longitude}");
    Map values = jsonDecode(response.body);

    return values;
  }
}