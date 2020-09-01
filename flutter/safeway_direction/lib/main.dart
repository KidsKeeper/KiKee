import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
// import 'package:safewaydirection/page/ThirdPage.dart';
import 'page/IntroPage.dart';
import 'page/FirstPage2.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(KidsKeeper());

class KidsKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home : KidsKeeperClass());
  }
}

class KidsKeeperClass extends StatefulWidget {
  @override
  _KidsKeeperClassState createState() => _KidsKeeperClassState();
}

class _KidsKeeperClassState extends State<KidsKeeperClass> {
  bool isFirstTime = false;
  Isolate _isolate;
  bool _running = false;
  static int _counter = 0;
  String notification = "";
  ReceivePort _receivePort;

  @override
  void initState() {
    super.initState();
    _start();
    setValue();
  }

  Future<bool> setValue() async {
    final prefs = await SharedPreferences.getInstance();
    int launchCount = prefs.getInt('counter') ?? 0;
    prefs.setInt('counter', launchCount + 1);
//    if (launchCount == 0 ) {
//      print("first launch"); //setState to refresh or move to some other page
//    } else {
//      print("Not first launch");
//      isFirstTime =false;
//    }
    if(launchCount==0){
      isFirstTime = true;
    }
    print(launchCount);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if(_running!=true){
      if(isFirstTime==true){
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home : CarouselWithIndicatorDemo());
      }else{
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home : FirstPage2());
      }
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home : CarouselWithIndicatorDemo());
    }else{//loading
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient:LinearGradient(
                  begin: Alignment.topCenter,
                  end:Alignment.bottomCenter,
                  colors: [Color(0xfffcf2a3),Color(0xfffed7a1)]),
              image: DecorationImage(
                image: AssetImage('image/loadingKidsKeeper.png'),
              )
          ),
        ),
      );
    }
  }

  void _start() async {
    _running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone:() {
      print("isolate (LoadingScreen) done!");
    });
  }

  static void _checkTimer(SendPort sendPort) async {
    Timer.periodic(new Duration(seconds: 3), (Timer t) { //3초마다 확인.
      _counter++;
      String msg = 'notification ' + _counter.toString();
      print('SEND: ' + msg);
      sendPort.send(msg);
    });
  }

  void _handleMessage(dynamic data) async {
    //print('RECEIVED: ' + data);
    notification = data;
    var result = false;
    if(data == "notification 1"){ //첫 시도에만 setPolylines함수 호출.
      result = await setValue(); //result에 값 받길 기다림. 하지만, 여기서 멈추지 않고 _checkTimer->_handleMessage 계속 실행
    }
    if(result == true){//첫번째 시도에서 결국 result값이 받아졌다면 stop됨.
      _stop();
    }
    if(data == null || data =="notification 10"){
      _stop();
    }

  }

  void _stop() {
    if (_isolate != null) {
      if( this.mounted ) {
        setState(() {
          _running = false;
          notification = '';
        });
      }
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }

}
