import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'models/RouteSelectCard.dart';
import 'api/tMap.dart';
import 'api/store.dart';
import 'api/accidentInformation.dart';
import 'models/route.dart' as way;
import 'models/utility.dart';

class Detour{
  List<Color> colors = [ Colors.red, Colors.orange, Colors.yellow, Colors.blue ];
  List<int> colorsId = [];
  Set<Polyline> polylines = {};
  List<List<LatLng>> polylinePoints = [];
  List<RouteSelectionClass> routeSelectionList = [];
  way.Route route = way.Route();
  Set<way.Route> routes = {};
  
  List<way.Route> sortRoute =[];
  LatLng source;
  LatLng destination;

  way.Route selectRoute;

  Detour();
  
  Detour.map(this.source, this.destination){
    print("=============Detour.dart:: mapped==========");
  }

  Future<void> getRouteOrDetour() async{ //이 함수가 호출되면, polylinePoints 리스트의 값이 채워짐.
    int start = -1;
    int end = -1;
    int cnt =0;
    
    print("==========================The First API getRoute in detour.dart is REQUESTED!===================");
    Set<way.BadPoint> accidentAreas = {};

    await Future.wait([
        TmapServices.getRoute(source, destination), // get route infomation
        findNearStoresInRectangle(source, destination),
        getAccidentInformation(source, destination)
      ],
    ).then((result) async {
      route = result[0];
      await way.BadPoint.updateBadPointbyStore( accidentAreas, result[1] );
      await way.BadPoint.updateBadPointbyAccident( accidentAreas, result[2] );
    });
    await route.updateDanger(accidentAreas);

    List<List<double>> fourWay = [ [0.001,0], [-0.001,0], [0,0.001], [0,-0.001] ]; //위 아래 오른쪽 왼쪽 100m
    LatLng dp; // danger point

    for( int i = 0; i < route.locations.length; i++ ) { //받은 값들중에 danger값이 있는지 판별.
      if( route.locations[i].danger > 0 ){
        dp=route.locations[i].location;
        break;
      }
    }

    if(dp!=null){//more than 1 danger point

      List<LatLng> passPoints = [];
      for(int direction =0; direction<4; direction++){ //위험 포인트에서 경유 후보 뽑아냄.
        LatLng fourWayPos = LatLng( dp.latitude+fourWay[direction][0],dp.longitude+fourWay[direction][1] );
        var near = await TmapServices.getNearRoadInformation(fourWayPos);
        var beforeTest = [near.first, near.last];
        //경유 후보 거르기 시작
        double lat = source.latitude-destination.latitude;
        double lng = source.longitude-destination.longitude;
        for(var b in beforeTest){
          var result = true;
          if(lat<0&&lng<0){
            //source 보다 위도 경도 작으면 ban
            if(source.latitude>b.latitude || source.longitude>b.longitude)
              result = false;
          }else if(lat<=0&&lng>0){
            //source 보다 위도 작고 경도 높으면 ban
            if(source.latitude>b.latitude || source.longitude<b.longitude)
              result = false;
          }else if(lat>0&&lng<=0){
            //source 보다 위도 높고 경도 낮으면 ban
            if(source.latitude<b.latitude || source.longitude>b.longitude)
              result = false;
          }else if(lat>=0&&lng>=0){
            //source 보다 위도 크고 경도 크면 ban
            if(source.latitude<b.latitude || source.longitude<b.longitude)
              result = false;
          }
          if(result==true){
            print("added!");
            passPoints.add(b);
          }else{
            print("걸러짐!!");
          }
        }
        //경유 후보 거르기 끝
//        passPoints.add(near.first);
//        passPoints.add(near.last);
      }
      for( int pp = 0; pp<passPoints.length; pp++ ) { // 뽑아낸 경유 후보들에서 새로운 경로후보들 뽑음
        route = await TmapServices.getRoute( source, destination,[passPoints[pp]] );
        print("==========================The Second API getRoute in detour.dart is REQUESTED!===================");
        List<LatLng> checkDuplication=[];
        
        
        for(int p = 0; p<route.locations.length; p++){
          if( checkDuplication.contains(route.locations[p].location) ) { //중복 제거를 위한 범위 검사.
            checkDuplication.add( route.locations[p].location );
            end = p;
            start = checkDuplication.indexOf( route.locations[p].location );
          }
          
          else {
            checkDuplication.add( route.locations[p].location );
          }
        }

        if( start != -1 && end != -1 ){
          for( int cnt = 0; cnt < end - start; cnt++ ) {
            route.locations.removeAt(start);
          }
        }
        routes.add(route);
      }
    }
    
    else { //처음부터 안전경로일 경우.
      routes.add(route);
    }

  
    ReceivePort  _receivePort = ReceivePort();
    _receivePort.listen((value){
      if(value is way.Route)
        sortRoute.add(value);
      });

    for(way.Route iter in routes)
      Isolate.spawn(way.updateDangerinIsolate, Tuple3(_receivePort.sendPort,iter,accidentAreas));
    
    await Future.doWhile( () async {
      if(routes.length == sortRoute.length)
        return false;
      else{
        await Future.delayed(const Duration(milliseconds: 1000), () {});
        return true;
      }
    });
    _receivePort.close();

    sortRoute.sort((a, b) {
      int result = a.totalDanger.compareTo(b.totalDanger);
      if (result == 0) return a.distance.compareTo(b.distance);
      return result;
    });

    
    for(way.Route iter in sortRoute) {
      cnt ++;

      if(iter.totalDanger == 0)
        colorsId.add(3);

      else if(iter.totalDanger <= 5)
        colorsId.add(2);

      else if(iter.totalDanger <= 10)
        colorsId.add(1);

      else
        colorsId.add(0);

      polylinePoints.add(iter.toLatLngList());

      if(cnt ==6)
        break;
    }

    Map<int, List<int>> data = Map<int, List<int>>();
    for(int i in [0,1,2,3])
      data[i] = [0];
    for(int i = 0 ; i < colorsId.length; i++){
      data[colorsId[i]][0]++;
      data[colorsId[i]].add(i);
    }
      
    
    for(int i in [0,1,2,3])
      if(data[i][0] > 2)
        for(int j = data[i].length-1; j>2 ; j--){
          colorsId.removeAt(data[i][j]);
          polylinePoints.removeAt(data[i][j]);
          sortRoute.removeAt(data[i][j]);
        }
  }

  Future<void> drawAllPolyline() async{
    await getRouteOrDetour();
    for( int i = 0; i < polylinePoints.length; i++ ) {
      routeSelectionList.add(RouteSelectionClass(
          distance: sortRoute[i].distance.toString(),
          colorId: colorsId[i],
          time: sortRoute[i].totalMinute.toString(),
          polylineId:PolylineId(polylines.length.toString()),
          danger: sortRoute[i].totalDanger,
      ));
      routeSelectionList.sort();
      polylines.add(Polyline(
        polylineId: PolylineId(polylines.length.toString()),
        points:polylinePoints[i],
        color: colors[colorsId[i]],
        visible: true,
      ));
    }
  }
}