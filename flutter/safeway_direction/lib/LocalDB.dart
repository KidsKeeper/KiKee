import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'PlaceInfo.dart';

class KikeeDB {
  KikeeDB._();

  static const databaseName = "kikee.db";
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
//          await db.execute( "CREATE TABLE RecentSearch (placeId TEXT PRIMARY KEY, description TEXT, longitude DOUBLE, latitude DOUBLE, mainText TEXT" );
          await db.execute( "CREATE TABLE favorite (placeId TEXT PRIMARY KEY, description TEXT, longitude DOUBLE, latitude DOUBLE, mainText TEXT, icon INTERGER" );
        }
    );
  }

  // Future<void> 추가?
  insertRecentSearch( PlaceInfo place  ) async {
    final Database db = await database;

    await db.insert(
      'RecentSearch',
      place.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PlaceInfo>> getRecentSearch() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('RecentSearch');

    return List.generate(maps.length, (i) {
      return PlaceInfo(
          placeId: maps[i]['placeId'],
          description: maps[i]['description'],
          longitude: maps[i]['longitude'],
          latitude: maps[i]['latitude'],
          mainText: maps[i]['mainText']
      );
    });
  }

  deleteRecentSearch( String id ) async {
    final db = await database;
    await db.delete( 'RecentSearch', where: "placeId = ?", whereArgs: [id],);
  }

  getFavorite( String id ) async {
    final db = await database;
    var data = await db.query('favorite', where: 'placeId = ?', whereArgs: [id] );

    return data;
  }

  insertFavorite( PlaceInfo place ) async {
    final Database db = await database;

    await db.insert(
      'favorite',
      place.toMap(),
      conflictAlgorithm:  ConflictAlgorithm.replace,
    );
  }

  updateFavorite( PlaceInfo place ) async {
    final db = await database;

    await db.update( 'favorite', place.toMap(),
      where: 'placeId = ?',
      whereArgs: [place.placeId],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
}