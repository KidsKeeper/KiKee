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
    for(int i=0; i<values["features"].length; i++){
      print(values["features"][i]["geometry"]["type"]);
      if(values["features"][i]["geometry"]["type"]=="LineString"){
        var coord = values["features"][i]["geometry"]["coordinates"];
        for(int j=0; j<coord.length; j++){
          String id;
          var color;
          if(j==0 || j==coord.length-1){
            id ="Points";
            color = BitmapDescriptor.hueRed;
          }else{
            id ="LineString";
            color = BitmapDescriptor.hueBlue;
          }
          markers.add(Marker(
              markerId: MarkerId(id+i.toString()),
              position: LatLng(coord[j][1],coord[j][0]),
              icon: BitmapDescriptor.defaultMarkerWithHue(color),
              onTap: ()=>print(id)
          ));
        }
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
