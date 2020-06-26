import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safewaydirection/utility.dart';
import 'package:safewaydirection/tMap.dart';

import 'api/storeInformation/store.dart';

class Route{
  int _distance;  // 거리 m

  // 소요 시간. 시간 분으로 나눠서 저장
  int _totalHour;
  int _totalMinute;

  //경로 위험도
  int totalDanger = 0;

  int get distance => _distance;
  int get totalHour => _totalHour;
  int get totalMinute => _totalMinute;


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
    // 총 거리, 소요 시간 입력.
    _distance = data['features'][0]["properties"]["totalDistance"];
    int time = data['features'][0]["properties"]["totalTime"];
    _totalHour = (time / 3600).round();
    _totalMinute = ((time % 3600) / 60).round();

    // 각 경로 입력
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
  updateDanger(Set<BadPoint> dangerList) async{
    // 위험도 0으로 초기화
    totalDanger = 0;
    for(var iter in locations)
      iter.danger = 0;

    Set<String> roadNameList = BadPoint.roadNameToSet(dangerList);

    // 위험도 계산
    for(_Point iter in locations){
      if(roadNameList.contains(iter.roadName)){
        List<LatLng> latlngList = await TmapServices.getNearRoadInformation(iter.location);
        for(LatLng iter2 in latlngList){
          try{
            iter.danger = dangerList.firstWhere((BadPoint iter) => iter.badLocation == Pair.geometryFloor(iter2)).danger;
            break;
          }
          catch(e){}
        }
      }
    }

  }

}
class _Point{
  LatLng location;
  int danger = 0;
  String roadName;
  String description = "";

  _Point(this.location, this.danger, this.roadName);

  @override
  int get hashCode => location.hashCode ^ roadName.hashCode;
  
  @override
  bool operator ==(dynamic other) =>
    other is !_Point ? false : (location == other.location) && (roadName == other.roadName);
  
}


class BadPoint{
  Pair<double,double> badLocation;
  String roadName;
  int danger = 0;

  BadPoint(Pair<double,double> badLocation, String roadName){
    this.badLocation = badLocation;
    this.roadName = roadName;
  }

  @override
  int get hashCode => badLocation.hashCode ^ roadName.hashCode;

  bool operator ==(dynamic other){
    if(other is! BadPoint)
      return false;
    return badLocation == other.badLocation && roadName == other.roadName;
  }

  toLatLng(){
    return LatLng(badLocation.first, badLocation.last);
  }
  
  static updateBadPointTest(Set<BadPoint> result, List<Store> dangerList) async{
    for(Store danger in dangerList){
      List<LatLng> latlngList = await TmapServices.getNearRoadInformation(danger.storeLocation.location);
      for(LatLng iter in latlngList){
        String roadName = await TmapServices.reverseGeocoding(iter);
        Pair<double,double> pairLatLng = Pair.geometryFloor(iter);
        result.firstWhere(
          (BadPoint iter) => iter.roadName == roadName && iter.badLocation == pairLatLng,
          orElse :( ) { result.add(BadPoint(Pair.geometryFloor(iter),roadName)); return result.last;}).danger +=1;
      }
    } 
  }

  static Set roadNameToSet(Set<BadPoint> data){
    Set<String> result= {};
    for(BadPoint iter in data)
      result.add(iter.roadName);
    return result;
  }

  static Set badLocationToSet(Set<BadPoint> data){
    Set<Pair<double,double>> result = {};
    for(BadPoint iter in data)
      result.add(iter.badLocation);
    return result;
  }
}

