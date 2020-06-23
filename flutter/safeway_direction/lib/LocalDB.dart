import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBase {
  var database;

  void databaseInit() async {
    var datapath = await getDatabasesPath();
    print(datapath);
    database = openDatabase(
      // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
      // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
      join(await getDatabasesPath(), 'place_database.db'),
      // 데이터베이스가 처음 생성될 때, dog를 저장하기 위한 테이블을 생성합니다.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE RecentSearch(placeId TEXT PRIMARY KEY, description TEXT, longitude DOUBLE,latitude DOUBLE)",
        );
      },
      // 버전을 설정하세요. onCreate 함수에서 수행되며 데이터베이스 업그레이드와 다운그레이드를
      // 수행하기 위한 경로를 제공합니다.
      version: 1,
    );
  }

  Future<void> insertRecentSearch(String des,String id,double Lat,double lon) async {
    // 데이터베이스 reference를 얻습니다.
    final Database db = await database;
    //String Description = place.description;
    //String placeId = place.placeId;
    //var geolocation = await place.geolocation;
    //var Lat = geolocation.coordinates.latitude;
    //var lon = geolocation.coordinates.longtitude;
    // Dog를 올바른 테이블에 추가하세요. 또한
    // `conflictAlgorithm`을 명시할 것입니다. 본 예제에서는
    // 만약 동일한 dog가 여러번 추가되면, 이전 데이터를 덮어쓸 것입니다.
    DbPlace place = DbPlace(description: des,latitude: Lat,longitude: lon,placeId: id);
    await db.insert(
      'RecentSearch',
      place.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Map<String, dynamic> toMap(
      String Description, String placeId, double lat, double lon) {
    return {
      'placeId': placeId,
      'description': Description,
      'longitude': lon,
      'latitude': lat,
    };
  }

  Future<List<DbPlace>> GetRecentSearch() async {
    // 데이터베이스 reference를 얻습니다.
    final Database db = await database;

    // 모든 Dog를 얻기 위해 테이블에 질의합니다.
    final List<Map<String, dynamic>> maps = await db.query('RecentSearch');

    // List<Map<String, dynamic>를 List<Dog>으로 변환합니다.
    return List.generate(maps.length, (i) {
      return DbPlace(
          placeId: maps[i]['placeId'],
          description: maps[i]['description'],
          longitude: maps[i]['longitude'],
          latitude: maps[i]['latitude']);
    });
  }

  Future<void> deleteREcentSearch(int id) async {
    // 데이터베이스 reference를 얻습니다.
    final db = await database;

    // 데이터베이스에서 Dog를 삭제합니다.
    await db.delete(
      'RecentSearch',
      // 특정 dog를 제거하기 위해 `where` 절을 사용하세요
      where: "placeId = ?",
      // Dog의 id를 where의 인자로 넘겨 SQL injection을 방지합니다.
      whereArgs: [id],
    );
  }

}

class DbPlace {
  final String placeId;
  final String description;
  final double longitude;
  final double latitude;
  DbPlace({this.placeId, this.description, this.longitude, this.latitude});
  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'description': description,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}
