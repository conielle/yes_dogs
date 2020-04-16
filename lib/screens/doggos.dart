import 'dart:convert';
import 'package:daniellesdoggrooming/screens/doggo_info.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:daniellesdoggrooming/screens/home.dart';
import 'package:daniellesdoggrooming/screens/appointments.dart';
import 'package:daniellesdoggrooming/screens/supplies.dart';
import 'package:daniellesdoggrooming/screens/statistics.dart';
import 'package:daniellesdoggrooming/screens/add_doggo.dart';
import 'package:daniellesdoggrooming/database/database_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Doggos extends StatefulWidget {
  static const String id = 'doggo';

  @override
  _DoggosState createState() => _DoggosState();
}

class _DoggosState extends State<Doggos> with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final dbHelper = DatabaseHelper.instance;

  var doggoStringID;
  var doggoID;
  List data;

  fetchDataCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('doggosFirstLaunch') ?? true;

    if(isFirstLaunch == true){} else {fetchDogs();}
  }

  Future<String> fetchDogs() async {
    var database = await openDatabase('database.db');
    var thing = await database.rawQuery('SELECT * FROM doggos');

    setState(() {
      var extractdata = thing;
      data = extractdata;
      return data.toList();
    });
  }



  @override
  void initState() {
    this.fetchDataCheck();
  }

  @override
  Widget build(BuildContext context) {
    double appConfigWidth = MediaQuery.of(context).size.width;
    double appConfigHeight = MediaQuery.of(context).size.height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(255, 187, 204, 1),
        child: Center(
          child: RaisedButton(
            onPressed: () {
              if (fabKey.currentState.isOpen) {
                fabKey.currentState.close();
              } else {
                fabKey.currentState.open();
              }
            },
            color: Color.fromRGBO(255, 187, 204, 1),
            child: Container(
                child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data == null ? 0 : data.length,
                    itemBuilder: (BuildContext context, i) {
                      return new ListTile(
                        onTap: () async {
                          doggoStringID = data[i]["_id"];
                          doggoID = doggoStringID.toString();
                          SharedPreferences doggoinfo =
                              await SharedPreferences.getInstance();
                          doggoinfo.setString('doggoid', '$doggoID');
                          print(doggoID);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DoggoInfo()));
                        },
                        title: new Text(data[i]["dog_name"]),
                        subtitle: new Text(data[i]["owner_name"]),
                        leading: new CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: new AssetImage(data[i]["picture"]),
                        ),
                      );
                    },
                  ),
                ),
                Container(child:

                    Column(
                      children: <Widget>[
                        SizedBox.fromSize(
                          size: Size(100, 100), // button width and height
                          child: ClipOval(
                            child: Material(
                              color: Colors.pink, // button color
                              child: InkWell(
                                splashColor: Colors.pinkAccent, // splash color
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddDoggo()));
                                }, // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[FaIcon(
                                    FontAwesomeIcons.dog,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                    SizedBox(height: appConfigblockSizeHeight * 0.5),
                                    Text("Add Doggo", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),), // text
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: appConfigblockSizeHeight * 5,)
                      ],
                    ),




                ),
              ],
            )),
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FabCircularMenu(
          key: fabKey,
          alignment: Alignment.bottomRight,
          ringColor: Color.fromRGBO(245, 66, 145, 1),
          ringDiameter: 500.0,
          ringWidth: 110.0,
          fabSize: 80.0,
          fabElevation: 8.0,
          fabColor: Color.fromRGBO(245, 66, 145, 1),
          fabOpenIcon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          fabCloseIcon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          fabMargin: const EdgeInsets.all(16.0),
          animationDuration: const Duration(milliseconds: 800),
          animationCurve: Curves.easeInOutCirc,
          children: <Widget>[
            RawMaterialButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.home, color: Colors.white)),
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Statistics()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: IconButton(
                  icon: FaIcon(
                FontAwesomeIcons.sortNumericDownAlt,
                color: Colors.white,
              )),
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Supplies()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: IconButton(
                  icon: FaIcon(
                FontAwesomeIcons.flask,
                color: Colors.white,
              )),
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Appointments()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: IconButton(
                  icon: FaIcon(
                FontAwesomeIcons.clipboardList,
                color: Colors.white,
              )),
            ),
            RawMaterialButton(
              onPressed: () {
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: IconButton(
                  icon: FaIcon(
                FontAwesomeIcons.dog,
                color: Colors.white12,
              )),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    ));
  }

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnDogName: 'Name',
      DatabaseHelper.columnPicture: 'images/doggo.png',
      DatabaseHelper.columnAge: 23
    };
    final id = await dbHelper.insertDoggos(row);
    print('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void _create() async {}


  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await dbHelper.updateDoggos(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
