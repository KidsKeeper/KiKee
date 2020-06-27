/* When you git pull this code, you should fill out keyblanks at googleMap.dart, tMap.dart, and store.dart */
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
  List<Color> colors = [Colors.red,Colors.orange,Colors.yellow,Colors.green,Colors.blue,Colors.indigo,Colors.purple, Colors.pink,Colors.amber,Colors.black,Colors.white,Colors.brown];
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};
  LatLng source = LatLng(35.2464852,129.090551);
  LatLng destination = LatLng(35.2487721, 129.091708);
  Set<Polyline> polylines = {};
  List<List<LatLng>> polylinePoints = [];
  way.Route route = way.Route();
  Set<way.Route> routes ={};
  List<LatLng> passPoints = [];

  void getPoints() async{
    print("================getPoint!=================");
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

    route = await TmapServices.getRoute(source, destination);  // get route infomation
    Set<way.BadPoint> accidentAreas = {};
    await way.BadPoint.updateBadPointbyStore(accidentAreas, await findNearStoresInRectangle(source, destination));
    await route.updateDanger(accidentAreas);

    List<List<double>> fourWay = [[0.001,0],[-0.001,0],[0,0.001],[0,-0.001]]; //위 아래 오른쪽 왼쪽 100m
    LatLng dp = null;
    for(int i=0; i<route.locations.length; i++){ //받은 값들중에 danger값이 있는지 판별.
      if(route.locations[i].danger>0){
        dp=route.locations[i].location;
        break;
      }
    }
    if(dp!=null){//more than 1 danger point
      for(int direction =0; direction<4; direction++){ //위험 포인트에서 경유 후보 뽑아냄.
        LatLng fourWayPos = LatLng(dp.latitude+fourWay[direction][0],dp.longitude+fourWay[direction][1]);
        var near = await TmapServices.getNearRoadInformation(fourWayPos);
        for(int passPoint =0; passPoint<near.length; passPoint++){
          passPoints.add(LatLng(near[passPoint].latitude,near[passPoint].longitude));
        }
      }
      for(int pp = 0; pp<passPoints.length; pp++){ // 뽑아낸 경유 후보들에서 새로운 경로후보들 뽑음
        route = await TmapServices.getRoute(source, destination,[passPoints[pp]]);
        Set<LatLng> tmp={};
        for(int p = 0; p<route.locations.length; p++){
           if(tmp.contains(route.locations[p].location)){
             p++;
           }else{
             tmp.add(route.locations[p].location);
           }
        }
        polylinePoints.add(tmp.toList());
      }
    }else{ //처음부터 안전경로일 경우.
      //나중에생각하자.
    }
    setState(() {

    });
  } //출발지부터 목적지까지 기본 경로.

  void drawPolyline(int num) async{
    await getPoints();
    if(num>polylinePoints.length){
      print('num is too big');
      return ;
    }
    polylines.clear();
    polylines.add(Polyline(
      polylineId: PolylineId(num.toString()),
      points:polylinePoints[num],
      color: colors[num],
      visible: true,
    ));
    setState(() {

    });
  }


/*
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


*/

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
                  ////////onPressed:  () async =>  {await getPossibleRoute()},
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
                initialCameraPosition: CameraPosition(target:LatLng(35.2464852,129.090551),zoom: 16),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  //getPoints();
                  drawPolyline(7);
                },
              ),
            ),
            FlatButton(
              color: Colors.yellow,
              ///////////onPressed: makePolylineVisible,
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
