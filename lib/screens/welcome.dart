import 'dart:async';

import 'package:daniellesdoggrooming/screens/home.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class Welcome extends StatefulWidget {
  static const String id = 'welcome';

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {


  ///////////CREATE DATABASE///////////
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

  //OWNER INFORMATION//
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



  // SQL Code to create the database table
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

  createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = p.join(databasesPath, 'database.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    return database;
  }
  ///////////CREATE DATABASE///////////




  ///////////FIRST LAUNCH SCRIPT///////////

  moveForward() {
    Navigator.pushReplacementNamed(context, Home.id);
  }

  void firstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? false;

    if (isFirstLaunch == false) {print("This Is The First Launch"); createDatabase();
    print("Database Created"); moveForward();
    } else if (isFirstLaunch == true) {print("This Is Not The First Launch"); moveForward();
    } else {}
  }
  ///////////FIRST LAUNCH SCRIPT///////////





  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      firstLaunch();
    });
  }

  @override
  Widget build(BuildContext context) {
    double appConfigWidth = MediaQuery.of(context).size.width;
    double appConfigHeight = MediaQuery.of(context).size.height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;
    double fontSize = appConfigWidth * 0.005;

    return Scaffold(
      body: Container(
        width: appConfigblockSizeWidth * 100,
        height: appConfigblockSizeHeight * 100,
        color: Color.fromRGBO(30, 30, 74, 1),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child:  Image.asset(
                'images/loading.gif',
                width: appConfigblockSizeWidth * 30,
              )
              ),
          ],
        ),
        ),
    );
  }
}
