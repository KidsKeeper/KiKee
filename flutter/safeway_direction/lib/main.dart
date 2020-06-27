import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safewaydirection/api/storeInformation/store.dart';
import 'package:safewaydirection/tMap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:safewaydirection/route.dart' as way;
var height = AppBar().preferredSize.height * 1.1;
var width =  AppBar().preferredSize.width;
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
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<Set<LatLng>> points = [];
  Set<Circle> circles ={};
  List<LatLng> polylinePoints = [];
  List<LatLng> acciPassList = [];
  List<LatLng> passList = [];
  List<List<LatLng>> nearPoints = [];
  LatLng source = LatLng(35.222752,129.090583);
  LatLng destination = LatLng(35.222792,129.095795);
  int visibleColorCnt = 0;
  int num =1;
  way.Route route = way.Route();
  Set<way.Route> routes ={};
  @override
  initState() {
    super.initState();

  }

  void getPoints() async{
    print("================getPoint!=================");
    markers.add(Marker(
        markerId: MarkerId('source'),
        position: source,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        onTap: ()=>print("출발지")
    ));
    route = await TmapServices.getRoute(source, destination);  // get route infomation
    for(int i=0; i<route.locations.length; i++){
      markers.add(Marker(
          markerId: MarkerId("LineString"+markers.length.toString()),
          position: route.locations[i].location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }
    markers.add(Marker(
        markerId: MarkerId('destination'),
        position: destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        onTap: ()=>print("도착지")
    ));
    for(Marker m in markers){
      polylinePoints.add(m.position);
    }
    polylines.add(Polyline(
      polylineId: PolylineId('pid'),
      points:polylinePoints,
      color: Colors.blue,
      visible: true,
    ));
    setState(() {

    });
  } //출발지부터 목적지까지 기본 경로.

  void getAccidentData() async{
//    http.Response response = await http.get("http://3.34.194.177:8088/secret/api/frequently/schoolzone/2018");
//    var values = jsonDecode(response.body);
//    var acciLat = values[0]["la_crd"];
//    var acciLng = values[0]["lo_crd"];
//    var acciPos = LatLng(acciLat,acciLng);
    var acciLat = 35.222799633098;
    var acciLng = 129.092828816098;
    var acciPos = LatLng(35.222799633098,129.092828816098);
    markers.add(Marker(
        markerId: MarkerId('schoolzoneAcci'),
        position: acciPos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        onTap: ()=>print("사고")
    ));
    List<List<double>> fourWay = [[0.001,0],[-0.001,0],[0,0.001],[0,-0.001]]; //위 아래 오른쪽 왼쪽
    for(int i=0; i<4; i++){
      LatLng fourWayPos = LatLng(acciLat+fourWay[i][0],acciLng+fourWay[i][1]);
      markers.add(Marker(
        markerId: MarkerId(markers.length.toString()),
        position: fourWayPos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
      var near = await TmapServices.getNearRoadInformation(fourWayPos);
      for(int j=0; j<near.length; j++){
        var posLat = near[j].latitude;
        var posLng = near[j].longitude;
        print(LatLng(posLat,posLng));
        markers.add(Marker(
          markerId: MarkerId(markers.length.toString()),
          position: LatLng(posLat,posLng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ));
        acciPassList.add(LatLng(posLat,posLng)); //가능한 경유지 정보 저장
      }
    }
    setState(() {

    });
  } //사고지 정보 얻음.

  Future<void> getPossibleRoute() async{
    await getAccidentData();
    List<Color> colors = [Colors.red,Colors.orange,Colors.yellow,Colors.green,Colors.blue,Colors.indigo,Colors.purple, Colors.pink,Colors.amber,Colors.black,Colors.white,Colors.brown];
    for(int i=0; i<acciPassList.length; i++){
      int routesNum = routes.length;
      List<LatLng> tmp = []; // before store to points list.
      route = await TmapServices.getRoute(source, destination,[acciPassList[i]]);
      for(int j=0; j<route.locations.length; j++){
        if(tmp.contains(route.locations[j].location)){
          route.locations.removeAt(j);
          route.locations.removeAt(j+1);
          tmp.removeLast();
        }else {
          tmp.add(route.locations[j].location);
        }
      }
      routes.add(route);
      //print(routesNum);
      //print(routes.length);
      if(routesNum < routes.length){
        points.add(tmp.toSet());
      }
    }

    for(int i=0; i<points.length; i++){
      polylines.add(Polyline(
        polylineId: PolylineId(polylines.length.toString()),
        points: points[i].toList(),//List<LatLng>.from(points[i].toList()),
        color: colors[i],
        visible: false,
      ));
    }
    setState(() {

    });
  } //우회경로를 찍기위한 경유지 위치 후보들을 마커로 찍어서 보여줌.



  void makePolylineVisible(){
    int n = polylines.length;
    if(n==0){
     print("n is 0 right now.");
     return;
    }
    int cnt = visibleColorCnt%n;
    print("n: "+n.toString()+", cnt: "+cnt.toString());
    List<Polyline> polylineList = polylines.toList();
    for(int i=0; i<n; i++){
      if(i==cnt){
        polylineList[cnt] = polylineList[cnt].copyWith(visibleParam: true);
      }else{
        if(polylineList[i].visible == true){
          polylineList[i] = polylineList[i].copyWith(visibleParam: false);
        }
      }
    }
    polylines = polylineList.toSet();
    visibleColorCnt++;
    setState(() {

    });
  } //Button을 누를때마다 폴리라인 경로 하나씩 보여줌.




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
                  onPressed:  () async =>  {await getPossibleRoute()},
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
                polylines: polylines,
                circles: circles,
                initialCameraPosition: CameraPosition(target:LatLng(35.223027,129.092952),zoom: 16),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  //getAccidentData();
                  //getPoints();
                },
              ),
            ),
            FlatButton(
              color: Colors.yellow,
              onPressed: makePolylineVisible,
              child: Text(
                "Button"
              ),
            )
          ],
        )
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  } //레이아웃 파트. 내가 건들일 게 없음.

}
