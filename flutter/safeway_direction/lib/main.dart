import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safewaydirection/api/storeInformation/store.dart';

import 'package:safewaydirection/data.dart' as safeway;
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
  List<LatLng> polylineTest = [];
  Set<Polyline> _polylinemarker = Set<Polyline>();
  
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.2476089997793, 129.091698688253),
    zoom: 14.4746,
  );
  void _incrementCounter() {
    setState(() {
      test();

    });
  }

  void test() async{
      LatLng l1 = LatLng(35.2451901, 129.091451);
      LatLng l2 = LatLng(35.2487721, 129.091708);

      LatLng tt = LatLng(35.2474343, 129.091948);
      List<Store> a = await Store.getStoreListInRectangle(l2, LatLng(35.2463822, 129.089735));

      Set<String> dangerRoute = Set<String>();
      for(Store iter in a){
        markerTest.add(Marker(
               markerId: MarkerId(iter.storeLocation.location.latitude.toString()),
               position: iter.storeLocation.location,
               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow)
            ));
        dangerRoute.add(iter.storeLocation.rdnm);
      }

      markerTest.add(Marker(
               markerId: MarkerId('test'),
               position: tt,
               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
            ));

    
      Map<String,dynamic> t1 = await TmapServices.getNearRoadInformation(tt);

      for(var iter in t1['resultData']['linkPoints']){
            markerTest.add(Marker(
               markerId: MarkerId(iter['location']['longitude'].toString()),
               position: LatLng(iter['location']['latitude'], iter['location']['longitude']),
               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
            ));
      }
      Map<String,dynamic> route4 = await TmapServices.getRoute(l1, l2, 2);
      for(Map<String,dynamic> iter in route4['features']){
        if(iter['geometry']['type'] == "LineString"){
          for(var iter2 in iter['geometry']['coordinates']){
            markerTest.add(Marker(
               markerId: MarkerId(iter2[1].toString()),
               position: LatLng(iter2[1], iter2[0])
            ));
            polylineTest.add(LatLng(iter2[1], iter2[0]));
          }
        }
      }
      _polylinemarker.add(
        Polyline(
        polylineId: PolylineId('4'),
        color: Colors.purple,
        points: polylineTest
        )
      );

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
