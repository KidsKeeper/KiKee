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
                Container(
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
                SizedBox(
                  width: 20,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text('A5E2',style: TextStyle(color: Colors.blue,fontFamily: 'BMJUA',fontSize: 20),),
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
                KikeeDB.instance.insertKidsId();
                // const String PLACES_API_KEY = Keys.place;

                // Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
                // double long = position.longitude;
                // double lat = position.latitude;
                // print('geocode : $long , $lat');

                // String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$PLACES_API_KEY&language=ko';
                // Response response = await Dio().get(url);
                // print('get response');
                // final predictions = response.data['results'];
                // String address = predictions[0]['formatted_address'];
                // PlaceInfo place = new PlaceInfo(latitude: lat,longitude: long,description: address,mainText: address );
                PlaceInfo place = PlaceInfo( mainText: 'test', latitude: 35.2335912, longitude: 129.0798862, description: 'desc');
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewSearchPage(), settings: RouteSettings(arguments: place),));
              },
            ),

          ],
        ),
      ),
    );
  }
}
