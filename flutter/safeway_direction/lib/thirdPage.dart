import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'PlaceInfo.dart';
import 'detour.dart';
import 'route.dart' as way;
import 'package:safewaydirection/RouteSelectCard.dart';
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
  List<routeSelectionClass> routeSelectionList = [];
  //[DirectionClass(distance: '10',time: '30'),DirectionClass(distance: '5',time: '15'),DirectionClass(distance: '15',time:'45')];
  Detour detour;
  Place start,end;

  int _selectedIndex = 0;

  _onSelected ( int index ) {
    setState(() => _selectedIndex = index);
  }


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

  void setPolylines() async{
    print("==================Function setPolylines in thirdPage.dart is CALLED!==================");
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
