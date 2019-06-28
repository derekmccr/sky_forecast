import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'location_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

//TODO: add, update, delete entry in database
//database is used within user storage to house saved locations
//these locations used to populate list on homepage

class DbProvider {
  DbProvider._();

  static final DbProvider db = DbProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "locations.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Locations ("
              "id INTEGER PRIMARY KEY,"
              "Name TEXT,"
              "Frequency INTEGER"
              ")");
        });
  }
}