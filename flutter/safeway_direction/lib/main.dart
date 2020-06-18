import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:safewaydirection/data.dart' as safeway;
import 'package:safewaydirection/googleMap.dart';
import 'package:safewaydirection/tMap.dart';

var height = AppBar().preferredSize.height * 1.1;
var width =  AppBar().preferredSize.width;

safeway.Route a = safeway.Route();

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
  int _counter = 0;
  bool extended = false;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markerTest = Set<Marker>();
  
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.2476089997793, 129.091698688253),
    zoom: 14.4746,
  );
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _incrementCounter() {
    setState(() {
      /*
      extended = !extended;
      height *= extended? 1.9 : 0.5263;
      _counter++;
      
      markerTest.add(Marker(
               markerId: MarkerId('1'),
               position: LatLng(35.2474465734972, 129.091718486654),
            ));
      markerTest.add(Marker(
               markerId: MarkerId('2'),
               position: LatLng(35.24743597040611, 129.09151701227086),
               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
            ));
      markerTest.add(Marker(
               markerId: MarkerId('3'),
               position: LatLng(35.24774149210607, 129.09153922415),
               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow)
            ));
      markerTest.add(Marker(
          markerId: MarkerId('4'),
          position: LatLng(35.24787758810702, 129.09154755301228),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
      ));
      markerTest.add(Marker(
               markerId: MarkerId('5'),
               position: LatLng(35.2478794789843, 129.091691326138),  
            ));
      markerTest.add(Marker(
               markerId: MarkerId('6'),
               position: LatLng(35.2476089997793, 129.091698688253),  
            ));
      markerTest.add(Marker(
               markerId: MarkerId('7'),
               position: LatLng(35.24661944444444, 129.09141666666667), 
               icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
            ));
      markerTest.add(Marker(
               markerId: MarkerId('8'),
               position: LatLng(35.24841388888889, 129.091575),
               icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)
            ));

      */
      test();

    });
  }

  void test() async{
      LatLng l1 = LatLng(35.2451901, 129.091451);
      LatLng l2 = LatLng(35.2487721, 129.091708);

      LatLng tt = LatLng(35.2476089997793, 129.091698688253);

      //TmapServices.test(LatLng(35.2476089997793, 129.091698688253));
      Map<String,dynamic> t = await TmapServices.getRoute(l1, l2);
      for(Map<String,dynamic> iter in t['features']){
        if(iter['geometry']['type'] == "LineString"){
          for(var iter2 in iter['geometry']['coordinates']){
            markerTest.add(Marker(
               markerId: MarkerId(iter2[1].toString()),
               position: LatLng(iter2[1], iter2[0])
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

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
