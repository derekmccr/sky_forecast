import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'location_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  final String table = "Locations";
  final String columnId = "id";
  final String columnName = "name";
  final String columnFreq = "freq";

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), "locations.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $table("
            "$columnId INTEGER PRIMARY KEY, "
            "$columnName TEXT, "
            "$columnFreq INTEGER)");
  }

  Future<void> saveLocation(Location location) async {
    var dbClient = await db;
    await dbClient.insert(table, location.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List> getAllLocations() async {
    var dbClient = await db;

    //Query the table for all Locations.
    final List<Map<String, dynamic>> maps = await dbClient.query(table);

    // Convert the List<Map<String, dynamic> into a List<Location>.
    return List.generate(maps.length, (i) {
      return Location(
        id: maps[i]["id"],
        name: maps[i]["name"],
        freq: maps[i]["freq"],
      );
    });
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $table"));
  }

  Future<List> getLocation(int id) async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(table,
        columns: [columnId, columnName, columnFreq],
        where: "$columnId = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return Location(
          id: maps[i]["id"],
          name: maps[i]["name"],
          freq: maps[i]["freq"],
        );
      });
    }

    return null;
  }

  Future<void> updateLocation(Location location) async {
    var dbClient = await db;

    // Update the given Dog.
    await dbClient.update(table, location.toMap(),
      // Ensure that the Location has a matching id.
      where: "id = ?",
      // Pass the Location's id as a whereArg to prevent SQL injection.
      whereArgs: [location.id],
    );
  }

  Future<void> deleteNote(int id) async {
    var dbClient = await db;
    // Remove the location from the database.
    await dbClient.delete(table,
      // Use a `where` clause to delete a specific location.
      where: "id = ?",
      // Pass the locations's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }


  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}