import 'dart:async';
import 'package:flutter/material.dart';
import 'search_map_place.dart';
import 'package:safewaydirection/LocalDB.dart';

final String apiKEY = "AIzaSyArqnmN1rdVusSOjatWg7n-Y4M37x6Y7wU";

BorderRadiusGeometry radius = BorderRadius.only(
  topLeft: Radius.circular(24.0),
  topRight: Radius.circular(24.0),
);

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  DataBase db;
  List<DbPlace> recent;
  @override
  void initState() {
    db = DataBase();
    db.databaseInit();
    // TODO: implement initState
    super.initState();
    setting();
  }
  void setting() async
  {
    recent = await db.GetRecentSearch();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            color: Color(0xFFFEF8BE),
            width: MediaQuery.of(context).size.width,
            height: 200.0,
          ),
          Positioned(
            top: 150,
            child: Row(
              children: <Widget>[
                FlatButton.icon(
                    onPressed: (){
                      setState(() {
                        setting();
                      });
                    }, icon: Icon(Icons.home), label: Text('집'),),
                FlatButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.school),
                    label: Text('학교')),
                FlatButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.book),
                    label: Text('도서관')),
                FlatButton.icon(
                    onPressed: null, icon: Icon(Icons.edit), label: Text('수정'),),
                IconButton(
                  icon: Icon(Icons.star),
                ),
              ],
            ),
          ),
          (recent != null)?Positioned(
            top: 200.0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 200.0,
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: recent.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: <Widget>[
                      Icon(
                        Icons.history,
                        color: Colors.orange,
                      ),
                      Container(
                        height: 50,
                        child: Center(
                          child: Text(recent[index].description.length<40?'${recent[index].description}':'${recent[index].description.substring(0,40)}'),
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
              ),
            ),
          ) : Positioned(top:300,child:Text('Now Loading')),
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width * 0.05,
            child: SearchMapPlaceWidget(
              placeholder: '도착',
              language: 'ko',
              apiKey: apiKEY,
              iconColor: Colors.orange,
              onSelected: (place) async {
                final geolocation = await place.geolocation;
                print(geolocation.Lat());
                db.insertRecentSearch(place.description, place.placeId,
                    geolocation.Lat(), geolocation.Lng());
                recent = await db.GetRecentSearch();
                setState(() {});
              },
            ),
          ),
          Positioned(
            top: 40,
            left: MediaQuery.of(context).size.width * 0.05,
            child: SearchMapPlaceWidget(
              placeholder: '출발',
              language: 'ko',
              apiKey: apiKEY,
              iconColor: Colors.orange,
              onSelected: (place) async {
                final geolocation = await place.geolocation;
                print(geolocation.Lat());
                db.insertRecentSearch(place.description, place.placeId,
                    geolocation.Lat(), geolocation.Lng());
                recent = await db.GetRecentSearch();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
