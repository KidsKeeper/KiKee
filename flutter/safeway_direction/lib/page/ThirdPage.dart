import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../models/PlaceInfo.dart';
import '../models/RouteSelectCard.dart';

import '../src/Server.dart';

LocationData currentLocation; // a reference to the destination location
LocationData destinationLocation; // wrapper around the location API
Location location;

BorderRadiusGeometry radius = BorderRadius.only(
  topLeft: Radius.circular(24.0),
  topRight: Radius.circular(24.0),
);

class ThirdPage extends StatefulWidget {
  @override
  State<ThirdPage> createState() => ThirdPageState();
}

class ThirdPageState extends State<ThirdPage> {
  Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> markers = {};
  Set<Marker> _markers = {};
  Set<Polyline> polylines = {}; //지도 위의 경로, 정렬 될 필요 없음.
  var polyline = Polyline(points:[LatLng(35.22270817033447, 129.0905705525998),LatLng(35.222677620569314, 129.09069832009436),LatLng(35.222708172802044, 129.09070387432655),LatLng(35.223166458246446, 129.09089273417646),LatLng(35.22321923051846, 129.09091495301374),LatLng(35.22330255497176, 129.0909399485472),LatLng(35.22341643176059, 129.0909760533848),LatLng(35.22370529011207, 129.09107603673993),LatLng(35.22433577944659, 129.09131766503867),LatLng(35.22462186028004, 129.0914148709337),LatLng(35.22459131087502, 129.09156208117997),LatLng(35.22470518776653, 129.09160374108922),LatLng(35.22460242958336, 129.09203981706162), LatLng(35.22448300706489, 129.09250089131615),LatLng(35.2244718980221, 129.09254533219718),LatLng(35.224383026039746, 129.09292030199686),LatLng(35.22430248573671, 129.093256386064),LatLng(35.22419417226122, 129.09367301943814),LatLng(35.22408030462434, 129.0941313160049),LatLng(35.22357480225127, 129.0939424574549),LatLng(35.223547029490085, 129.09404522704966)],
      color:Colors.white,visible:true);
  List<RouteSelectionClass> routeSelectionList = []; // 카드 위 경로 정보
  //위 리스트를 안전도, 시간에 따라서 정렬하면 됨. 따로 루트를 정렬할 것이 아니고.
  List<BitmapDescriptor> locationIcon =
  List<BitmapDescriptor>(3); // 현재 위치 표시하는 icon list
  PlaceInfo start, end;
  Polyline temp;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<PlaceInfo> route = [PlaceInfo(
        placeId:"ChIJ-zyE3ZWTaDURjRsZsKwFBU0",
        description:"대한민국 부산광역시 금정구 부곡1동 부곡동 우체국",
        longitude: 129.0906112,
        latitude: 35.2227719,
        mainText: "부곡동 우체국"),
      PlaceInfo(
          placeId:"ChIJoe5RrL-TaDURw0PWEduDAH4",
          description:"대한민국 부산광역시 금정구 부곡동 부곡삼한사랑채아파트 입주자대표회의",
          longitude: 129.0940481,
          latitude: 35.2235147,
          mainText: "부곡삼한사랑채아파트 입주자대표회의")];


    start = route[0];
    end = route[1];

