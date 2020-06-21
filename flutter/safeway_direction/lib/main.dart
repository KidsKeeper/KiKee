import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safewaydirection/api/storeInformation/store.dart';

import 'package:safewaydirection/route.dart' as safeway;
import 'package:safewaydirection/googleMap.dart';
import 'package:safewaydirection/tMap.dart';

var height = AppBar().preferredSize.height * 1.1;
var width =  AppBar().preferredSize.width;

safeway.Route a = safeway.Route('origin','destination');

void main() => runApp(MyApp());

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
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool extended = false;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markerTest = Set<Marker>();
  List<LatLng> polylineTest = [];
  Set<Polyline> _polylinemarker = Set<Polyline>();
  

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.2476089997793, 129.091698688253),
    zoom: 14.4746,
  );
  void _incrementCounter() {
      test2();
  }


  void test2() async{
      LatLng l1 = LatLng(35.222752,129.090583);
      LatLng l2 = LatLng(35.222792,129.095795);
      //Set<LatLng> accidentAreas = {LatLng(35.222799633098,129.092828816098)};
      safeway.Route result = await TmapServices.getRoute(l1, l2);
      safeway.BadPoint accidentAreas = safeway.BadPoint();
      accidentAreas.add(LatLng(35.222799633098,129.092828816098));

      markerTest.add(Marker(
              markerId: MarkerId('test'+markerTest.length.toString()),
              position: l1,
            ));
      markerTest.add(Marker(
              markerId: MarkerId('test'+markerTest.length.toString()),
              position: l2,
            ));
      markerTest.add(Marker(
              markerId: MarkerId('test'+markerTest.length.toString()),
              position: accidentAreas.location.first,
            ));
      int i = 1;
      for(var iter in result.locations){
        markerTest.add(Marker(
              markerId: MarkerId('test'+markerTest.length.toString()),
              position: iter.location,
              icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
            ));
        if(i == 10){
          List<LatLng> test1= await TmapServices.getNearRoadInformation(iter.location);
          for(var iter in test1)
          markerTest.add(Marker(
              markerId: MarkerId('test'+markerTest.length.toString()),
              position: iter,
              icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
            ));
        }
        if(i == 11){
          List<LatLng> test2= await TmapServices.getNearRoadInformation(iter.location);
          for(var iter in test2)
          markerTest.add(Marker(
              markerId: MarkerId('test'+markerTest.length.toString()),
              position: iter,
              icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)
            ));
        }
        List<LatLng> test3= await TmapServices.getNearRoadInformation(accidentAreas.location.first);
          for(var iter in test3)
          markerTest.add(Marker(
              markerId: MarkerId('test'+markerTest.length.toString()),
              position: iter,
              icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow)
            ));

            //Map<String,dynamic> iii = await TmapServices.getNearRoadInformation(LatLng(iter2[1], iter2[0]));
            //polylineTest.add(iter);
            i++;
      }

      setState(() {     });
            print('t');
      _polylinemarker.add(
        Polyline(
        polylineId: PolylineId('4'),
        color: Colors.purple,
        points: polylineTest
        )
      );
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
            preferredSize: Size.fromHeight(height),
            child : SafeArea(
              child: AppBar(

                automaticallyImplyLeading: true,
                flexibleSpace: Column(
                  children: <Widget>[
                    SafeArea( // 첫번째
                      child : !extended ?
                        Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.yellow[100],
                              borderRadius : BorderRadius.all(Radius.circular(90))
                          ),
                          child : FlatButton(
                              onPressed: _incrementCounter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      ':',
                                      style: TextStyle(fontFamily: 'BM',fontWeight: FontWeight.bold, fontSize: 30, color: Colors.orange)
                                  ),
                                  Text(
                                    a.origin + ' -> ' + a.destination,
                                    style: TextStyle(fontFamily: 'BM',fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      width: 40,
                                      child : FlatButton(onPressed: _incrementCounter,
                                        child: Container(
                                            alignment: Alignment.center,
                                            child : Icon(Icons.navigate_next,size : 25.0)),
                                      )
                                  )
                                ],
                              )
                          ),
                        )
                        : Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            borderRadius : BorderRadius.all(Radius.circular(90))
                        ),
                        child : FlatButton(
                            onPressed: _incrementCounter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    '출발 : ',
                                    style: TextStyle(fontFamily: 'BM',fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange)
                                ),
                                Text(
                                  a.origin,
                                  style: TextStyle(fontFamily: 'BM',fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                    width: 40,
                                    child : FlatButton(onPressed: _incrementCounter,
                                      child: Container(
                                          alignment: Alignment.center,
                                          child : Icon(Icons.navigate_next,size : 25.0)),
                                    )
                                )
                              ],
                            )
                        ),
                      )
                    ),
                    SafeArea( // 두번쨰
                      child : extended ?
                        Container(
                        alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.all(4),
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                                color: Colors.yellow[100],
                                borderRadius : BorderRadius.all(Radius.circular(90))
                            ),
                            child : FlatButton(
                                onPressed: _incrementCounter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                        '도착 : ',
                                        style: TextStyle(fontFamily: 'BM',fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange)
                                    ),
                                    Text(
                                      a.destination,
                                      style: TextStyle(fontFamily: 'BM',fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                        width: 40,
                                        child : FlatButton(onPressed: _incrementCounter,
                                          child: Container(
                                              alignment: Alignment.center,
                                              child : Icon(Icons.navigate_next,size : 25.0)),
                                        )
                                    )
                                  ],
                                )
                            ),
                          ),

                      )
                        : Container(), //null
                    )
                  ],
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
                markers: markerTest,
                polylines: _polylinemarker,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Center(
              child: Opacity(opacity: extended ? 1 : 0,
                child: WillPopScope(child: Text('dfd'), onWillPop: () { if(extended)_incrementCounter(); else SystemChannels.platform.invokeMethod('SystemNavigator.pop'); return;})
              ),
            )
          ],
        )
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
