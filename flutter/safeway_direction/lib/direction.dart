import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TmapServices {
  final String projectKey = "l7xx4e2c5a4554b145d28a4b11ec631adfe5";
  Set<Polyline> _polylines = {};
  Future<Set<Polyline>> getRoute() async {
    http.Response response = await http.post(
        'https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result',
        headers: {
          "version": "1",
        },
        body: {
          "appKey": projectKey,
          "startX": "126.977022",
          "startY": "37.569758",
          "endX": "126.997589",
          "endY": "37.570594",
          "startName": "origin",
          "endName": "destination"
        });
    // 2. 시작, 도착 심볼찍기 - 메인에서
    // 시작

    var values = jsonDecode(response.body)['features'];
    print(values);

    for (int i = 0; i < values.length; i++) {
      var geometry = values[i]['geometry'];
      var properties = values[i]['properties'];
      if (geometry['type'] == "LineString") {
        LatLng start = LatLng(geometry['coordinates'][0][1], geometry['coordinates'][0][0]);
        LatLng end = LatLng(geometry['coordinates'][1][1], geometry['coordinates'][1][0]);
        _polylines.add(Polyline(
          polylineId: PolylineId('pid'+i.toString()),
          points: [start,end],
          color: Colors.yellow,
          visible: true,
        ));
      }
    }
    return _polylines;
  }
}
