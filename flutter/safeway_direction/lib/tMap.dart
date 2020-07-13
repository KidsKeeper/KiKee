import 'dart:convert';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'keys.dart';

import 'package:safewaydirection/route.dart';
class TmapServices{
  static const String projectKey = Keys.tMap;

  static Future<Route> getRoute(LatLng origin, LatLng destination, [List<LatLng> passList]) async {
    List<LatLng> origindata = await getNearRoadInformation(origin);
    origin = origindata != null ? _getPointMeetLine(origindata, origin) : origin;
    List<LatLng> destinationData = await getNearRoadInformation(destination);
    destination = destinationData != null ? _getPointMeetLine(destinationData, destination) : destination;

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
    // 경로 탐색 옵션 추가 코드
    for(var key in requestData.keys)
      body += (key + '=' + requestData[key].toString() + '&');
    body = body.substring(0,body.lastIndexOf('&'));

    // 경유지 있을 경우 추가 코드
    if(passList != null){
      body += '&passList=';
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
    try{
      Map<String,dynamic> values = jsonDecode(response.body);
      Route result = Route.map(values);
      if(passList!=null)
        for(int points =0; points<result.locations.length; points++){
          var lat = passList[0].latitude-result.locations[points].location.latitude;
          var lng = passList[0].longitude-result.locations[points].location.longitude;
          if(lat.abs()<0.00005&&lng.abs()<0.00005){
            result.locations.removeAt(points);
          }
        }
      return result;
    }
    catch(e){
      return null;
    }
  }

  static Future<String> reverseGeocoding(LatLng location) async {
    http.Response response = await http.get("https://apis.openapi.sk.com/tmap/geo/reversegeocoding?version=1&lat=${location.latitude}&lon=${location.longitude}&addressType=A03&appKey=$projectKey");
    Map values = jsonDecode(response.body);
    return values['addressInfo']['roadName'];
  }

  static Future<List<LatLng>> getNearRoadInformation(LatLng position) async {
    try{
      http.Response response = await http.get("https://apis.openapi.sk.com/tmap/road/nearToRoad?version=1&appKey=$projectKey&lat=${position.latitude}&lon=${position.longitude}");
      Map values = jsonDecode(response.body);
      List<LatLng> result = [];

      for(var iter in values['resultData']['linkPoints'])
        result.add(LatLng(iter['location']['latitude'],iter['location']['longitude']));
      return result;
    }
    catch(e){
      return null;
    }
  }

  static LatLng _getPointMeetLine(List<LatLng> lineLatLng, LatLng point){
    LatLng l1 = lineLatLng.first;
    LatLng l2 = lineLatLng.last;

    double a21 = l2.latitude-l1.latitude;
    double b21 = l2.longitude-l1.longitude;

    double x = a21 * point.latitude + b21 * point.longitude;
    x += pow(b21, 2) * l1.latitude / a21;
    x -= b21 * l1.longitude;
    x /= a21 + pow(b21,2) / a21;

    double y = b21 * (x - l1.latitude) / a21 + l1.longitude;

    return LatLng(x,y);
  }
}

