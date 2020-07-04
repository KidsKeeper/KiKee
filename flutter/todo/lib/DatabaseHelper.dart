import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/Todo.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static const databaseName = "todo_databases.db";
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if( _database == null ) return await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute( "CREATE TABLE todo (id INTEGER PRIMARY KEY NOT NULL, title TEXT, content TEXT)" );
    });
  }

  insertTodo( Todo todo ) async {
    final Database db = await database;

    var result = await db.insert(
      Todo.TABLENAME,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );

    return result;
  }

  deleteTodo( int id ) async {
    final Database db = await database;
    db.delete( Todo.TABLENAME, where: 'id = ?', whereArgs: [id] );
  }

  Future<List<Todo>> getAllTodo() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(Todo.TABLENAME);

    return List.generate( maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
      );
    });
  }

  getTodo( int id ) async {
    // Todo todo;
    // var snapshot = await DatabaseHelper.instance.collection('todo').document(id).
    final Database db = await database;

    var result = await db.query( Todo.TABLENAME, where: 'id = ?', whereArgs: [id] );

    return result;
  }

  updateTodo( Todo todo ) async {
    final Database db = await database;

    await db.update( Todo.TABLENAME, todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
}