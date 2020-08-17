import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safewaydirection/page/ThirdPage.dart';
import '../models/ColorLoader.dart';

class  LoadingPage extends StatefulWidget {
  @override
  State<LoadingPage> createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  @override
  void initState(){
    print("Loading: initState");
    startTimer();
  }
  void startTimer() async{
//    var duration = Duration(seconds:4);
//    print("Loading: startTimer() for 4 sec");
//    return Timer(duration,()=>route());
    await Future.delayed(Duration(minutes: 2),(){route();});
    print("LoadingPage: startTimer done.");
  }
  void route(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>ThirdPage(),settings:RouteSettings(arguments: ModalRoute.of(context).settings.arguments)));
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'loadingPage',
      home: Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient:LinearGradient(
                    begin: Alignment.topCenter,
                    end:Alignment.bottomCenter,
                    colors: [Color(0xfffcf2a3),Color(0xfffed7a1)]),
                image: DecorationImage(
                  image: AssetImage('image/loading.png'),

                )
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("잠시 기다려주세요..",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'BMJUA',
                      color: Colors.orangeAccent),),
                Padding(padding: EdgeInsets.only(bottom: 50),),
                ColorLoader4(),
                Padding(padding: EdgeInsets.only(bottom: 100),),
              ],
            )
        ),
      ),
    );
  }
}
