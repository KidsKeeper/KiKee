import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

import '../models/search_map_place.dart';
import '../models/PlaceInfo.dart';
import '../models/RecentSearch.dart';
import '../page/ThirdPage.dart';
import '../page/RecentSearchPage.dart';
import '../page/DBpage.dart';
import '../src/viewFavorite.dart';
import '../db/KikeeDB.dart';
import '../keys.dart';
import '../src/Server.dart';
class NewSearchPage extends StatefulWidget {
  @override
  _NewSearchPageState createState() => _NewSearchPageState();
}

class _NewSearchPageState extends State<NewSearchPage> {
  bool first = true;

  PlaceInfo start; // start location class variable
  PlaceInfo end; // end location class variable
  PlaceInfo updateend; // end location given from recent search data

  RecentSearch recentSearchInfo; // recent search class variable

  TextEditingController searchController  =  new TextEditingController(); // start location controller
  TextEditingController searchController2 = new TextEditingController(); // end location controller

  final List<IconData> icons = [ // favorite icons list
    Icons.add,
    Icons.home,
    Icons.star,
    Icons.school
  ];

  int iconNumber = 0; // 몇 번째 즐겨찾기 아이콘을 가리키는 변수, variable which points numberth favorite icons

  void updateEndplace( PlaceInfo end ) { // update end data fetched from recent search
    setState(() { end = updateend; searchController2.text = updateend.mainText; });
    print(end.mainText);
  }

