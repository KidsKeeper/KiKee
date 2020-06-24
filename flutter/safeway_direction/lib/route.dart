import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safewaydirection/utility.dart' as utility;
import 'package:safewaydirection/tMap.dart';

import 'api/storeInformation/store.dart';

class Route{
  List<_Point> locations = [];
  
  @override
  int get hashCode {
    int hashCode = 0;
    for(var iter in locations)
      hashCode ^= iter.hashCode;
    return hashCode;
  }
  
  @override
  bool operator ==(dynamic other) => 
    other is !Route ? false : listEquals(this.locations, other.locations);
  

  Route();

  Route.map(Map<String,dynamic> data){
    locations.add(
      _Point(
        LatLng(data['features'][0]['geometry']['coordinates'][1],data['features'][0]['geometry']['coordinates'][0]),
        0, ""));
    for(var iter in data['features'])
      if(iter['geometry']['type'] == 'LineString')
        for(int i = 1; i< iter['geometry']['coordinates'].length ; i++)
          locations.add(
            _Point(LatLng(iter['geometry']['coordinates'][i][1],iter['geometry']['coordinates'][i][0]),
            0, iter['properties']['name']));
  }
  

  List<LatLng> toLatLngList(){
    List<LatLng> result = [];
    for(_Point iter in locations)
      result.add(iter.location);

    return result;
  }
  updateDanger(BadPoint dangerList) async{
    for(var iter in locations)
      if(dangerList.roadName.contains(iter.roadName)){
        List<LatLng> dataList = await TmapServices.getNearRoadInformation(iter.location);
        for(var iter2 in dataList)
          if(dangerList.badLocation.contains(utility.Pair.geometryFloor(iter2))){
            iter.danger += 1;
            break;
          }
      }
  }
}
class _Point{
  LatLng location;
  int danger = 0;
  String roadName;

  _Point(this.location, this.danger, this.roadName);

  @override
  int get hashCode => location.hashCode ^ roadName.hashCode;
  
  @override
  bool operator ==(dynamic other) =>
    other is !_Point ? false : (location == other.location) && (roadName == other.roadName);
  
}

class BadPoint{
  Set<utility.Pair<double,double>> badLocation = {};
  Set<String> roadName = {};
  
  BadPoint();

  addstoreList(List<Store> data) async {
    for(var iter in data)
        await this.add(iter.storeLocation.location);
  }

  add(LatLng data) async{
    List<LatLng> dataList = await TmapServices.getNearRoadInformation(data);
    for(LatLng iter in dataList){
      String roadName = await TmapServices.reverseGeocoding(iter);
      badLocation.add(utility.Pair.geometryFloor(iter));
      this.roadName.add(roadName);
    }
    
  }

  addAll(Iterable<LatLng> data) async{
    for(LatLng iter in data){
      List<LatLng> dataList = await TmapServices.getNearRoadInformation(iter);
      for(LatLng iter2 in dataList){
        String roadName = await TmapServices.reverseGeocoding(iter2);
        badLocation.add(utility.Pair.geometryFloor(iter));
        this.roadName.add(roadName);
      }
    }
  }
  
  Set<LatLng> toLatLngSet(){
    Set<LatLng> result = {};
    for(var iter in badLocation)
      result.add(LatLng(iter.first,iter.last));
    return result;
  }

  List<LatLng> toLatLngList(){
    List<LatLng> result = [];
    for(var iter in badLocation)
      result.add(LatLng(iter.first,iter.last));
    return result;
  }
}