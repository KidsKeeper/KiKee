// import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// import 'package:safewaydirection/models/PlaceInfo.dart';
import 'package:safewaydirection/models/Favorite.dart';
import 'package:safewaydirection/models/RecentSearch.dart';

class KikeeDB {
  KikeeDB._();

  static const databaseName = "kikeeeee.db";
  static final KikeeDB instance = KikeeDB._();
  static Database _database;

  Future<Database> get database async {
    if( _database == null ) return await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join( await getDatabasesPath(), databaseName ),
      version: 1,
      onCreate: ( Database db, int version ) async {
        await db.execute( "CREATE TABLE recentsearch (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, placeId TEXT, description TEXT, longitude DOUBLE, latitude DOUBLE, mainText TEXT)" );
        await db.execute( "CREATE TABLE favorite (id INTEGER PRIMARY KEY, description TEXT, longitude DOUBLE, latitude DOUBLE, mainText TEXT, icon INTEGER)" );
      }
    );
  }

  // Future<void> 추가?
  insertRecentSearch( RecentSearch data  ) async {
    final Database db = await database;

    await db.insert(
      'recentsearch',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RecentSearch>> getRecentSearch() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recentsearch');

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
}