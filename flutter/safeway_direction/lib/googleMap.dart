import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:safewaydirection/route.dart' as way;
import 'package:safewaydirection/utility.dart';

const _apiKey = "AIzaSyA6fqGeXFYOhuSBrVfvKoFNkN4fGAIwdmM";
class GoogleMapsServices{
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

