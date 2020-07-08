import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'PlaceInfo.dart';
import 'detour.dart';
import 'route.dart' as way;
BorderRadiusGeometry radius = BorderRadius.only(
  topLeft: Radius.circular(24.0),
  topRight: Radius.circular(24.0),
);

class thirdPage extends StatefulWidget {
  @override
  State<thirdPage> createState() => thirdPageState();
}

class thirdPageState extends State<thirdPage> {
  Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> markers = {};
  Set<Polyline> polylines ={};
  List<DirectionClass> directionList = [];
  //[DirectionClass(distance: '10',time: '30'),DirectionClass(distance: '5',time: '15'),DirectionClass(distance: '15',time:'45')];
  Detour detour;
  Place start,end;
  @override
  Widget build(BuildContext context) {
    List<Place> Route = ModalRoute.of(context).settings.arguments;
    List<way.Route> routes = [];
    start = Route[0];
    end = Route[1];
    for(int i=0; i<2; i++){
      markers.add(
        Marker(
          markerId:MarkerId(markers.length.toString()),
          position:LatLng(Route[i].latitude,Route[i].longitude),
          icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        )
      );
    }

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
            markers: markers,
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
            child: FloatingActionButton(child: Icon(Icons.gps_fixed,color: Colors.black,),backgroundColor: Colors.white,),
          ),
          Positioned(
              bottom: 30,
              left: 20,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: ListView.builder(
                itemCount: directionList.length, //directionList는 경로 후보
                itemBuilder: (BuildContext context, int index) =>
                    directionCard(directionList[index]), scrollDirection: Axis.horizontal,
              )
          ),
        ],
      ),
    );
  }

  void setPolylines() async{
    print("==================Function setPolylines in thirdPage.dart is CALLED!==================");
    detour = Detour.map(LatLng(start.latitude,start.longitude),LatLng(end.latitude,end.longitude));
    await detour.drawAllPolyline();
    polylines = detour.polylines;
    for(int i=0; i<detour.sortRoute.length&&i<4; i++){
      directionList.add(
          DirectionClass(distance: detour.sortRoute[i].distance.toString(),time:detour.sortRoute[i].totalMinute.toString())
      );
    }
    setState(() {

    });
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
        Text('${dir.distance}m',style: TextStyle(color: Colors.lightBlue,fontSize: 20,fontFamily: 'BMJUA',textBaseline: TextBaseline.alphabetic ),),
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