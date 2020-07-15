import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safewaydirection/models/PlaceInfo.dart';
import 'package:location/location.dart';
import 'package:safewaydirection/models/RouteSelectCard.dart';
import 'package:safewaydirection/detour.dart';
import 'package:geolocator/geolocator.dart' as geo;

LocationData currentLocation;// a reference to the destination location
LocationData destinationLocation;// wrapper around the location API
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
  Set<Polyline> polylines ={};
  List<routeSelectionClass> routeSelectionList = [];
  List<BitmapDescriptor> locationIcon = List<BitmapDescriptor>(3); // 현재 위치 표시하는 icon list
  Detour detour;
  PlaceInfo start,end;

  @override
  void initState() {
    super.initState();
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
    List<PlaceInfo> Route = ModalRoute.of(context).settings.arguments;
    start = Route[0];
    end = Route[1];

    for(int i=0; i<2; i++){
      _markers.add(
        Marker(
          markerId:MarkerId(_markers.length.toString()),
          position:LatLng(Route[i].latitude,Route[i].longitude),
          icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        )
      );
    }
      //출발지, 도착지에 마커 찍는 부분.

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng((Route[0].latitude+Route[1].latitude)/2,(Route[0].longitude+Route[1].longitude)/2),
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
            top:10.0,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(' ${start.mainText} -> ${end.mainText}',
                          style: TextStyle(fontSize: 20,fontFamily: 'BMJUA',color: Colors.orange),),
                      ),
                      onTap: ()
                      {
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
              height: 100 ,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: routeSelectionList.length, //슬라이드 카드 정보 리스트
                itemBuilder: (BuildContext context, int index) => GestureDetector(
                  child: routeSelectionCard(routeSelectionList[index]),
                  onTap: () {
                    int len = routeSelectionList.length;
                    for(int id=len-1; id>index; id--){
                      routeSelectionList.removeAt(id);
                      polylines.remove((polylines.toList())[id]);
                      print(id);
                    }
                    for(int id=index-1; id>-1; id--){
                      routeSelectionList.removeAt(id);
                      polylines.remove((polylines.toList())[id]);
                      print(id);
                    }
                    print(routeSelectionList.length);
                    setState(() {

                    });
                  },
                )
              ),
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

  void setPolylines() async{
    print("==================Function setPolylines in ThirdPage.dart is CALLED!==================");
    detour = Detour.map(LatLng(start.latitude,start.longitude),LatLng(end.latitude,end.longitude));
    await detour.drawAllPolyline();
    polylines = detour.polylines;
    for(int i=0; i<detour.sortRoute.length&&i<6; i++){
      routeSelectionList.add(
          routeSelectionClass(distance: detour.sortRoute[i].distance.toString(),colorId: detour.colorsId[i],time:detour.sortRoute[i].totalMinute.toString())
      );
    }
    setState(() {

    });
  }
}
/*

Widget directionCard(DirectionClass dir)
{
  return Card(
    color: Color(0xFFDFFBFF),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    child: Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20,
            child : Icon(Icons.directions_walk,color: Colors.white,),
            backgroundColor: Colors.lightBlue,
          ),
        ),
        Text('${dir.distance}km',style: TextStyle(color: Colors.lightBlue,fontSize: 20,fontFamily: 'BMJUA',textBaseline: TextBaseline.alphabetic ),),
        SizedBox(width: 10,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${dir.time}분',style: TextStyle(color: Color(0xFF0D47A1),fontSize: 40,fontFamily: 'BMJUA'),),
        ),
      ],
    ),

  );
}
 */