import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:safewaydirection/route.dart' as way;
import 'package:safewaydirection/utility.dart';

const _apiKey = "AIzaSyA6fqGeXFYOhuSBrVfvKoFNkN4fGAIwdmM";

class GoogleMapsServices{
  // 도보 경로 탐색, 한국에서 사용 불가
  static Future<String> getRouteCoordinates(LatLng l1, LatLng l2)async{
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$_apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    print("====================>>>>>>>>$values");

    return values["routes"][0]["overview_polyline"]["points"];
  }

  // 장소 정보 받아옴.
  static Future<String> searchPlace(String str) async {
    String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key=$_apiKey&inputtype=textquery&input=$str";
    url = Uri.encodeFull(url);
    http.Response response = await http.get(url);
      Map values = jsonDecode(response.body);
    print("====================>>>>>>>>$values");
    
    url = "https://maps.googleapis.com/maps/api/place/details/json?key=$_apiKey&place_id=${values['candidates'][0]['place_id']}&language=ko";
    url = Uri.encodeFull(url);
    response = await http.get(url);
    values = jsonDecode(response.body);
    print("====================>>>>>>>>$values");
    return url;
  }

  static Set<Polyline> drawPolyline(way.Route routeData, Color color){
    Set<Polyline> _polylinemarker = Set<Polyline>();
          _polylinemarker.add(
            Polyline(
            polylineId: PolylineId(_polylinemarker.length.toString()),
            color: color,
            points: routeData.toLatLngList()
            )
          );
      return _polylinemarker;
  }

  // only use for test
  static Set<Polyline> drawPolylineforTest(way.Route routeData){
    
      Set<Polyline> _polylinemarker = Set<Polyline>();
      List<Pair<List<LatLng>,bool>> data = List<Pair<List<LatLng>,bool>>();
      List<LatLng> n = [];
      n.add(routeData.locations[0].location);
      for(int i = 1; i < routeData.locations.length - 1; i++){
        n.add(routeData.locations[i].location);
        if(routeData.locations[i-1].danger > 0 != routeData.locations[i].danger > 0){
          data.add(Pair(List<LatLng>.from(n),routeData.locations[i-1].danger > 0));
          n.clear();
          n.add(routeData.locations[i].location);
        }
      }
      n.add(routeData.locations[routeData.locations.length - 1].location);
      data.add(Pair(n,routeData.locations[routeData.locations.length-2].danger > 0));
      
      for(Pair<List<LatLng>,bool> iter in data){
        if(iter.last)
          _polylinemarker.add(
            Polyline(
            polylineId: PolylineId(_polylinemarker.length.toString()),
            color: Colors.red,
            points: iter.first
            )
          );
        else
          _polylinemarker.add(
              Polyline(
              polylineId: PolylineId(_polylinemarker.length.toString()),
              color: Colors.blue,
              points: iter.first
              )
            );
      }
      return _polylinemarker;
  }

  

}

