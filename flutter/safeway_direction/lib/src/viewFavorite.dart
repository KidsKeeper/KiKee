import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:safewaydirection/keys.dart';
import '../db/KikeeDB.dart';
import '../models/Favorite.dart';
import '../models/RecentSearch.dart';
import '../models/search_map_place.dart';

viewFavorite(BuildContext context, int id, var data) {
  Favorite favoriteInfo;
  RecentSearch recentSearchInfo;

  final favoriteController = new TextEditingController();

  // update favorite
  try {
    favoriteInfo = Favorite(
      // placeId: place.placeId,
      id: data[0]['id'],
      description: data[0]['description'],
      longitude: data[0]['longtitude'],
      latitude: data[0]['latitude'],
      mainText: data[0]['mainText'],);

    Alert(
      context: context,
      title: '즐겨찾기 수정',
      style: AlertStyle(
        titleStyle: TextStyle( fontFamily: 'BMJUA',color: Colors.black,fontSize: 20),
        backgroundColor: Color(0xfffdfbf4),
        alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0),),),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(height: 20,),
          SearchMapPlaceWidget(
            apiKey: Keys.googleMap,
            language: 'ko',
            controller: favoriteController,
            hasClearButton: true,
            iconColor: Color(0xFFF0AD74),
            placeholder: '주소를 입력해 주세요',
            lableText: '',
            boxShadowColor: Color(0xffe5e3dd),
            onSelected: (place) async {
              final geolocation = await place.geolocation;

              double lat = geolocation.lat();
              double lng = geolocation.lng();

              recentSearchInfo = RecentSearch(
                // id: id,
                placeId: place.placeId,
                description: place.description,
                // longitude: lng,
                // latitude: lat,
                mainText: place.mainText,);

              favoriteInfo = Favorite(
                // placeId: place.placeId,
                id: id,
                description: place.description,
                longitude: lng,
                latitude: lat,
                mainText: place.mainText,);

              _insertRecentSearch(recentSearchInfo);
            },
          ),
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              Container(
                height:80,
                width: 80,
                padding: EdgeInsets.all(10),
                child: RawMaterialButton(
                  onPressed:(){ favoriteInfo.icon = 1; },
                  elevation: 0,
                  fillColor: Color(0xff47c2bb),
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 40,
                  ),
                  shape: CircleBorder(),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffe5e3dd),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),]
                ),
              ),
              Container(
                height:80,
                width: 80,
                padding: EdgeInsets.all(10),
                child: RawMaterialButton(
                  onPressed:() { favoriteInfo.icon = 2; },
                  elevation: 0,
                  fillColor: Color(0xff75b8f4),
                  child: Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 40,
                  ),
                  shape: CircleBorder(),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffe5e3dd),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),]
                ),
              ),
              Container(
                height:80,
                width: 80,
                padding: EdgeInsets.all(10),
                child: RawMaterialButton(
                  onPressed:() { favoriteInfo.icon = 3; },
                  elevation: 0,
                  fillColor: Color(0xffdd84c6),
                  child: Icon(
                    Icons.book,
                    color: Colors.white,
                    size: 40,
                  ),
                  shape: CircleBorder(),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffe5e3dd),
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
      buttons: [
        DialogButton(
          color: Color(0xfff36c4c),
          radius: BorderRadius.circular(15),
          onPressed: () {
            _deleteFavorite(id);
            print('db delete');
            Navigator.pop(context);
          },
          child:
          Text("삭제", style: TextStyle(color: Colors.white, fontSize: 15,fontFamily: 'BMJUA')),
        ),
        DialogButton(
          color: Color(0xfff7b413),
          radius: BorderRadius.circular(15),
          onPressed: () {
            _updateFavorite(favoriteInfo);
            print('db update');
            Navigator.pop(context);
          },
          child:
          Text("수정", style: TextStyle(color: Colors.white, fontSize: 15,fontFamily: 'BMJUA')),
        ),
      ],
    ).show();
  }

  // insert favorite
  catch (error) {
    Alert(
      context: context,
      title: '즐겨찾기 추가',
      style: AlertStyle(
        titleStyle: TextStyle( fontFamily: 'BMJUA',color: Colors.black,fontSize: 20),
        backgroundColor: Color(0xfffdfbf4),
        alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0),),
        ),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(height: 20,),
          SearchMapPlaceWidget(
            apiKey: Keys.googleMap,
            language: 'ko',
            controller: favoriteController,
            hasClearButton: true,
            iconColor: Color(0xFFF0AD74),
            placeholder: '주소를 입력해 주세요',
            lableText: '',
            boxShadowColor: Color(0xffe5e3dd),
            onSelected: (place) async {
              final geolocation = await place.geolocation;

              double lat = geolocation.lat();
              double lng = geolocation.lng();

              recentSearchInfo = RecentSearch(
                // id: id,
                placeId: place.placeId,
                description: place.description,
                // longitude: lng,
                // latitude: lat,
                mainText: place.mainText,);

              favoriteInfo = Favorite(
                // placeId: place.placeId,
                id: id,
                description: place.description,
                longitude: lng,
                latitude: lat,
                mainText: place.mainText,);

              _insertRecentSearch(recentSearchInfo);
              // KikeeDB.instance.insertRecentSearch(recentSearchInfo);
            },
          ),
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              Container(
                height:80,
                width: 80,
                padding: EdgeInsets.all(10),
                child: RawMaterialButton(
                  onPressed:(){ favoriteInfo.icon = 1; },
                  elevation: 0,
                  fillColor: Color(0xff47c2bb),
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 40,
                  ),
                  shape: CircleBorder(),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffe5e3dd),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),]
                ),
              ),
              Container(
                height:80,
                width: 80,
                padding: EdgeInsets.all(10),
                child: RawMaterialButton(
                  onPressed:() { favoriteInfo.icon = 2; },
                  elevation: 0,
                  fillColor: Color(0xff75b8f4),
                  child: Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 40,
                  ),
                  shape: CircleBorder(),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffe5e3dd),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),]
                ),
              ),
              Container(
                height:80,
                width: 80,
                padding: EdgeInsets.all(10),
                child: RawMaterialButton(
                  onPressed:() { favoriteInfo.icon = 3; },
                  elevation: 0,
                  fillColor: Color(0xffdd84c6),
                  child: Icon(
                    Icons.book,
                    color: Colors.white,
                    size: 40,
                  ),
                  shape: CircleBorder(),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffe5e3dd),
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
      buttons: [
        DialogButton(
            color: Color(0xfff7b413),
            radius: BorderRadius.circular(15),
            onPressed: () {
              _insertFavorite(favoriteInfo);
              print('db insert');
              Navigator.pop(context);
            },
            child:
            Text("저장", style: TextStyle(color: Colors.white, fontSize: 20,fontFamily: 'BMJUA'))
        ),
      ],
    ).show();
  }
}

_insertRecentSearch ( RecentSearch recentSearchInfo ) { print('recent insert'); KikeeDB.instance.insertRecentSearch(recentSearchInfo); }
_insertFavorite ( Favorite favoriteInfo ) { KikeeDB.instance.insertFavorite(favoriteInfo); }
_updateFavorite ( Favorite favoriteInfo ) { KikeeDB.instance.updateFavorite(favoriteInfo); }
_deleteFavorite ( int id ) { KikeeDB.instance.deleteFavorite(id); }