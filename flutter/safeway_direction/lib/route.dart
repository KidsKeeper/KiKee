import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safewaydirection/utility.dart' as utility;
import 'package:safewaydirection/tMap.dart';

class Route{
  String _origin = 'origin';
  String _destination = 'destination';
  String get origin => _origin;
  String get destination => _destination;

  List<_Point> locations = [];
  Route(this._origin, this._destination);

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

  updateDanger(BadPoint dangerList) async{
    for(var iter in locations)
      if(dangerList.roadName.contains(iter.roadName)){
        List<LatLng> dataList = await TmapServices.getNearRoadInformation(iter.location);
        for(var iter2 in dataList)
          if(dangerList.badLocation.contains(utility.Pair.geometryFloor(iter2)))
            iter.danger += 1;
      }
  }

}
class _Point{
  LatLng location;
  int danger = 0;
  String roadName;

  _Point(this.location, this.danger, this.roadName);
}

class BadPoint{
  Set<utility.Pair<double,double>> badLocation = {};
  Set<String> roadName = {};

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