    for (int i = 0; i < 2; i++) {
      _markers.add(Marker(
        markerId: MarkerId(_markers.length.toString()),
        position: LatLng(route[i].latitude, route[i].longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }

    //출발지, 도착지에 마커 찍는 부분.

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng((route[0].latitude + route[1].latitude) / 2,
                  (route[0].longitude + route[1].longitude) / 2),
              zoom: 15.0,
            ),
            markers: _markers,
            polylines: polylines,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
              setPolylines();
            },
          ),
          Container(
            color: Color(0xFFFFE600),
            width: MediaQuery.of(context).size.width,
            height: 90.0,
          ),
          Positioned(
            top: 10.0,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          ' ${start.mainText} -> ${end.mainText}',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'BMJUA',
                              color: Colors.orange),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Color(0xfffef8be),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: routeSelectionList.length, //슬라이드 카드 정보 리스트
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(//선택한거 빼고 지우는 부분.
                      child: routeSelectionCard(routeSelectionList[index]),
                      onTap: () {
                        int len = routeSelectionList.length;
                        var id = routeSelectionList[index].polylineId;
                        for (int i = len - 1; i > -1; i--) {
                          if(i!=index){
                            routeSelectionList.removeAt(i);
                          }
                        }
                        for(int i=polylines.length-1; i>-1; i--){
                          if(polylines.toList()[i].polylineId!=id){
                            polylines.remove(polylines.toList()[i]);
                          }else{
                            updatePolygon(polylines.toList()[i].points);//List<LatLng>
                          }
                        }
                        updateLocation();
                        setState(() { print('set state!'); });
                      },
                      onLongPressStart: (Details) {
                        var id = routeSelectionList[index].polylineId;
                        var temp;
                        for(int i=polylines.length-1; i>-1; i--){
                          if(polylines.toList()[i].polylineId==id){
                            temp = polylines.toList()[i];
                            polylines.remove(polylines.toList()[i]);
                          }
                        }
                        polylines.add(Polyline(
                          polylineId: id,
                          points:temp.points,
                          color:Colors.tealAccent,
                          visible: true,
                          zIndex: 300,
                        ));
                        setState((){});
                      },
                      onLongPressEnd: (Details) {
                        List<Color> colors = [ Colors.red, Colors.yellow, Colors.orange, Colors.blue ];
                        int setColorId(int danger){
                          if(danger<1){ //파랑
                            return 0;
                          }else if(danger<5){//노랑
                            return 1;
                          }else if(danger<10){//주황
                            return 2;
                          }else{//빨강
                            return 3;
                          }
                        }
                        var id = routeSelectionList[index].polylineId;
                        var temp;
                        for(int i=polylines.length-1; i>-1; i--){
                          if(polylines.toList()[i].polylineId==id){
                            temp = polylines.toList()[i];
                            polylines.remove(polylines.toList()[i]);
                          }
                        }
                        polylines.add(Polyline(
                          polylineId: id,
                          points:temp.points,
                          color:colors[setColorId(routeSelectionList[index].danger)],
                          visible: true,
                        ));
                        setState((){});
                      },
                    )),
          ),
        ],
      ),
    );
  }

  void setPolylines() async {
    //여기부터 임시로 내가 넣은 값들
    List<Color> colors = [ Colors.red, Colors.yellow, Colors.orange, Colors.blue ];
    List<int> distance = [587,512,500,500,446,568];
    List<int> danger = [0,5,0,5,10,25];
    List<int> minute = [8,7,7,7,6,8];
    List<List<LatLng>> polylinePoints = [
      [LatLng(35.22270817033447, 129.0905705525998),LatLng(35.222677620569314, 129.09069832009436),LatLng(35.222708172802044, 129.09070387432655),LatLng(35.223166458246446, 129.09089273417646),LatLng(35.22321923051846, 129.09091495301374),LatLng(35.22330255497176, 129.0909399485472),LatLng(35.22341643176059, 129.0909760533848),LatLng(35.22370529011207, 129.09107603673993),LatLng(35.22433577944659, 129.09131766503867),LatLng(35.22462186028004, 129.0914148709337),LatLng(35.22459131087502, 129.09156208117997),LatLng(35.22470518776653, 129.09160374108922),LatLng(35.22460242958336, 129.09203981706162), LatLng(35.22448300706489, 129.09250089131615),LatLng(35.2244718980221, 129.09254533219718),LatLng(35.224383026039746, 129.09292030199686),LatLng(35.22430248573671, 129.093256386064),LatLng(35.22419417226122, 129.09367301943814),LatLng(35.22408030462434, 129.0941313160049),LatLng(35.22357480225127, 129.0939424574549),LatLng(35.223547029490085, 129.09404522704966)],
      [LatLng(35.22270817033447, 129.0905705525998),LatLng(35.222677620569314, 129.09069832009436),LatLng(35.222663733186124, 129.09069554294013),LatLng(35.22217490609867, 129.0910733012687),LatLng(35.222147131794934, 129.09109274478385),LatLng(35.22214435679617, 129.09122606658718),LatLng(35.22211936201513, 129.09135661146513),LatLng(35.22204159701833, 129.09157603894494),LatLng(35.22200826952979, 129.0916899188361),LatLng(35.22194439186482, 129.09190934593437),LatLng(35.22195275063762, 129.09333422166333),LatLng(35.222655454562656, 129.0936008458017),LatLng(35.22357480225127, 129.0939424574549),LatLng(35.223547029490085, 129.09404522704966)],
      [LatLng(35.22270817033447, 129.0905705525998),LatLng(35.222677620569314, 129.09069832009436),LatLng(35.222663733186124, 129.09069554294013),LatLng(35.22217490609867, 129.0910733012687),LatLng(35.222147131794934, 129.09109274478385),LatLng(35.22214435679617, 129.09122606658718),LatLng(35.22211936201513, 129.09135661146513),LatLng(35.22204159701833, 129.09157603894494),LatLng(35.22200826952979, 129.0916899188361),LatLng(35.221991609358454, 129.0919398975323),LatLng(35.22195275063762, 129.09333422166333),LatLng(35.222655454562656, 129.0936008458017),LatLng(35.22357480225127, 129.0939424574549),LatLng(35.223547029490085, 129.09404522704966)],
      [LatLng(35.22270817033447, 129.0905705525998),LatLng(35.222677620569314, 129.09069832009436),LatLng(35.222663733186124, 129.09069554294013),LatLng(35.222147131794934, 129.09109274478385),LatLng(35.22214435679617, 129.09122606658718),LatLng(35.22211936201513, 129.09135661146513),LatLng(35.22204159701833, 129.09157603894494),LatLng(35.22200826952979, 129.0916899188361),LatLng(35.221991609358454, 129.0919398975323),LatLng(35.22195275063762, 129.09333422166333),LatLng(35.222655454562656, 129.0936008458017),LatLng(35.22357480225127, 129.0939424574549),LatLng(35.223547029490085, 129.09404522704966)],
      [LatLng(35.22270817033447, 129.0905705525998),LatLng(35.222677620569314, 129.09069832009436), LatLng(35.222708172802044, 129.09070387432655),LatLng(35.223155360308034, 129.09153712282784),LatLng(35.22296095231516, 129.0923287259252),LatLng(35.222855416408166, 129.09275091429498),LatLng(35.22275265801901, 129.0931758801246),LatLng(35.222655454562656, 129.0936008458017),LatLng(35.22357480225127, 129.0939424574549),LatLng(35.223547029490085, 129.09404522704966)],
      [LatLng(35.22270817033447, 129.0905705525998),LatLng(35.222677620569314, 129.09069832009436),LatLng(35.222708172802044, 129.09070387432655),LatLng(35.223155360308034, 129.09153712282784),LatLng(35.22296095231516, 129.0923287259252),LatLng(35.222855416408166, 129.09275091429498),LatLng(35.22430248573671, 129.093256386064),LatLng(35.22419417226122, 129.09367301943814),LatLng(35.22408030462434, 129.0941313160049),LatLng(35.22357480225127, 129.0939424574549),LatLng(35.223547029490085, 129.09404522704966)
      ]];
    int setColorId(int danger){
      if(danger<1){ //파랑
        return 0;
      }else if(danger<5){//노랑
        return 1;
      }else if(danger<10){//주황
        return 2;
      }else{//빨강
        return 3;
      }
    }
    for( int i = 0; i < polylinePoints.length; i++ ) {
      polylines.add(Polyline(
        polylineId: PolylineId(polylines.length.toString()),
        points:polylinePoints[i],
        color:colors[setColorId(danger[i])],
        visible: true,
      ));
    }
    for (int i = 0; i < 6; i++) {
      routeSelectionList.add(RouteSelectionClass(
        colorId: setColorId(danger[i]),
        distance: distance[i].toString(),
        time: minute[i].toString(),
        polylineId: polylines.toList()[i].polylineId,
        danger: danger[i],
      ));
    }
    routeSelectionList.sort();
    setState(() {});
  }
}

//RouteSelectionList가 자동으로 정렬되게끔 해야할 필요성이 있음. 정렬된 리스트를 넣어주는 것이 아닌.

