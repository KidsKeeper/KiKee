import 'package:flutter/material.dart';
import 'DirectionPage.dart';
import 'search_map_place.dart';
import 'package:bubble/bubble.dart';
import 'PlaceInfo.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'LocalDB.dart';


class NewSearchPage extends StatefulWidget {
  @override
  _NewSearchPageState createState() => _NewSearchPageState();
}

class _NewSearchPageState extends State<NewSearchPage> {
  bool first = true;
  PlaceInfo start; //시작위치
  PlaceInfo end; //도착위치
  TextEditingController controller =
      new TextEditingController(); //SearchBox controller
  TextEditingController controller2 = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    if (first) {
      start = ModalRoute.of(context).settings.arguments;
      controller.text = start.description;
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
                          builder: (context) => DirectionPage(),
                          settings: RouteSettings(arguments: args)),
                    );
                  },
                ),
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
                  onPressed: () {
                    String tmp = controller2.text;
                    controller2.text = controller.text;
                    controller.text = tmp;
                    var tmp2 = end;
                    end = start;
                    start = end;
                  },
                ),
              ),
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
              ),
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
                            onTap: () {},
                          ),
                          InkWell(
                            child: CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 70,
                              ),
                              backgroundColor: Colors.greenAccent,
                            ),
                            onTap: () {
                              KikeeDB.instance.getFavorite('1').then((data) {
                                try { controller2.text = data[0]['mainText']; }
                                catch(error) { print(error); }
                              });
                            },
                            onLongPress: ()
                            {
//                              _viewFavorite( context, 1, 'test');
                              print('1');
                              KikeeDB.instance.getFavorite('1').then((data) {
                                try { _viewFavorite( context, '1', data[0]['mainText']); }
                                catch(error) { _viewFavorite( context, '1', ''); }
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
              ),
              Positioned(
                child: SearchMapPlaceWidget(
                    apiKey: "AIzaSyArqnmN1rdVusSOjatWg7n-Y4M37x6Y7wU",
                    language: 'ko',
                    controller: controller2,
                    hasClearButton: true,
                    iconColor: Color(0xFFF0AD74),
                    placeholder: '',
                    lableText: '도착지: ',
                    onSelected: (place) async {
                      final geolocation = await place.geolocation;
                      double lat = geolocation.Lat();
                      double lng = geolocation.Lng();
                      end = PlaceInfo(
                          placeId: place.placeId,
                          description: place.description,
                          longitude: lng,
                          latitude: lat,
                          mainText: place.mainText);
                    }),
                width: (MediaQuery.of(context).size.width / 5) * 4,
                top: 120,
                left: (MediaQuery.of(context).size.width / 20),
              ),
              Positioned(
                child: SearchMapPlaceWidget(
                    apiKey: "AIzaSyArqnmN1rdVusSOjatWg7n-Y4M37x6Y7wU",
                    language: 'ko',
                    controller: controller,
                    hasClearButton: true,
                    iconColor: Color(0xFFF0AD74),
                    placeholder: '',
                    lableText: '내 위치: ',
                    onSelected: (place) async {
                      first = false;
                      final geolocation = await place.geolocation;
                      double lat = geolocation.Lat();
                      double lng = geolocation.Lng();
                      start = PlaceInfo(
                          placeId: place.placeId,
                          description: place.description,
                          longitude: lng,
                          latitude: lat,
                          mainText: place.mainText);
                    }),
                width: (MediaQuery.of(context).size.width / 5) * 4,
                top: 50,
                left: (MediaQuery.of(context).size.width / 20),
              ),
            ],
          ),
        ));
  }
}

_viewFavorite( BuildContext context, String id, String mainText ) {
  PlaceInfo favoriteInfo;
  final favoriteController = new TextEditingController();

  // update favorite
//  if( mainText != '' ) {
    Alert(
      context: context,
      title: '즐겨찾기 수정',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SearchMapPlaceWidget(
              apiKey: "AIzaSyArqnmN1rdVusSOjatWg7n-Y4M37x6Y7wU",
              language: 'ko',
              controller: favoriteController,
              hasClearButton: true,
              iconColor: Color(0xFFF0AD74),
              placeholder: '',
              lableText: '내 위치: ',
              onSelected: (place) async {
                final geolocation = await place.geolocation;
                double lat = geolocation.Lat();
                double lng = geolocation.Lng();
                favoriteInfo = PlaceInfo(
                    placeId: place.placeId,
                    description: place.description,
                    longitude: lng,
                    latitude: lat,
                    mainText: place.mainText);
              }),
          Row(
            children: <Widget>[
              CircleAvatar(radius: 30,
                child: Icon(Icons.book, color: Colors.white, size: 40,),
                backgroundColor: Colors.purple,),
              CircleAvatar(radius: 30,
                child: Icon(Icons.add, color: Colors.white, size: 40,),
                backgroundColor: Color(0xFFF0AD74),),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),

        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            KikeeDB.instance.updateFavorite(favoriteInfo);
            print('db update');
          },
          child: Text(
            "수정",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ],
    ).show();
//  }

  // insert favorite
//  else {
//    Alert(
//      context: context,
//      title: '즐겨찾기 추가',
//      content: Column(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: <Widget>[
//          SearchMapPlaceWidget(
//              apiKey: "AIzaSyArqnmN1rdVusSOjatWg7n-Y4M37x6Y7wU",
//              language: 'ko',
//              controller: favoriteController,
//              hasClearButton: true,
//              iconColor: Color(0xFFF0AD74),
//              placeholder: '',
//              lableText: '내 위치: ',
//              onSelected: (place) async {
//                final geolocation = await place.geolocation;
//                double lat = geolocation.Lat();
//                double lng = geolocation.Lng();
//                favoriteInfo = PlaceInfo(
//                    placeId: place.placeId,
//                    description: place.description,
//                    longitude: lng,
//                    latitude: lat,
//                    mainText: place.mainText);
//                KikeeDB.instance.insertFavorite(favoriteInfo);
//              }),
//          Row(
//            children: <Widget>[
//              CircleAvatar(radius: 30,
//                child: Icon(Icons.book, color: Colors.white, size: 40,),
//                backgroundColor: Colors.purple,),
//              CircleAvatar(radius: 30,
//                child: Icon(Icons.add, color: Colors.white, size: 40,),
//                backgroundColor: Color(0xFFF0AD74),),
//            ],
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          ),
//
//        ],
//      ),
//      buttons: [
//        DialogButton(
//          onPressed: () {
//            KikeeDB.instance.insertFavorite(favoriteInfo);
//            print('db insert');
//          },
//          child: Text(
//            "저장",
//            style: TextStyle(color: Colors.white, fontSize: 15),
//          ),
//        ),
//      ],
//    ).show();
//  }
}