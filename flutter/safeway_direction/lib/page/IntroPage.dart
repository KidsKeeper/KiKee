import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:safewaydirection/page/FirstPage2.dart';

final List<String> imgList = [
  'image/kiki.png','image/kiki.png'
];
class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;

  void _onIntroEnd(context) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FirstPage2()),
    );
  }

  void updateState(){
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(children: <Widget>[
        Container(
          alignment: Alignment.center,
          color: Color.fromRGBO(255, 252, 223, 1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              CarouselSlider(
                items: imgList.map((item) =>
                    Container(
                      child: Center(
                          child: Image.asset(item,)
                      ),
                    )).toList(),
                options: CarouselOptions(
                    autoPlay: false,
                    height: height,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }
                ),
              )
            ],
          ),
        ),
        Align(alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              imgList.map((url) {
                int index = imgList.indexOf(url);
                return Container(
                  width: 15.0,
                  height: 15.0,
                  margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(254, 215, 161, 0.9)
                          : Color.fromRGBO(255, 255, 255, 1),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffe5d877),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                );
              }).toList(),)
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: GestureDetector(
              child:Container(
                child:Text("건너뛰기",style: TextStyle(color: Color(0xFFF0AD74),fontFamily: 'BMJUA',fontSize: 17,decoration: TextDecoration.none)),
                padding: EdgeInsets.all(15),
              ),
              onTap: ()=>_onIntroEnd(context)
          ),

        ),
        Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              child:Container(
                child:_current==imgList.length-1
                    ? Text("알겠습니다.",style: TextStyle(color: Color(0xFFF0AD74),fontFamily: 'BMJUA',fontSize: 17,decoration: TextDecoration.none))
                    : Container(),
                padding: EdgeInsets.all(15),
              ),
              onTap: ()=>_onIntroEnd(context),
          ),
        ),
      ],
      ),
    );
  }
}