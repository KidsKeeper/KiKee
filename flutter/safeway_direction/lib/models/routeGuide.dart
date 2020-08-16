import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import './route.dart';
import './utility.dart';


/// Route(경로) 데이터를 받아 현재 위치에 따라 경로 안내를 해주는 class
///
/// __Example__
/// ```
/// Route route = Route();
/// RouteGuide routeGuide = RouteGuide(route);
///
/// routeGuide.start(); // 경로 안내 시작.
/// ```
class RouteGuide {
  Route route;

  /// true일때 경로 안내 시작.
  bool started = false;

  /// Route의 locations(list<Point>) index
  int locationIndex = 0;

  String roadName = "";
  String description = "";
  
  /// 도착까지 남은 거리
  int distanceRemain = -1;
  /// 도착까지 남은 시간
  int timeRemain = -1;

  /// 다음 경유지
  ///
  /// 해당 위치에 도달하면 description이 변경됨.
  LatLng nextStop;

  StreamController<LocationData> locationStream =
      StreamController<LocationData>.broadcast();

  /// 마지막 sync 시간. 5초간격으로 연산 하는 용도로 사용.
  DateTime lastSyncTime;

  /// RouteGuide 생성자
  ///
  /// __Example__
  /// ```
  /// Route route = Route();
  /// RouteGuide routeGuide = RouteGuide(route);
  /// ```
  RouteGuide(Route data) {
    route = data;

    distanceRemain = route.distance;
    timeRemain = route.totalHour * 3600 + route.totalMinute * 60;

    roadName = route.locations[locationIndex].roadName;
    description = route.locations[locationIndex].description;
    nextStop = route.locations[locationIndex+1].location;
    lastSyncTime = DateTime.now();

    locationStream.stream.listen((LocationData data) {

      DateTime time = DateTime.now();
      Duration difference = time.difference(lastSyncTime);
      // 경로 안내중일때, 위치가 변경 될 경우 실행.
      if (started && difference.inSeconds > 1) {
        lastSyncTime = time;
        double distance = distanceInMeterByHaversine(LatLng(data.latitude, data.longitude), nextStop); // 현재 위치와 다음 경로 안내 지점과의 거리 계산
        if (distance < 20.00 && locationIndex != route.locations.length) {
          locationIndex++;
          distanceRemain -= route.locations[locationIndex].time;
          timeRemain -= route.locations[locationIndex].distance;

          roadName = route.locations[locationIndex].roadName;
          description = route.locations[locationIndex].description;

          nextStop = route.locations[locationIndex + 1].location;

        }

        if (description == "") description = "경로 따라 진행";
      }
    });
  }

  /// 경로 안내 시작.
  ///
  /// 현재 위치에 따라 description이 변경됨.
  ///
  /// ```
  /// bool started = true;
  /// ```
  start() => started = true;
  stop() => started = false;
}
