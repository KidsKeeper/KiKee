import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';

final List<String> imgList = [
  'image/firstpage_1.png','image/secondpage1.png','image/favoritepage.png','image/secondpage2.png','image/loadingpage.png','image/thirdpage1.png','image/thirdpage2.png',
];

class TutorialDialog extends StatefulWidget {
  TutorialDialog({Key key}) : super(key: key);
  @override
  _TutorialDialogState createState() => _TutorialDialogState();
}
class _TutorialDialogState extends State<TutorialDialog> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(builder: (context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        return Container(
          height: height - 100,
          width: width - 15,
          child: Stack(children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Color.fromRGBO(255, 252, 223, 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CarouselSlider(
                    carouselController: _controller,
                    items: imgList.map((item) =>
                        Container(
                          child: Image.asset(item,),
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top:10),
                        )).toList(),
                    options: CarouselOptions(
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        height:height-150,
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
            Align(
                alignment: Alignment(0.0,0.8),
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
                          color: _current == index ? Color.fromRGBO(254, 215, 161, 0.9) : Color.fromRGBO(255, 255, 255, 1),
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
                    child:Text("건너뛰기",style: TextStyle(color: Color(0xFFF0AD74),fontFamily: 'BMJUA',fontSize: 17,decoration: TextDecoration.none)), padding: EdgeInsets.all(15),),
                  onTap: ()=>_controller.animateToPage(imgList.length-1)),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                  child:Container(
                    child:_current==imgList.length-1 ? Text("알겠습니다.",style: TextStyle(color: Color(0xFFF0AD74),fontFamily: 'BMJUA',fontSize: 17,decoration: TextDecoration.none)) : Container(),
                    padding: EdgeInsets.all(15),
                  ),
                  onTap: ()=> Navigator.of(context).pop()),
            ),
          ],
          ),
        );
      },
      ),
      backgroundColor: Color.fromRGBO(255, 252, 223, 1.0),
    );
  }
}