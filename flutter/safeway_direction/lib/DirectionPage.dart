import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'PlaceInfo.dart';
import 'package:location/location.dart';

final String apiKEY = "AIzaSyArqnmN1rdVusSOjatWg7n-Y4M37x6Y7wU";

// the user's initial location and current location
// as it moves
LocationData currentLocation;// a reference to the destination location
LocationData destinationLocation;// wrapper around the location API
Location location;


BorderRadiusGeometry radius = BorderRadius.only(
  topLeft: Radius.circular(24.0),
  topRight: Radius.circular(24.0),
);

class DirectionPage extends StatefulWidget {
  @override
  State<DirectionPage> createState() => DirectionPageState();
}

class DirectionPageState extends State<DirectionPage> {
  Completer<GoogleMapController> _mapController = Completer();
//    target: LatLng(-20.3000, -40.2990),
  List<Marker> markers = [];
  List<DirectionClass> directionList = [DirectionClass(distance: '10',time: '30'),DirectionClass(distance: '5',time: '15'),DirectionClass(distance: '15',time:'45')];
  Set<Polyline> polylines;
  final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(37.569758,126.977022),
    zoom: 14.0000,
  );
  //TmapServices tmapServices = new TmapServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DbPlace> Route = ModalRoute.of(context).settings.arguments;
    DbPlace start = Route[0];
    DbPlace end = Route[1];

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _initialCamera,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
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
            child: FloatingActionButton(child: Icon(Icons.gps_fixed,color: Colors.black,),backgroundColor: Colors.white,),
          ),
          Positioned(
              bottom: 30,
              left: 20,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: ListView.builder(
                itemCount: directionList.length,
                itemBuilder: (BuildContext context, int index) =>
                    directionCard(directionList[index]), scrollDirection: Axis.horizontal,
              )
          ),
        ],
      ),
    );
  }
}

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

class DirectionClass
{
  String distance;
  String time;
  DirectionClass({this.distance,this.time});
}