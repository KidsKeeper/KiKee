import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safewaydirection/api/storeInformation/store.dart';
import 'package:safewaydirection/data.dart' as safeway;
import 'package:safewaydirection/tMap.dart';

var height = AppBar().preferredSize.height * 1.1;
var width =  AppBar().preferredSize.width;

safeway.Route a = safeway.Route();

void main() => runApp(MyApp()); //신경

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
} //안써도

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
} //괜찮.

class _MyHomePageState extends State<MyHomePage> {
  bool extended = false;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markerTest = Set<Marker>();
  Set<Marker> markers = {};
  LatLng source = LatLng(35.227934, 129.080416);
  LatLng destination = LatLng(35.2487721, 129.091708);
  @override
  initState(){
    super.initState();
    markers.add(Marker(
        markerId: MarkerId('source'),
        position: source,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        onTap: ()=>print("출발지")
    ));
    markers.add(Marker(
        markerId: MarkerId('destination'),
        position: destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        onTap: ()=>print("도착지")
    ));
  }

  void getPoints() async{
    print("getPoint!");
    var values = await TmapServices.getRoute(source, destination);
    //print(markers.length);
    for(int i=0; i<values["features"].length; i++){ // points & linestrings
      String type = values["features"][i]["geometry"]["type"];
      List<dynamic> coordi = values["features"][i]["geometry"]["coordinates"];
      //print((coordi[0]).runtimeType);
      if(type =="LineString"){
        for(int j=0;  j<coordi.length; j++){
          LatLng position1 = LatLng(coordi[j][1],coordi[j][0]);
          if(markers.isNotEmpty&&markers.last.position!=position1){
            markers.add(Marker(
                markerId: MarkerId("LineString"+markers.length.toString()),
                position: position1,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                onTap: ()=>print("LineString")
            ));
          }
        }
      }else{
        LatLng position2 = LatLng(coordi[1],coordi[0]);
        if(markers.isNotEmpty&&markers.last.position==position2){
          print(markers.length);
          markers.remove(markers.last);
          print(markers.length);
        }
        markers.add(Marker(
            markerId: MarkerId("Point"+markers.length.toString()),
            position: position2,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            onTap: ()=>print("Point")
        ));
        print(markers.length);
      }
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
            preferredSize: Size.fromHeight(height),
            child : SafeArea(
              child: AppBar(
                automaticallyImplyLeading: true,
                flexibleSpace: Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius : BorderRadius.all(Radius.circular(90))
                  ),
                  child : FlatButton(
                      onPressed: getPoints,
                  ),
                ),
              )
            ),
        ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Opacity(opacity: extended ? 0 : 1,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: markers,
                initialCameraPosition: CameraPosition(target:LatLng(35.2451901, 129.091451),zoom: 14),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ],
        )
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  } //레이아웃 파트. 내가 건들일 게 없음.

}