  void moveRecentSearchPage() async { // navigate to recent search page and save its location data using updateend
    updateend = await Navigator.push( context, MaterialPageRoute(builder: (context) => RecentSearchPage()) );
    updateEndplace(updateend);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if(first) {
      start = ModalRoute.of(context).settings.arguments;
      searchController.text = start.description;
    }
    return Scaffold(
      backgroundColor: Color(0xfffce76e),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight((MediaQuery.of(context).size.height / 12)),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xfffdee96),
          title: Text('KIKEE',style: TextStyle(fontFamily: 'BMJUA',color: Colors.orange,fontSize: 40),),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: (width/5)*2 + (height/40)*9,
              left: (MediaQuery.of(context).size.width / 20),
              child: Container(
                width: MediaQuery.of(context).size.width / 20 * 18,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Color(0xfffdee96),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffe5d877),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('즐겨찾기',style: TextStyle(fontFamily: 'BMJUA',fontSize: 20),),
                    Row(
                      children: <Widget>[
                        Container(
                          width : width/4,
                          height: width/4,
                          padding: EdgeInsets.all(width/32),
                          child: RawMaterialButton(
                            onPressed: () { moveRecentSearchPage(); },
                            elevation: 0,
                            fillColor: Color(0xffec748c),
                            child: Icon(
                              Icons.query_builder,
                              color: Colors.white,
                              size: width/8,
                            ),
                            shape: CircleBorder(),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffe2d485),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),]
                          ),
                        ),
                        Container(
                          width : width/4,
                          height: width/4,
                          padding: EdgeInsets.all(width/32),
                          child: RawMaterialButton(
                            onPressed: () {
                              KikeeDB.instance.getFavorite(1).then((data) {
                                try {
                                  setState(() {
                                    iconNumber = data[0]['icon'];
                                  });

                                  print(iconNumber);
                                  searchController2.text = data[0]['mainText'];
                                  end = PlaceInfo(
                                    // placeId: place.placeId,
                                      description: data[0]['description'],
                                      longitude: data[0]['longitude'],
                                      latitude: data[0]['latitude'],
                                      mainText: data[0]['mainText']);
                                } catch (error) {
                                  print(error);
                                }
                              });
                            },
                            onLongPress: () {
                              KikeeDB.instance.getFavorite(1).then((data) {
                                try {
                                  viewFavorite(context, 1, data);
                                } catch (error) {
                                  viewFavorite(context, 1, data);
                                }
                              });
                            },
                            elevation: 0,
                            fillColor: Color(0xff47c2bb),
                            child: Icon(
                              icons[iconNumber],
                              color: Colors.white,
                              size: width/8,
                            ),
                            shape: CircleBorder(),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffe2d485),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),]
                          ),
                        ),
                        Container(
                          width : width/4,
                          height: width/4,
                          padding: EdgeInsets.all(width/32),
                          child: RawMaterialButton(
                            onPressed: null,
                            elevation: 0,
                            fillColor: Colors.blueAccent,
                            child: Icon(
                              Icons.school,
                              color: Colors.white,
                              size: width/8,
                            ),
                            shape: CircleBorder(),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffe2d485),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),]
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width : width/4,
                          height: width/4,
                          padding: EdgeInsets.all(width/32),
                          child: RawMaterialButton(
                            onPressed: null,
                            elevation: 0,
                            fillColor: Colors.purple,
                            child: Icon(
                              Icons.library_books,
                              color: Colors.white,
                              size: width/8,
                            ),
                            shape: CircleBorder(),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffe2d485),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),]
                          ),
                        ),
                        Container(
                          width : width/4,
                          height: width/4,
                          padding: EdgeInsets.all(width/32),
                          child: RawMaterialButton(
                            onPressed: null,
                            elevation: 0,
                            fillColor: Color(0xFFF0AD74),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: width/8,
                            ),
                            shape: CircleBorder(),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffe2d485),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),]
                          ),
                        ),
                        Container(
                          width : width/4,
                          height: width/4,
                          padding: EdgeInsets.all(width/32),
                          child: RawMaterialButton(
                            onPressed: null,
                            elevation: 0,
                            fillColor: Color(0xFFF0AD74),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: width/8,
                            ),
                            shape: CircleBorder(),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffe2d485),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),]
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ],
                ),
              ),
            ), // short cut buttons
            Positioned(
              top: height/24,
              right: (width / 10),
              child: InkWell(
                child: Image.asset('image/_304.png',width: (width/5),),
                onTap: () {
                  List<PlaceInfo> args = [start, end];
                  print(start.mainText);
                  print(end.mainText);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ThirdPage(),
                        settings: RouteSettings(arguments: args)),
                  );
                },
              ),
            ),
            Positioned(
              top: (height/48)*3,
              right: (width/10)*3,
              child: Bubble(
                padding: BubbleEdges.all(15),
                shadowColor: Color(0xffe5d877),
                child: Row(
                  children: <Widget>[
                    Text(
                      '나를 누르면 길찾기를 시작해!',
                      style: TextStyle(
                          fontFamily: 'BMJUA',
                          fontSize: 15,
                          color: Colors.orange),
                    ),
                  ],
                ),
                nip: BubbleNip.rightTop,
                radius: Radius.circular(30.0),
              ),
            ),
            Positioned(
              child: SearchMapPlaceWidget(
                  apiKey: Keys.place,
                  language: 'ko',
                  controller: searchController2,
                  hasClearButton: true,
                  iconColor: Color(0xFFF0AD74),
                  placeholder: '',
                  lableText: '도착지: ',
                  onSelected: (place) async {
                    final geolocation = await place.geolocation;

                    double lat = geolocation.lat();
                    double lng = geolocation.lng();

                    end = PlaceInfo(
                        placeId: place.placeId,
                        description: place.description,
                        longitude: lng,
                        latitude: lat,
                        mainText: place.mainText);

                    recentSearchInfo = RecentSearch(
                        placeId: place.placeId,
                        description: place.description,
                        longitude: lng,
                        latitude: lat,
                        mainText: place.mainText);

                    KikeeDB.instance.insertRecentSearch(recentSearchInfo);
                  }),
              width: (MediaQuery.of(context).size.width / 5) * 4,
              top: (width/5)*2 + (height/48)*5,
              left: (MediaQuery.of(context).size.width / 20),
            ), // 도착지 검색바
            Positioned(
              child: SearchMapPlaceWidget(
                  apiKey: Keys.place,
                  language: 'ko',
                  controller: searchController,
                  hasClearButton: true,
                  iconColor: Color(0xFFF0AD74),
                  placeholder: '',
                  lableText: '출발지: ',
                  onSelected: (place) async {
                    first = false;
                    final geolocation = await place.geolocation;

                    double lat = geolocation.lat();
                    double lng = geolocation.lng();

                    start = PlaceInfo(
                        placeId: place.placeId,
                        description: place.description,
                        longitude: lng,
                        latitude: lat,
                        mainText: place.mainText);

                    recentSearchInfo = RecentSearch(
                        placeId: place.placeId,
                        description: place.description,
                        longitude: lng,
                        latitude: lat,
                        mainText: place.mainText);

                    KikeeDB.instance.insertRecentSearch(recentSearchInfo);
                  }),
              width: (MediaQuery.of(context).size.width / 5) * 4,
              top: (width/5)*2,
              left: (MediaQuery.of(context).size.width / 20),
            ), // 출발지 검색바
            Positioned(
              top: (width/5)*2 + (height/96)*5,
              right: 0,
              child: RawMaterialButton(
                onPressed: () {
                  String tmp = searchController2.text;
                  searchController2.text = searchController.text;
                  searchController.text = tmp;
                  end = start;
                  start = end;
                },
                elevation: 2.0,
                fillColor: Color(0xFFF0AD74),
                child: Icon(
                  Icons.swap_vert,
                  color: Colors.white,
                  size: 40,
                ),
                shape: CircleBorder(),
              ),
            ),

          ],
        ),
      ),);
  }
}

