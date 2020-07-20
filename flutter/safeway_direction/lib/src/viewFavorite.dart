import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SearchMapPlaceWidget(
            apiKey: "****",
            language: 'ko',
            controller: favoriteController,
            hasClearButton: true,
            iconColor: Color(0xFFF0AD74),
            placeholder: '',
            lableText: '내 위치: ',
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
          Row(
            children: <Widget>[
              InkWell(
                child: CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 50,
                  ),
                  backgroundColor: Color(0xFFF0AD74),
                ),
                onTap: () { favoriteInfo.icon = 1; },
              ),
              InkWell(
                child: CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 50,
                  ),
                  backgroundColor: Color(0xFFF0AD74),
                ),
                onTap: () { favoriteInfo.icon = 2; },
              ),
              InkWell(
                child: CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 50,
                  ),
                  backgroundColor: Color(0xFFF0AD74),
                ),
                onTap: () { favoriteInfo.icon = 3; },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            _updateFavorite(favoriteInfo);
            print('db update');
            Navigator.pop(context);
          },
          child:
              Text("수정", style: TextStyle(color: Colors.white, fontSize: 15)),
        ),
        DialogButton(
          onPressed: () {
            _deleteFavorite(id);
            print('db delete');
            Navigator.pop(context);
          },
          child:
              Text("삭제", style: TextStyle(color: Colors.white, fontSize: 15)),
        ),
      ],
    ).show();
  }
  
  // insert favorite
  catch (error) {
    Alert(
      context: context,
      title: '즐겨찾기 추가',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SearchMapPlaceWidget(
            apiKey: "****",
            language: 'ko',
            controller: favoriteController,
            hasClearButton: true,
            iconColor: Color(0xFFF0AD74),
            placeholder: '',
            lableText: '내 위치: ',
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
          Row(
            children: <Widget>[
              InkWell(
                child: CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 50,
                  ),
                  backgroundColor: Color(0xFFF0AD74),
                ),
                onTap: () { favoriteInfo.icon = 1; },
              ),
              InkWell(
                child: CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 50,
                  ),
                  backgroundColor: Color(0xFFF0AD74),
                ),
                onTap: () { favoriteInfo.icon = 2; },
              ),
              InkWell(
                child: CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 50,
                  ),
                  backgroundColor: Color(0xFFF0AD74),
                ),
                onTap: () { favoriteInfo.icon = 3; },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            _insertFavorite(favoriteInfo);
            print('db insert');
            Navigator.pop(context);
          },
          child:
              Text("저장", style: TextStyle(color: Colors.white, fontSize: 15))
        ),
      ],
    ).show();
  }
}

_insertRecentSearch ( RecentSearch recentSearchInfo ) { print('recent insert'); KikeeDB.instance.insertRecentSearch(recentSearchInfo); }
_insertFavorite ( Favorite favoriteInfo ) { KikeeDB.instance.insertFavorite(favoriteInfo); }
_updateFavorite ( Favorite favoriteInfo ) { KikeeDB.instance.updateFavorite(favoriteInfo); }
_deleteFavorite ( int id ) { KikeeDB.instance.deleteFavorite(id); }