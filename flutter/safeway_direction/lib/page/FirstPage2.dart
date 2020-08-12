import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../keys.dart';
import '../db/KikeeDB.dart';
import '../page/SecondPage.dart';
import '../models/PlaceInfo.dart';

class FirstPage2 extends StatefulWidget {
  @override
  _FirstPage2State createState() => _FirstPage2State();
}

class _FirstPage2State extends State<FirstPage2> {
  String myCode =  "미생성";

  @override
  void initState() {
    super.initState();
    setState(() {

      _getKidsKey();
    });
  }

  _getKidsKey() async {
    try { myCode = await KikeeDB.instance.getKidsKey(); }
    catch (e) { print(e); }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xfffcefa3),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('KIKEE',style: TextStyle(fontFamily: 'BMJUA',fontSize: 70,color: Colors.orange) ,),
                Image.asset('image/_304.png',height: 57,),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Text('내 코드를 알려 주세요',style: TextStyle(color: Colors.white,fontFamily: 'BMJUA',fontSize: 20),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.orange,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffe5d877),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                  ),
                  onTap: () async {
                    KikeeDB.instance.insertKidsId();
                    Future.delayed(const Duration(seconds:1));
                    myCode = await KikeeDB.instance.getKidsKey();
                    print(myCode);
                    setState(() {});
                  }
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(myCode,style: TextStyle(color: Colors.blue,fontFamily: 'BMJUA',fontSize: 20),),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffe5d877),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                )
              ],
            ),
            SizedBox(
              height: 45,
            ),
            MaterialButton(
              child: Text('건너뛰기',style: TextStyle(color: Color(0xFFF0AD74),fontFamily: 'BMJUA',fontSize: 17),) ,
              onPressed: () async
              {
//                KikeeDB.instance.insertKidsId();
                 const String PLACES_API_KEY = Keys.place;

                 Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
                 double long = position.longitude;
                 double lat = position.latitude;
                 print('geocode : $long , $lat');

                 String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$PLACES_API_KEY&language=ko';
                 Response response = await Dio().get(url);
                 print('get response');
                 final predictions = response.data['results'];
                 String address = predictions[0]['formatted_address'];
                 PlaceInfo place = new PlaceInfo(latitude: lat,longitude: long,description: address,mainText: "내위치" );
//                PlaceInfo place = PlaceInfo( mainText: 'test 위치', latitude: 35.231618, longitude: 129.084071, description: '부산대학교 정문앞');
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewSearchPage(), settings: RouteSettings(arguments: place),));
              },
            ),

          ],
        ),
      ),
    );
  }
}
