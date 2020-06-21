import 'package:google_maps_flutter/google_maps_flutter.dart';

class Route{
  String _origin = 'origin';
  String _destination = 'destination';
  String get origin => _origin;
  String get destination => _destination;

  List<LatLng> locations = [];
  Route(this._origin, this._destination);

  Route.map(Map<String,dynamic> data){
    locations.add(LatLng(data['features'][0]['geometry']['coordinates'][1],data['features'][0]['geometry']['coordinates'][0]));
    for(var iter in data['features'])
      if(iter['geometry']['type'] == 'LineString')
        for(int i =1; i< iter['geometry']['coordinates'].length ; i++)
          locations.add(LatLng(iter['geometry']['coordinates'][i][1],iter['geometry']['coordinates'][i][0]));
  }
}