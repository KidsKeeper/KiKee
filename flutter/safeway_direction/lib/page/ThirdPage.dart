import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../models/PlaceInfo.dart';
import '../models/RouteSelectCard.dart';
import '../detour.dart';
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
  Set<Polyline> polylines = {};
  List<RouteSelectionClass> routeSelectionList = [];
  List<BitmapDescriptor> locationIcon =
      List<BitmapDescriptor>(3); // 현재 위치 표시하는 icon list
  Detour detour;
  PlaceInfo start, end;
  Polyline temp;
  @override
  void initState() {
    super.initState();
    //make status false
    //stopUpdateLocation();
    location = new Location();
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap(cLoc);
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'image/currentLocation1.png')
        .then((onValue) {
      locationIcon[0] = onValue;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'image/currentLocation2.png')
        .then((onValue) {
      locationIcon[1] = onValue;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'image/currentLocation3.png')
        .then((onValue) {
      locationIcon[2] = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<PlaceInfo> route = ModalRoute.of(context).settings.arguments;
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
            bottom: 150,
            right: 20,
            child: FloatingActionButton(
                child: Icon(
                  Icons.gps_fixed,
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
                onPressed: () async {
                  geo.Position currentLocation = await geo.Geolocator()
                      .getLastKnownPosition(
                          desiredAccuracy: geo.LocationAccuracy.high);
                  final GoogleMapController controller =
                      await _mapController.future;
                  controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(currentLocation.latitude,
                              currentLocation.longitude),
                          zoom: 15.500)));
                }),
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
                    )),
          ),
        ],
      ),
    );
  }

  Future<void> updatePinOnMap(LocationData location) async {
    final GoogleMapController controller = await _mapController.future;
    setState(() {
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position:
              LatLng(location.latitude, location.longitude), // updated position
          icon: locationIcon[0]));
    });
  }

  void setPolylines() async {
    print(
        "==================Function setPolylines in ThirdPage.dart is CALLED!==================");
    detour = Detour.map(LatLng(start.latitude, start.longitude),
        LatLng(end.latitude, end.longitude));
    await detour.drawAllPolyline();
    polylines = detour.polylines;
    routeSelectionList =detour.routeSelectionList;
    setState(() {});
  }
}