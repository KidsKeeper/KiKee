import 'package:flutter/material.dart';
import 'search_map_place.dart';
import 'package:bubble/bubble.dart';

class NewSearchPage extends StatefulWidget {
  @override
  _NewSearchPageState createState() => _NewSearchPageState();
}

class _NewSearchPageState extends State<NewSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffcefa3),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                child: SearchMapPlaceWidget(
                    apiKey: "AIzaSyArqnmN1rdVusSOjatWg7n-Y4M37x6Y7wU",
                    language: 'ko',
                    hasClearButton: true,
                    iconColor: Color(0xFFF0AD74),
                    placeholder: '도착',
                    onSelected: (place) async {
                      final geolocation = await place.geolocation;
                    }),
                width: (MediaQuery.of(context).size.width / 5) * 4,
                top: 120,
                left: (MediaQuery.of(context).size.width / 20),
              ),
              Positioned(
                child: SearchMapPlaceWidget(
                    apiKey: "AIzaSyArqnmN1rdVusSOjatWg7n-Y4M37x6Y7wU",
                    language: 'ko',
                    hasClearButton: true,
                    iconColor: Color(0xFFF0AD74),
                    placeholder: '출발',
                    onSelected: (place) async {
                      final geolocation = await place.geolocation;
                    }),
                width: (MediaQuery.of(context).size.width / 5) * 4,
                top: 50,
                left: (MediaQuery.of(context).size.width / 20),
              ),
              Positioned(
                top: 90,
                right: (MediaQuery.of(context).size.width / 20),
                child: IconButton(
                  icon: Icon(
                    Icons.swap_vert,
                    color: Color(0xFFF0AD74),
                    size: 40,
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                right: (MediaQuery.of(context).size.width / 20),
                child: Image.asset('image/_304.png'),
              ),
              Positioned(
                bottom: 100,
                left:50,
                child: Bubble(
                  padding: BubbleEdges.all(15),
                  child: Row(children: <Widget>[
                    Text('나를 누르면 길찾기가 시작돼',style: TextStyle(fontFamily: 'BMJUA',fontSize: 15,color: Colors.orange),),
                  ],),
                  nip: BubbleNip.rightTop,
                  radius: Radius.circular(30.0),
                ),
              ),
              Positioned(
                top:220,
                left: (MediaQuery.of(context).size.width / 20),
                child: Container(
                  width: MediaQuery.of(context).size.width/20*18,
                  height: MediaQuery.of(context).size.height/2.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.white,
                    boxShadow: [ BoxShadow(
                      color: Color(0xffe5d877),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(radius:50,child: Icon(Icons.query_builder,color: Colors.white,size: 70,),backgroundColor: Colors.orange,),
                          CircleAvatar(radius:50,child: Icon(Icons.home,color: Colors.white,size: 70,),backgroundColor: Colors.greenAccent,),
                          CircleAvatar(radius:50,child: Icon(Icons.school,color: Colors.white,size: 70,),backgroundColor: Colors.blueAccent,),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                      Row(
                        children: <Widget>[
                          CircleAvatar(radius:50,child: Icon(Icons.book,color: Colors.white,size: 70,),backgroundColor: Colors.purple,),
                          CircleAvatar(radius:50,child: Icon(Icons.add,color: Colors.white,size: 70,),backgroundColor: Color(0xFFF0AD74),),
                          CircleAvatar(radius:50,child: Icon(Icons.add,color: Colors.white,size: 70,),backgroundColor: Color(0xFFF0AD74),),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
