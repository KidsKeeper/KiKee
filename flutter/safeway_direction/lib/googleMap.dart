import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
const apiKey = "AIzaSyA6fqGeXFYOhuSBrVfvKoFNkN4fGAIwdmM";

class GoogleMapsServices{
  // 한국에서 사용 불가
  static Future<String> getRouteCoordinates(LatLng l1, LatLng l2)async{
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    print("====================>>>>>>>>$values");

    return values["routes"][0]["overview_polyline"]["points"];
  }

  static Future<String> searchPlace(String str) async {
    String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key=$apiKey&inputtype=textquery&input=$str";
    url = Uri.encodeFull(url);
    http.Response response = await http.get(url);
      Map values = jsonDecode(response.body);
    print("====================>>>>>>>>$values");
    
    url = "https://maps.googleapis.com/maps/api/place/details/json?key=$apiKey&place_id=${values['candidates'][0]['place_id']}&language=ko";
    url = Uri.encodeFull(url);
    response = await http.get(url);
    values = jsonDecode(response.body);
    print("====================>>>>>>>>$values");
    return url;
  }
}