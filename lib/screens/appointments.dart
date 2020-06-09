import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

import 'package:daniellesdoggrooming/screens/home.dart';
import 'package:daniellesdoggrooming/screens/doggos.dart';
import 'package:daniellesdoggrooming/screens/supplies.dart';
import 'package:daniellesdoggrooming/screens/statistics.dart';
import 'package:daniellesdoggrooming/screens/appointment_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daniellesdoggrooming/database/database_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Appointments extends StatefulWidget {
  static const String id = 'appointments';

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments>
    with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final dbHelper = DatabaseHelper.instance;

  var doggoStringID;
  var doggoID;
  var data;


  fetchDataCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('doggosFirstLaunch') ?? true;

    if (isFirstLaunch == true) {
    } else {
      fetchDogs();
    }
  }

  var extractdata;
  var sort;
  var theresult;
  var value;


  fetchDogs() async {
    var database = await openDatabase('database.db');
    var thing = await database.rawQuery('SELECT * FROM doggos');

    setState(() {
      extractdata = thing;
      sort = extractdata;
      data = sort;
     print(data);
    });
  }

  @override
  void initState() {
    fetchDataCheck();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    double appConfigWidth = MediaQuery.of(context).size.width;
    double appConfigHeight = MediaQuery.of(context).size.height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(34, 36, 86, 1),
        title: Text(
          'Schedule',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(171, 177, 177, 1),
        child: Center(
          child: RaisedButton(
            onPressed: () {
              if (fabKey.currentState.isOpen) {
                fabKey.currentState.close();
              } else {
                fabKey.currentState.open();
              }
            },
            color: Color.fromRGBO(171, 177, 177, 1),
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
                                  builder: (context) => AppointmentInfo()));
                        },
                        title: new Text(data[i]["owner_name"]),
                        subtitle: new Text(data[i]["date"]),
                        leading: new CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: new AssetImage(data[i]["picture"]),
                        ),
                        trailing: new Text(data[i]["time"]),
                      );
                    },
                  ),
                ),
                Container(),
              ],
            )),
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FabCircularMenu(
          key: fabKey,
          alignment: Alignment.bottomRight,
          ringColor: Color.fromRGBO(34, 36, 86, 1),
          ringDiameter: 500.0,
          ringWidth: 110.0,
          fabSize: 80.0,
          fabElevation: 8.0,
          fabColor: Color.fromRGBO(34, 36, 86, 1),
          fabOpenIcon: Icon(Icons.menu, color: Colors.white),
          fabCloseIcon: Icon(Icons.close, color: Colors.white),
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
                  icon: FaIcon(
                FontAwesomeIcons.home,
                color: Colors.white,
              )),
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
              onPressed: () {},
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: IconButton(
                  icon: FaIcon(
                FontAwesomeIcons.clipboardList,
                color: Colors.white10,
              )),
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Doggos()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: IconButton(
                  icon: FaIcon(
                FontAwesomeIcons.dog,
                color: Colors.white,
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
}
