import 'dart:io';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/location_database_model.dart';
import '../Models/location_search_model.dart';

class DatabaseHelper {

  static final _databaseName = "localLocationsDatabase.db";
  static final _databaseVersion = 1;

  final String table = "savedLocations";
  final String columnId = "id";
  final String columnName = "name";
  final String columnLocId = "locId";

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _localDatabase;
  Future<Database> get database async {
    if (_localDatabase != null) return _localDatabase;
    // lazily instantiate the db the first time it is accessed
    _localDatabase = await _initDatabase();
    return _localDatabase;
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