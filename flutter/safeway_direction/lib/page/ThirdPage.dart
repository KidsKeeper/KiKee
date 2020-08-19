import 'dart:async';
import 'dart:isolate';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:safewaydirection/models/utility.dart';
import '../models/routeGuide.dart';
import '../models/PlaceInfo.dart';
import '../models/RouteSelectCard.dart';
import '../models/ColorLoader.dart';
import '../detour.dart';
import '../src/Server.dart';
import '../models/DescriptionCard.dart';

LocationData currentLocation; // a reference to the destination location
LocationData destinationLocation; // wrapper around the location API
Location location;
List<LatLng> selectedPolylinePoints = [];

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
  Set<Marker> _markers = {};
  Set<Polyline> polylines = {};
  List<RouteSelectionClass> routeSelectionList = [];
  BitmapDescriptor locationIcon; // 현재 위치 표시하는 icon list
  List<BitmapDescriptor> startEndIcon = List<BitmapDescriptor>(2);
  BitmapDescriptor crosswalkIcon; // 횡단보도 아이콘
  Detour detour;
  PlaceInfo start, end;
  Polyline temp,selectedRoute;
  bool isRoutingStart = false;

  // 경로안내 관련 데이터
  RouteGuide routeGuide;

  //isolate variables (start)
  Isolate _isolate;
  bool _running = false;
  static int _counter = 0;
  String notification = "";
  ReceivePort _receivePort;
  //isolate variables (finish)

  @override
  void initState() {
    super.initState();
    _start();
    //make status false
    stopUpdateLocation();
    print("ThirdPage: initState - stopUpdateLocation called.");
    location = new Location();
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap(cLoc);
      if (routeGuide != null) routeGuide.locationStream.add(cLoc);
    });
    
    getBytesFromAsset('image/myPin.png', 110).then((BitmapDescriptor value) => locationIcon = value);
    getBytesFromAsset('image/startMarker.png', 110).then((BitmapDescriptor value) => startEndIcon[0] = value);
    getBytesFromAsset('image/endMarker.png', 110).then((BitmapDescriptor value) => startEndIcon[1] = value);
    getBytesFromAsset('image/crosswalk.png', 110).then((BitmapDescriptor value) => crosswalkIcon = value);
  }

  @override
  Widget build(BuildContext context) {
    List<PlaceInfo> route = ModalRoute.of(context).settings.arguments;
    start = route[0];
    end = route[1];
    print("Third Page build runned! (it keeps running, did you know that? - 재원) ");
    //addMarker(start,end);

    if(startEndIcon[0] != null && startEndIcon[1] != null){
      _markers.add(Marker(
        markerId: MarkerId('start'),
        position: LatLng(route[0].latitude, route[0].longitude),
        icon: startEndIcon[0],
      ));
      _markers.add(Marker(
        markerId: MarkerId('end'),
        position: LatLng(route[1].latitude, route[1].longitude),
        icon: startEndIcon[1],
      ));
    }
      
    //출발지, 도착지에 마커 찍는 부분.
    if(_running!=true){
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Color(0xfffcefa3),
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          ' ${start.mainText.length > 9 ? start.mainText.substring(0, 9) + "..." : start.mainText} ',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'BMJUA',
                              color: Color(0xffffbb81)),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.orangeAccent,),
                        Text(
                          ' ${end.mainText.length > 9 ? end.mainText.substring(0, 9) + "..." : end.mainText}',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'BMJUA',
                              color: Color(0xffffbb81)),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Color(0xffffffff),
                ),
              ),
            ),
          ),
        ),
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
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
            ),
            Positioned(
              bottom: 150,
              right: 20,
              child: Column(
                children: <Widget>[
                  Text('내위치', style: TextStyle(fontFamily: 'BMJUA'),),
                  SizedBox(height: 5,),
                  FloatingActionButton(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Image.asset('image/CurrentLocation.png'),
                      ),
                      backgroundColor: Colors.white,
                      onPressed: () async {
                      geo.Position currentLocation = await geo.Geolocator().getLastKnownPosition(desiredAccuracy: geo.LocationAccuracy.high);
                      final GoogleMapController controller = await _mapController.future;
                      if(isRoutingStart==false){
                        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                            target: LatLng(currentLocation.latitude, currentLocation.longitude),
                            zoom: 15.800)));
                        print('isRoutingStart is false');
                      }else{
                        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                            target: LatLng(currentLocation.latitude, currentLocation.longitude),
                            tilt: 59.440717697143555,
                            bearing: 192.8334901395799,
                            zoom: 19.151926040649414
                        )));
                        print('isRoutingStart is true');
                      }}),
                ],
              ),
            ),
            Positioned(
                bottom: 30,
                left: 20,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: routeGuide == null ? routeSelectionList.length : 1,
                  //슬라이드 카드 정보 리스트
                  itemBuilder: (BuildContext context, int index) =>
                  routeGuide == null ? GestureDetector( //선택한거 빼고 지우는 부분.
                    child: routeSelectionCard(routeSelectionList[index]),
                    onTap: () {
                      print("ThirdPage: change isRoutingStart Value. Probably");
                      routeGuide = RouteGuide(detour.sortRoute[index]);
                      routeGuide.start();
                      for(LatLng iter in routeGuide.route.crossWalks)
                        _markers.add(Marker(
                          markerId: MarkerId('crossWalk ${_markers.length.toString()}'),
                          position:
                          LatLng(iter.latitude, iter.longitude), // updated position
                          icon: crosswalkIcon));
                      try {
                        var id = routeSelectionList[index].polylineId;
                        for (int i = polylines.length - 1; i > -1; i--) {
                          if (polylines.toList()[i].polylineId == id) {
                            updatePolygon(
                                polylines.toList()[i].points, start.mainText,
                                end.mainText); //부모앱에 아이 길찾기 정보 전송한 부분
                            selectedPolylinePoints = polylines.toList()[i]
                                .points;
                            selectedRoute = new Polyline(
                              polylineId: PolylineId("selected_route"),
                              points: selectedPolylinePoints,
                              color: polylines.toList()[i].color,
                              visible: true,
                            );
                          } else {
                            polylines.remove(polylines.toList()[i]);
                          }
                        }
                        polylines.remove(polylines.last);
                        polylines.add(selectedRoute);
                      }
                      catch (e) {
                        print(e);
                      }
                      updateLocation(); //부모앱에 아이의 현재위치 실시간 알려주는 부분
                      routeSelectionList.clear();
                      setState(() {
                        isRoutingStart = true;
                      });
//                        if(mounted){
//                          setState(() {isRoutingStart=true;print("onTap setState");});
//                        }
                      _zoomStart();
                    },
                    onLongPressStart: (details) {
                      var id = routeSelectionList[index].polylineId;
                      for (int i = polylines.length - 1; i > -1; i--) {
                        if (polylines.toList()[i].polylineId == id) {
                          temp = polylines.toList()[i];
                          polylines.remove(polylines.toList()[i]);
                        }
                      }
                      polylines.add(Polyline(
                        polylineId: id,
                        points: temp.points,
                        color: Colors.tealAccent,
                        visible: true,
                        zIndex: 300,
                      ));
                      setState(() {});
                    },
                    onLongPressEnd: (details) {
                      var id = routeSelectionList[index].polylineId;
                      var color = temp.color;
                      for (int i = polylines.length - 1; i > -1; i--) {
                        if (polylines.toList()[i].polylineId == id) {
                          temp = polylines.toList()[i];
                          polylines.remove(polylines.toList()[i]);
                        }
                      }
                      polylines.add(Polyline(
                        polylineId: id,
                        points: temp.points,
                        color: color,
                        //colors[setColorId(routeSelectionList[index].danger)]
                        visible: true,
                      ));
                      setState(() {});
                    },
                  ) : descriptionCard(
                      routeGuide.description, routeGuide.remainDistance,
                      routeGuide.remainTime),)
            ),
          ],
        ),
      );
    }
    else{
      return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient:LinearGradient(
                    begin: Alignment.topCenter,
                    end:Alignment.bottomCenter,
                    colors: [Color(0xfffcf2a3),Color(0xfffed7a1)]),
//                image: DecorationImage(
//                  image: AssetImage('image/loading2.png'),
//                )
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('image/kiki.png'),
                SizedBox(height:20),
                Text("잠시 기다려주세요..", style: TextStyle(fontSize: 25, fontFamily: 'BMJUA', color: Colors.orangeAccent),),
                SizedBox(height:20),
                ColorLoader4(),
                //Padding(padding: EdgeInsets.only(bottom: 100),),
              ],
            )
        ),
      );
    }
  }

  Future<bool> setPolylines() async {
    detour = Detour.map(LatLng(start.latitude, start.longitude),
        LatLng(end.latitude, end.longitude));
    await detour.drawAllPolyline();
    polylines = detour.polylines;
    routeSelectionList =detour.routeSelectionList;
    if( this.mounted ) { // setState() called after dispose() 오류 해결 방법
      setState(() {});
    }
    return true;
  }

  void updatePinOnMap(LocationData location) {
//    final GoogleMapController controller = await _mapController.future;
    if( this.mounted ) { // setState() called after dispose() 오류 해결 방법
      setState(() {
        _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
        _markers.add(Marker(
            markerId: MarkerId('sourcePin'),
            position:
            LatLng(location.latitude, location.longitude), // updated position
            icon: locationIcon));
      });
    }
  }

  Future<void> _zoomStart() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(start.latitude,start.longitude),
        bearing: 192.8334901395799,
        tilt: 59.440717697143555,
        zoom: 19.151926040649414))
    );
  }


  //isolate start
  void _start() async {
    _running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone:() {
      print("isolate (LoadingScreen) done!");
    });
  }

  static void _checkTimer(SendPort sendPort) async {
    Timer.periodic(new Duration(seconds: 3), (Timer t) { //3초마다 확인.
      _counter++;
      String msg = 'notification ' + _counter.toString();
      print('SEND: ' + msg);
      sendPort.send(msg);
    });
  }

  void _handleMessage(dynamic data) async {
    //print('RECEIVED: ' + data);
    setState(() {
      notification = data;
    });
    var result = false;
    if(data == "notification 1"){ //첫 시도에만 setPolylines함수 호출.
      result = await setPolylines(); //result에 값 받길 기다림. 하지만, 여기서 멈추지 않고 _checkTimer->_handleMessage 계속 실행
    }
    if(result == true){//첫번째 시도에서 결국 result값이 받아졌다면 stop됨.
      _stop();
    }
    if(data == null || data =="notification 60"){
      _stop();
    }
  }

  void _stop() {
    if (_isolate != null) {
      setState(() {
        _running = false;
        notification = '';
      });
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
//isolate done


  @override
  void dispose() {
    super.dispose();
    if (routeGuide != null) routeGuide.stop();
  }
}

