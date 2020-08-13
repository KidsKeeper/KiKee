import 'package:path/path.dart';
import 'package:safewaydirection/src/Server.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:convert';

import '../models/Favorite.dart';
import '../models/RecentSearch.dart';
import '../models/Kids.dart';
import '../src/Helper.dart';

class KikeeDB {
  KikeeDB._();

  static const databaseName = "kikeeeeeeee.db";
  static final KikeeDB instance = KikeeDB._();
  static Database _database;

  Future<Database> get database async {
    if( _database == null ) return await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    return await openDatabase(
        join( await getDatabasesPath(), databaseName ),
        version: 1,
        onCreate: ( Database db, int version ) async {
          await db.execute( "CREATE TABLE recentsearch (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, placeId TEXT, description TEXT, longitude DOUBLE, latitude DOUBLE, mainText TEXT)" );
          await db.execute( "CREATE TABLE favorite (id INTEGER PRIMARY KEY, description TEXT, longitude DOUBLE, latitude DOUBLE, mainText TEXT, icon INTEGER)" );
          await db.execute( "CREATE TABLE kids (id INTEGER PRIMARY KEY, kidsId INTEGER, key TEXT)" );
        }
    );
  }

  Future<void> insertKidsId() async {
    final Database db = await database;
    int kidsId = await _getKidsId(db);

    if( kidsId != -1 ) { return; } // 전에 kidsId을 생성 했으면 패스

    else { // 처음으로 kidsId를 생성하는거라면
      kidsId = keyGenerate();
      kidsId = await kidsIdCompare(kidsId);
      print(kidsId);

      Kids kids = Kids(
          id: 1,
          kidsId: kidsId,
          key: null
      );

      await db.insert( 'kids', kids.toMap(), conflictAlgorithm: ConflictAlgorithm.replace );
      _insertKidsKey( db, kidsId );
    }
  }

  Future<int> _getKidsId( Database db ) async {
    final List<Map<String, dynamic>> maps = await db.query('kids');
    int kidsId;

    try { kidsId = maps[0]['kidsId']; }
    catch (e) { kidsId = -1; print('no kidsId'); print(e); }

    return kidsId;
  }

  _insertKidsKey( Database db, int kidsId ) async {
    try {
      var data = json.decode( await kidsKeyCreate(kidsId) );

      int result = data['result'];
      String key = data['key'];

      if( result == 1 ) { // 키 값이 잘 생성되었으면
        Map<String, dynamic> row = { 'key': key };

        await db.update( 'kids', row, where: 'id = ?', whereArgs: [1], conflictAlgorithm: ConflictAlgorithm.replace );
      }

      else { print(result); } // 키 값 생성에 실패하면 0을 출력
    }

    catch (e) { print('nunu'); print(e); }
  }

  Future<String> getKidsKey() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('kids');
    int length = maps.length;
    String kidsKey = "";

    try { kidsKey = maps[0]['key']; }
    catch (e) { print(e); }

    return kidsKey;
  }

  // Future<void> 추가?
  insertRecentSearch( RecentSearch data ) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recentsearch');
    int length = maps.length;

    if( length == 21 ) deleteRecentSearch(maps[0]['id']); // user can save recentsearch data up to 20

    for( var i = 0; i < length; i++ ) // to avoid duplication of recentsearch
      if( data.placeId == maps[i]['placeId'] ) return;

    await db.insert(
      'recentsearch',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RecentSearch>> getRecentSearch() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query( 'recentsearch', orderBy: 'id DESC' );

    return List.generate(maps.length, (i) {
      return RecentSearch(
          id: maps[i]['id'],
          placeId: maps[i]['placeId'],
          description: maps[i]['description'],
          longitude: maps[i]['longitude'],
          latitude: maps[i]['latitude'],
          mainText: maps[i]['mainText']
      );
    });
  }

  deleteRecentSearch( int id ) async {
    final db = await database;
    await db.delete( 'recentsearch', where: "id = ?", whereArgs: [id],);
  }

  getFavorite( int id ) async {
    final db = await database;
    var data = await db.query( 'favorite', where: 'id = ?', whereArgs: [id] );

    return data;
  }

  insertFavorite( Favorite data ) async {
    final Database db = await database;

    var result = await db.insert(
      'favorite',
      data.toMap(),
      conflictAlgorithm:  ConflictAlgorithm.replace,
    );

    return result;
  }

  updateFavorite( Favorite data ) async {
    final db = await database;

    await db.update( 'favorite', data.toMap(),
        where: 'id = ?',
        whereArgs: [data.id],
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  deleteFavorite( int id ) async {
    final Database db = await database;
    db.delete( 'favorite', where: 'id = ?', whereArgs: [id] );
  }

  Future<List<Kids>> getKids() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('kids');

    return List.generate(maps.length, (i) {
      return Kids(
          id: maps[i]['id'],
          key: maps[i]['key'],
          kidsId: maps[i]['kidsId']
      );
    });
  }

  deleteKidsId( int id ) async {
    final Database db = await database;
    db.delete( 'kids', where: 'id = ?', whereArgs: [id] );
  }
}