import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../models/routeGuide.dart';
import '../models/PlaceInfo.dart';
import '../models/RouteSelectCard.dart';
import '../detour.dart';
import '../src/Server.dart';
import '../models/utility.dart';
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
  Set<Marker> markers = {};
  Set<Marker> _markers = {};
  Set<Polyline> polylines = {};
  List<RouteSelectionClass> routeSelectionList = [];
  List<BitmapDescriptor> locationIcon = List<BitmapDescriptor>(3); // 현재 위치 표시하는 icon list
  Detour detour;
  PlaceInfo start, end;
  Polyline temp,selectedRoute;
  bool isRoutingStart = false;

  // 경로안내 관련 데이터
  RouteGuide routeGuide;

  @override
  void initState() {
    super.initState();
    //make status false
    stopUpdateLocation();
    print("ThirdPage: initState - stopUpdateLocation called.");
    location = new Location();
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap(cLoc);
      if (routeGuide != null) routeGuide.locationStream.add(cLoc);
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'image/currentLocation1.png').then((onValue) {locationIcon[0] = onValue;});
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'image/currentLocation2.png').then((onValue) {locationIcon[1] = onValue;});
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'image/currentLocation3.png').then((onValue) {locationIcon[2] = onValue;});
  }

  @override
  Widget build(BuildContext context) {
    List<PlaceInfo> route = ModalRoute.of(context).settings.arguments;
    start = route[0];
    end = route[1];
    print("Third Page build runned! (it keeps running, did you know that? - 재원) ");
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
                        ' ${start.mainText} ',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'BMJUA',
                            color: Color(0xffffbb81)),
                      ),
                      Icon(Icons.arrow_forward,color: Colors.orangeAccent,),
                      Text(
                        ' ${end.mainText.length>10?end.mainText.substring(0,10)+"...":end.mainText}',
                        style: TextStyle(
                            fontSize: 20,
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
              setPolylines();
            },
          ),
          Positioned(
            bottom: 150,
            right: 20,
            child: Column(
              children: <Widget>[
                Text('내위치',style: TextStyle(fontFamily: 'BMJUA'),),
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
                      }

                    }),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: routeGuide == null ? routeSelectionList.length : 1, //슬라이드 카드 정보 리스트
                itemBuilder: (BuildContext context, int index) =>
                    routeGuide == null ? GestureDetector(//선택한거 빼고 지우는 부분.
                      child: routeSelectionCard(routeSelectionList[index]),
                      onTap: () {
                        print("ThirdPage: change isRoutingStart Value. Probably");
                        routeGuide = RouteGuide(detour.sortRoute[index]);
                        routeGuide.start();
                        try{
                        var id = routeSelectionList[index].polylineId;
                        for(int i=polylines.length-1; i>-1; i--){
                          if(polylines.toList()[i].polylineId==id){
                            updatePolygon(polylines.toList()[i].points,start.mainText,end.mainText);//부모앱에 아이 길찾기 정보 전송한 부분
                            selectedPolylinePoints = polylines.toList()[i].points;
                            selectedRoute = new Polyline(
                              polylineId: PolylineId("selected_route"),
                              points:selectedPolylinePoints,
                              color: polylines.toList()[i].color,
                              visible: true,
                            );
                          }else{
                            polylines.remove(polylines.toList()[i]);
                          }
                        }
                        polylines.remove(polylines.last);
                        polylines.add(selectedRoute);
                        }
                        catch(e){
                          print(e);
                        }
                        updateLocation();//부모앱에 아이의 현재위치 실시간 알려주는 부분
                        routeSelectionList.clear();
                        setState(() {isRoutingStart=true;});
//                        if(mounted){
//                          setState(() {isRoutingStart=true;print("onTap setState");});
//                        }
                        _zoomStart();
                      },
                      onLongPressStart: (details) {
                        var id = routeSelectionList[index].polylineId;
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
                      onLongPressEnd: (details) {
                        var id = routeSelectionList[index].polylineId;
                        var color = temp.color;
                        for(int i=polylines.length-1; i>-1; i--){
                          if(polylines.toList()[i].polylineId==id){
                            temp = polylines.toList()[i];
                            polylines.remove(polylines.toList()[i]);
                          }
                        }
                        polylines.add(Polyline(
                          polylineId: id,
                          points:temp.points,
                          color:color,//colors[setColorId(routeSelectionList[index].danger)]
                          visible: true,
                        ));
                        setState((){});
                      },
                    ):descriptionCard("${routeGuide.description}", MediaQuery.of(context).size.width * 0.8),),
          ),
        ],
      ),
    );
  }

  void setPolylines() async {
    print("==================Function setPolylines in ThirdPage.dart is CALLED!==================");
    detour = Detour.map(LatLng(start.latitude, start.longitude),
        LatLng(end.latitude, end.longitude));
    await detour.drawAllPolyline();
    polylines = detour.polylines;
    routeSelectionList =detour.routeSelectionList;
    if( this.mounted ) { // setState() called after dispose() 오류 해결 방법
      setState(() {});
    }
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
            icon: locationIcon[0]));
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

  @override
  void dispose() {
    super.dispose();
    if (routeGuide != null) routeGuide.stop();
  }
}

