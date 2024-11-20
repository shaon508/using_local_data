import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//
//Making of local database for cache data
//
class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  late Database _database;

  LocalStorage._internal();

  factory LocalStorage() => _instance;

  Future<void> init() async {
    final path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'offline_data.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE posts(id INTEGER PRIMARY KEY, title TEXT, body TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertData(List<dynamic> data) async {
    await _database.delete("posts");
    for (var item in data) {
      await _database.insert(
        "posts",
        {
          "id": item["id"],
          "title": item["title"],
          "body": item["body"],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchCachedData() async {
    return await _database.query("posts");
  }
}
