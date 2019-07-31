/*import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sky_forecast/Models/location_database_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  final String table = "savedLocations";
  final String columnId = "id";
  final String columnName = "name";
  final String columnLocId = "locId";
  final String columnFreg = "freq";

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), "savedLocations.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $table("
            "$columnId INTEGER PRIMARY KEY, "
            "$columnName TEXT, "
            "$columnFreg INTEGER)");
  }
  /*void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute(
        "CREATE TABLE $table("
            "$columnId INTEGER PRIMARY KEY, "
            "$columnName TEXT, "
            "$columnLocId INTEGER)");
  }*/

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
        locId: maps[i]["locId"],
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
        columns: [columnId, columnName, columnLocId],
        where: "$columnLocId = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return Location(
          id: maps[i]["id"],
          name: maps[i]["name"],
          locId: maps[i]["locId"],
        );
      });
    }

    return null;
  }

  Future<bool> searchLocation(int id) async{
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(table,
        columns: [columnId, columnName, columnLocId],
        where: "$columnLocId = ?",
        whereArgs: [id]);
    if(maps.length > 0)
      return true;
    return false;
  }

  Future<void> updateLocation(Location location) async {
    var dbClient = await db;

    // Update the given Dog.
    await dbClient.update(table, location.toMap(),
      // Ensure that the Location has a matching id.
      where: "$columnLocId = ?",
      // Pass the Location's id as a whereArg to prevent SQL injection.
      whereArgs: [location.id],
    );
  }

  Future<void> deleteLocation(int id) async {
    var dbClient = await db;
    // Remove the location from the database.
    await dbClient.delete(table,
      // Use a `where` clause to delete a specific location.
      where: "$columnLocId = ?",
      // Pass the locations's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }


  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:sky_forecast/Models/location_database_model.dart';

class DatabaseProvider {
  static final _instance = DatabaseProvider._internal();
  static DatabaseProvider get = _instance;
  bool isInitialized = false;
  Database _db;
  final String table = "savedLocations";
  final String columnId = "id";
  final String columnName = "name";
  final String columnLocId = "locId";
  final String columnFreg = "freq";

  DatabaseProvider._internal();

  Future<Database> db() async {
    if (!isInitialized) await _init();
    return _db;
  }

  Future _init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "savedLocations.db");

    _db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE $table("
                  "$columnId INTEGER PRIMARY KEY, "
                  "$columnName TEXT, "
                  "$columnLocId INTEGER)");
        });
  }
  Future<void> saveLocation(Location location) async {
    final dbClient = await _instance.db();
    await dbClient.insert(table, location.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List> getAllLocations() async {
    var dbClient = await _instance.db();

    //Query the table for all Locations.
    final List<Map<String, dynamic>> maps = await dbClient.query(table);

    // Convert the List<Map<String, dynamic> into a List<Location>.
    return List.generate(maps.length, (i) {
      return Location(
        id: maps[i]["id"],
        name: maps[i]["name"],
        locId: maps[i]["locId"],
      );
    });
  }

  Future<int> getCount() async {
    var dbClient = await _instance.db();
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $table"));
  }

  Future<List> getLocation(int id) async {
    var dbClient = await _instance.db();
    final List<Map<String, dynamic>> maps = await dbClient.query(table,
        columns: [columnId, columnName, columnLocId],
        where: "$columnLocId = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return Location(
          id: maps[i]["id"],
          name: maps[i]["name"],
          locId: maps[i]["locId"],
        );
      });
    }

    return null;
  }

  Future<bool> searchLocation(int id) async{
    var dbClient = await _instance.db();
    final List<Map<String, dynamic>> maps = await dbClient.query(table,
        columns: [columnId, columnName, columnLocId],
        where: "$columnLocId = ?",
        whereArgs: [id]);
    if(maps.length > 0)
      return true;
    return false;
  }

  Future<void> updateLocation(Location location) async {
    var dbClient = await _instance.db();

    // Update the given Dog.
    await dbClient.update(table, location.toMap(),
      // Ensure that the Location has a matching id.
      where: "$columnLocId = ?",
      // Pass the Location's id as a whereArg to prevent SQL injection.
      whereArgs: [location.id],
    );
  }

  Future<void> deleteLocation(int id) async {
    var dbClient = await _instance.db();
    // Remove the location from the database.
    await dbClient.delete(table,
      // Use a `where` clause to delete a specific location.
      where: "$columnLocId = ?",
      // Pass the locations's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }


  Future close() async {
    var dbClient = await _instance.db();
    return dbClient.close();
  }
}*/

import 'dart:io';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/location_database_model.dart';
import '../Models/location_search_model.dart';

class DatabaseHelper {

  static final _databaseName = "try3.db";
  static final _databaseVersion = 4;

  final String table = "tblet";
  final String columnId = "id";
  final String columnName = "name";
  final String columnLocId = "locId";

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database1;
  Future<Database> get database async {
    if (_database1 != null) return _database1;
    // lazily instantiate the db the first time it is accessed
    _database1 = await _initDatabase();
    return _database1;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $table ("
          "$columnId INTEGER PRIMARY KEY,"
          "$columnName TEXT,"
          "$columnLocId INTEGER"
          ")");
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> saveLocation(Location location) async {
    Database dbClient = await instance.database;
    return await dbClient.insert(table, location.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<int> savePlace(Places place) async {
    Database dbClient = await instance.database;
    return await dbClient.insert(table, place.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Location>> getAllLocations() async {
    Database dbClient = await instance.database;
    var response = await dbClient.query(table);
    List<Location> list = response.map((c) => Location.fromMap(c)).toList();
    return list;
  }

  //get certain location entry and return entry
  Future<List> getLocation(int id) async {
    Database dbClient = await instance.database;
    final List<Map<String, dynamic>> maps = await dbClient.query(table,
        columns: [columnId, columnName, columnLocId],
        where: "$columnLocId = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return Location(
          id: maps[i]["id"],
          name: maps[i]["name"],
        );
      });
    }
    return null;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> getCount() async {
    Database dbClient = await instance.database;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $table"));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnLocId = ?', whereArgs: [id]);
  }
  Future<int> updateLocation(Location location) async {
    Database dbClient = await instance.database;

    // Update the given Dog.
    return await dbClient.update(table, location.toMap(),
      // Ensure that the Location has a matching id.
      where: "$columnLocId = ?",
      // Pass the Location's id as a whereArg to prevent SQL injection.
      whereArgs: [location.id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int > deleteLocation(int id) async {
    Database dbClient = await instance.database;

    // Remove the location from the database.
    return await dbClient.delete(table,
      // Use a `where` clause to delete a specific location.
      where: "$columnId = ?",
      // Pass the locations's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
  Future<int > deletePlace(int id) async {
    Database dbClient = await instance.database;

    // Remove the location from the database.
    return await dbClient.delete(table,
      // Use a `where` clause to delete a specific location.
      where: "$columnLocId = ?",
      // Pass the locations's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }


  //look in database for locationId. if found, tell user
  Future<bool> searchLocation(int id) async{
    Database dbClient = await instance.database;
    final List<Map<String, dynamic>> maps = await dbClient.query(table,
        columns: [columnId, columnName, columnLocId],
        where: "$columnLocId = ?",
        whereArgs: [id]);
    if(maps.length > 0)
      return true;
    return false;
  }
}