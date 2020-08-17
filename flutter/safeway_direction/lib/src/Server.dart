import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'dart:convert';

import '../db/KikeeDB.dart';
import '../models/Kids.dart';
import 'package:location/location.dart';

Location location;
LocationData currentLocation;
StreamSubscription<LocationData> locationSubscription;

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

Future<void> updatePolygon(List<LatLng> points,String source, String destination) async {
  List<Kids> kids = await KikeeDB.instance.getKids();
  const String URL = 'http://3.34.194.177:8088/kids/location/start';

  try {
    print('polygon send');
    int kidsId = kids[0].kidsId;
    String key = kids[0].key;

    Map data = { 'kidsId': kidsId, 'key': key, 'polygon': points, 'start':points[0], 'end':points.last, 'source': source, 'destination':destination };

    await http.post(
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
    int kidsId = kids[0].kidsId;
    String key = kids[0].key;

    location = new Location();
    locationSubscription = location.onLocationChanged.listen((LocationData cLoc) async {
      currentLocation = cLoc;

      Map data = { 'kidsId': kidsId, 'key': key, 'lon': cLoc.longitude, 'lat': cLoc.latitude };
      await http.post(
          Uri.encodeFull(URL),
          headers: headers,
          body: jsonEncode(data)
      );
    });
  }

  catch (e) { print(e); }
}

Future<void> stopUpdateLocation() async {
  List<Kids> kids = await KikeeDB.instance.getKids();
  const String URL = 'http://3.34.194.177:8088/kids/location/end';

  try { locationSubscription.cancel(); }
  catch (e) { print(e); }

  try {
    int kidsId = kids[0].kidsId;
    String key = kids[0].key;

    Map data = { 'kidsId': kidsId, 'key': key };
    final response = await http.post(
        Uri.encodeFull(URL),
        headers: headers,
        body: jsonEncode(data)
    );

    print(response.body);
  }

  catch (e) { print(e); }
}