import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'dart:convert';

import '../db/KikeeDB.dart';
import '../models/Kids.dart';

Map <String, String> headers = {
  'Content-type': 'application/json',
  'Accpet': 'application/json'
};

Future<int> kidsIdCompare( int kidsId ) async {
  Map data = { 'kidsId': kidsId };

  print('kidsId comparing');

  const String URL = 'http://3.34.194.177:8088/kids/id/compare';

  try {
    final response = await http.post(
      Uri.encodeFull(URL),
      headers: headers,
      body: jsonEncode(data)
    );

    kidsId = int.parse(response.body);
  }

  catch (e) { print(e); }

  return kidsId;
}

Future<String> kidsKeyCreate( int kidsId ) async {
  Map data = { 'kidsId': kidsId };
  String key;

  print('get a key');

  const String URL = 'http://3.34.194.177:8088/kids/key/create';

  try {
    final response = await http.post(
      Uri.encodeFull(URL),
      headers: headers,
      body: jsonEncode(data)
    );

    key = response.body;
  }

  catch (e) { print(e); }

  return key;
}

Future<void> updatePolygon(List<LatLng> points) async {
  List<Kids> kids = await KikeeDB.instance.getKids();
  const String URL = 'http://3.34.194.177:8088/kids/location/start';

  try {
    print('polygon send');
    int kidsId = kids[0].kidsId;
    String key = kids[0].key;

    Map data = { 'kidsId': kidsId, 'key': key, 'polygon': points, 'start':points[0], 'end':points.last };

    final response = await http.post(
        Uri.encodeFull(URL),
        headers: headers,
        body: jsonEncode(data)
    );
  }

  catch (e) { print(e); }
}

Future<void> updateLocation() async {
  List<Kids> kids = await KikeeDB.instance.getKids();
  const String URL = 'http://3.34.194.177:8088/kids/location/start';

  try {
    int count = 0;
    int kidsId = kids[0].kidsId;
    String key = kids[0].key;

    Timer.periodic( new Duration(seconds: 1), (timer) async {
      print(count);
      if( count < 10 ) {
        Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
        double lon = position.longitude;
        double lat = position.latitude;

        Map data = { 'kidsId': kidsId, 'key': key, 'lon': lon, 'lat': lat};

        count++;

        final response = await http.post(
            Uri.encodeFull(URL),
            headers: headers,
            body: jsonEncode(data)
        );
      }

      else {
        count = 0;
        timer.cancel();
      }
    });
  }

  catch (e) { print(e); }

}