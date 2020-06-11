import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "database.db";
  static final _databaseVersion = 1;


  //DOG TABLE//
  static final table = 'doggos';
  static final columnId = '_id';

  //DOG INFORMATION//
  static final columnDogUniqueId = 'uniqueID';
  static final columnDogName = 'dog_name';
  static final columnBreed = 'breed';
  static final columnFixed = 'fixed';
  static final columnSex = 'sex';
  static final columnScheduleDate = 'date';
  static final columnScheduleTime = 'time';
  static final columnAge = 'age';
  static final columnPicture = 'picture';
  static final columnMyNotes = 'mynotes';
  static final columnTemperament = 'temperament';
  static final columnOwnerNotes = 'ownernotes';
  static final columnMedicalNotes = 'medicalnotes';
  static final columnOwnerName = 'owner_name';
  static final columnOwnerID = 'idnumber';
  static final columnAddress = 'address';
  static final columnPhone = 'phone';
  static final columnEmail = 'email';
  static final columnVet = 'vet';
  static final columnTraining = 'training';
  static final columnGrooming = 'grooming';


  //SUPPLIES TABLE//
  static final table2 = 'supplies';
  static final columnSupplyUniqueId = 'uniqueID';
  static final columnType = 'supply_type';
  static final columnBrand = 'brand_name';
  static final columnLevel = 'level';
  static final columnPicture2 = 'picture';


  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
                  CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnDogUniqueId TEXT NOT NULL,
            $columnDogName TEXT NOT NULL,
            $columnBreed TEXT NOT NULL,
            $columnFixed TEXT NOT NULL,
            $columnSex TEXT NOT NULL,
            $columnScheduleDate TEXT NOT NULL,
            $columnScheduleTime TEXT NOT NULL,
            $columnAge TEXT NOT NULL,
            $columnPicture TEXT NOT NULL,
            $columnMyNotes TEXT NOT NULL,
            $columnTemperament TEXT NOT NULL,
            $columnOwnerNotes TEXT NOT NULL,
            $columnMedicalNotes TEXT NOT NULL,
            $columnOwnerName TEXT NOT NULL,
            $columnOwnerID TEXT NOT NULL,
            $columnAddress TEXT NOT NULL,
            $columnPhone TEXT NOT NULL,
            $columnEmail TEXT NOT NULL,
            $columnTraining TEXT NOT NULL,
            $columnGrooming TEXT NOT NULL,
            $columnVet TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $table2 (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnSupplyUniqueId TEXT NOT NULL,
            $columnType TEXT NOT NULL,
            $columnBrand TEXT NOT NULL,
            $columnLevel TEXT NOT NULL,
            $columnPicture2 TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertDoggos(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> insertSupplies(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table2, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateDoggos(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateSupplies(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table2, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteDoggos(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteSupplies(int id) async {
    Database db = await instance.database;
    return await db.delete(table2, where: '$columnId = ?', whereArgs: [id]);
  }

}