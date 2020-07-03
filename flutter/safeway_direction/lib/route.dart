import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safewaydirection/utility.dart';
import 'package:safewaydirection/tMap.dart';

import 'api/store.dart';
import 'api/accidentInformation.dart';

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
  List<LatLng> crossWalks = [];

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

    String str ="";
    // 각 경로 입력
    locations.add(
      _Point(
        LatLng(data['features'][0]['geometry']['coordinates'][1],data['features'][0]['geometry']['coordinates'][0]),
        0, "",""));
    for(var iter in data['features']){
      if(iter['geometry']['type'] == 'LineString')
        for(int i = 1; i< iter['geometry']['coordinates'].length ; i++){
          locations.add(
            _Point(LatLng(iter['geometry']['coordinates'][i][1],iter['geometry']['coordinates'][i][0]),
            0, iter['properties']['name'], str));
          str ="";
        }
          
      else if(iter['geometry']['type'] == 'Point'){
        str = iter['properties']['description'];
      }
    }
     
    // 횡단보도 좌표 정리
    for(var iter in data['features']){
      if(iter['geometry']['type'] == 'LineString' && iter['properties']['facilityType'] == '15'){
        int i = iter['geometry']['coordinates'].length;
          if( i % 2 == 0)
            crossWalks.add(LatLng((iter['geometry']['coordinates'][(i/2).round()][1] + iter['geometry']['coordinates'][(i/2 -1).round()][1])/2,
                  (iter['geometry']['coordinates'][(i/2).round()][0] + iter['geometry']['coordinates'][(i/2 - 1).round()][0])/2));
          else
            crossWalks.add(LatLng(iter['geometry']['coordinates'][(i/2).round()-1][1],iter['geometry']['coordinates'][(i/2).round()-1][0]));
      }
    }
    
  }
  

  List<LatLng> toLatLngList(){
    List<LatLng> result = [];
    for(_Point iter in locations)
      result.add(iter.location);

    return result;
  }
  Future<void> updateDanger(Set<BadPoint> dangerList) async{
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
            totalDanger += iter.danger;
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

  _Point(this.location, this.danger, this.roadName, this.description);

  @override
  int get hashCode => location.hashCode;
  
  @override
  bool operator ==(dynamic other) =>
    other is !_Point ? false : (location == other.location);
  
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
  
  static Future<void> updateBadPointbyStore(Set<BadPoint> result, List<Store> dangerList) async{
    for(Store danger in dangerList){
      List<LatLng> latlngList = await TmapServices.getNearRoadInformation(danger.location);
      for(LatLng iter in latlngList){
        String roadName = await TmapServices.reverseGeocoding(iter);
        //only test
          if(danger.rdnm != roadName)
            print("roadName different : " + danger.rdnm + " != " + roadName);
        //
        Pair<double,double> pairLatLng = Pair.geometryFloor(iter);
        result.firstWhere(
          (BadPoint iter) => iter.roadName == roadName && iter.badLocation == pairLatLng,
          orElse :( ) { result.add(BadPoint(Pair.geometryFloor(iter),roadName)); return result.last;}).danger +=1;
      }
    } 
  }

  static Future<void> updateBadPointbyAccident(Set<BadPoint> result, List<AccidentArea> dangerList) async{
    for(AccidentArea danger in dangerList){
      List<LatLng> latlngList = await TmapServices.getNearRoadInformation(danger.location);
      for(LatLng iter in  latlngList){
        String roadName = await TmapServices.reverseGeocoding(iter);
        Pair<double,double> pairLatLng = Pair.geometryFloor(iter);
        result.firstWhere(
          (BadPoint iter) => iter.roadName == roadName && iter.badLocation == pairLatLng,
          orElse :( ) { result.add(BadPoint(Pair.geometryFloor(iter),roadName)); return result.last;}).danger += danger.occrrncCnt;
      }
    }

  }

  static Set<String> roadNameToSet(Set<BadPoint> data){
    Set<String> result= {};
    for(BadPoint iter in data)
      result.add(iter.roadName);
    return result;
  }

  static Set<Pair<double,double>> badLocationToSet(Set<BadPoint> data){
    Set<Pair<double,double>> result = {};
    for(BadPoint iter in data)
      result.add(iter.badLocation);
    return result;
  }
}
