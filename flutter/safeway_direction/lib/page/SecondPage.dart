import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:safewaydirection/search_map_place.dart';
import 'package:safewaydirection/models/PlaceInfo.dart';
import 'package:safewaydirection/models/RecentSearch.dart';
import 'package:safewaydirection/page/ThirdPage.dart';
import 'package:safewaydirection/page/RecentSearchPage.dart';
import 'package:safewaydirection/src/viewFavorite.dart';
import 'package:safewaydirection/db/KikeeDB.dart';
import 'package:safewaydirection/keys.dart';

class NewSearchPage extends StatefulWidget {
  @override
  _NewSearchPageState createState() => _NewSearchPageState();
}

class _NewSearchPageState extends State<NewSearchPage> {
  bool first = true;

  PlaceInfo start; //시작위치
  PlaceInfo end; //도착위치

  RecentSearch recentSearchInfo; // 최근검색기록

  TextEditingController searchController  =  new TextEditingController(); // SearchBox controller
  TextEditingController searchController2 = new TextEditingController();

  final List<IconData> icons = [
    Icons.add,
    Icons.home,
    Icons.star,
    Icons.school
  ];

  int iconNumber = 0;

  @override
  Widget build(BuildContext context) {
    if (first) {
      start = ModalRoute.of(context).settings.arguments;
      searchController.text = start.description;
    }
    return Scaffold(
        backgroundColor: Color(0xfffcefa3),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 50,
                right: (MediaQuery.of(context).size.width / 20),
                child: InkWell(
                  child: Image.asset('image/_304.png'),
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
              ),//kiki icon to step nextpage
              Positioned(
                top: 90,
                right: (MediaQuery.of(context).size.width / 20),
                child: IconButton(
                  icon: Icon(
                    Icons.swap_vert,
                    color: Color(0xFFF0AD74),
                    size: 40,
                  ),
                  onPressed: () {
                    String tmp = searchController2.text;
                    searchController2.text = searchController.text;
                    searchController.text = tmp;
                    end = start;
                    start = end;
                  },
                ),
              ),//swap source and destination
              Positioned(
                bottom: 100,
                left: 50,
                child: Bubble(
                  padding: BubbleEdges.all(15),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '나를 누르면 길찾기가 시작돼',
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
              ),//bubble, '나를 누르면 길찾기가 시작돼'
              Positioned(
                top: 220,
                left: (MediaQuery.of(context).size.width / 20),
                child: Container(
                  width: MediaQuery.of(context).size.width / 20 * 18,
                  height: MediaQuery.of(context).size.height / 2.8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      color: Colors.white,
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
                      Row(
                        children: <Widget>[
                          InkWell(
                            child: CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.query_builder,
                                color: Colors.white,
                                size: 70,
                              ),
                              backgroundColor: Colors.orange,
                            ),
                            onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => RecentSearchPage(),)); },
                          ),
                          InkWell(
                            child: CircleAvatar(
                              radius: 50,
                              child: Icon(
                                icons[iconNumber],
                                color: Colors.white,
                                size: 70,
                              ),
                              backgroundColor: Colors.greenAccent,
                            ),
                            onTap: () {
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
                          ),
                          InkWell(
                            child: CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.school,
                                color: Colors.white,
                                size: 70,
                              ),
                              backgroundColor: Colors.blueAccent,
                            ),
                            onTap: () {},
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            child: CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.book,
                                color: Colors.white,
                                size: 70,
                              ),
                              backgroundColor: Colors.purple,
                            ),
                            onTap: () {},
                          ),
                          InkWell(
                            child: CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 70,
                              ),
                              backgroundColor: Color(0xFFF0AD74),
                            ),
                            onTap: () {},
                          ),
                          InkWell(
                            child: CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 70,
                              ),
                              backgroundColor: Color(0xFFF0AD74),
                            ),
                            onTap: () {},
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                    ],
                  ),
                ),
              ),//short cut buttons
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
                top: 120,
                left: (MediaQuery.of(context).size.width / 20),
              ),//도착지 검색바
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
                top: 50,
                left: (MediaQuery.of(context).size.width / 20),
              ),//출발지 검색바
            ],
          ),
        ));
  }
}
