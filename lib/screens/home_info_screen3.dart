import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'dart:math';
import 'dart:convert';
import 'package:daniellesdoggrooming/screens/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daniellesdoggrooming/database/database_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:daniellesdoggrooming/screens/home_info_screen1.dart';
import 'package:daniellesdoggrooming/screens/home_info_screen2.dart';

class random {
  static final Random _random = Random.secure();

  static String Number([int length = 6]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }
}

class HomeInfo3 extends StatefulWidget {
  static const String id = 'homeinfo3';

  @override
  _HomeInfo3State createState() => _HomeInfo3State();
}

class _HomeInfo3State extends State<HomeInfo3> with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final dbHelper = DatabaseHelper.instance;

  var ID = 0;
  int indexID;
  var dogUniqueID;
  List data;

  final addTemperament = TextEditingController();
  final addOwnerNotes = TextEditingController();
  final addMedicalNotes = TextEditingController();
  final addMyOwnNotes = TextEditingController();

  @override
  fetchUniqueID() async {
    SharedPreferences doginfo = await SharedPreferences.getInstance();
    dogUniqueID = doginfo.getString('doguniqueid') ?? '';

    print(dogUniqueID);
  }

  fetchID() async {
    // get a reference to the database
    Database db = await DatabaseHelper.instance.database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseHelper.columnId,
      DatabaseHelper.columnDogName,
      DatabaseHelper.columnDogUniqueId,
      DatabaseHelper.columnBreed,
      DatabaseHelper.columnFixed,
      DatabaseHelper.columnSex,
      DatabaseHelper.columnScheduleDate,
      DatabaseHelper.columnScheduleTime,
      DatabaseHelper.columnAge,
      DatabaseHelper.columnPicture,
      DatabaseHelper.columnOwnerName,
      DatabaseHelper.columnOwnerID,
      DatabaseHelper.columnPhone,
      DatabaseHelper.columnEmail,
      DatabaseHelper.columnAddress,
      DatabaseHelper.columnVet,
      DatabaseHelper.columnMyNotes,
      DatabaseHelper.columnOwnerNotes,
      DatabaseHelper.columnMedicalNotes,
      DatabaseHelper.columnTemperament,
      DatabaseHelper.columnGrooming,
      DatabaseHelper.columnTraining,
    ];
    String whereString =
        '${DatabaseHelper.columnDogUniqueId} = "${dogUniqueID}"';
    int rowId = 2;
    List<dynamic> whereArguments = [rowId];
    List<Map> result = await db.query(DatabaseHelper.table,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);

    print(result);

    indexID = result[0]['_id'];
    print('This is the $indexID number');

    setState(() {
      var extractdata = result;
      data = extractdata;
      print(data);
      return data.toList();
    });

    print("Database Query");
  }

  @override
  void initState() {
    fetchUniqueID();
    fetchID();
  }

  @override
  Widget build(BuildContext context) {
    double appConfigWidth = MediaQuery.of(context).size.width;
    double appConfigHeight = MediaQuery.of(context).size.height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;
    double fontSize = appConfigWidth * 0.005;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(34, 36, 86, 1),
        title: Text(
          'About This Doggo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () => Navigator.pushNamed(context, Home.id),
          ),
        ],
        leading: new Container(),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(top: 0),
            height: appConfigblockSizeHeight * 180,
            color: Color.fromRGBO(171, 177, 177, 1),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft:
                              Radius.circular(appConfigblockSizeWidth * 4)),
                      color: Color.fromRGBO(81, 87, 87, 1),
                    ),
                    child: FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        bottomLeft:
                            Radius.circular(appConfigblockSizeHeight * 2),
                      )),
                      color: Color.fromRGBO(81, 87, 87, 1),
                      textColor: Color.fromRGBO(34, 36, 86, 1),
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeInfo1()));
                      },
                      child: Container(
                        width: appConfigblockSizeWidth * 33.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Overview",
                              style: TextStyle(
                                fontSize: fontSize * 7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(81, 87, 87, 1),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft:
                              Radius.circular(appConfigblockSizeHeight * 2),
                        ),
                        color: Color.fromRGBO(101, 107, 107, 1),
                      ),
                      child: FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft:
                              Radius.circular(appConfigblockSizeHeight * 2),
                        )),
                        color: Color.fromRGBO(101, 107, 107, 1),
                        textColor: Color.fromRGBO(34, 36, 86, 1),
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeInfo2()));
                        },
                        child: Container(
                          width: appConfigblockSizeWidth * 33.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Owner",
                                style: TextStyle(
                                  fontSize: fontSize * 7,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(101, 107, 107, 1),
                        borderRadius: BorderRadius.only(
                            bottomRight:
                                Radius.circular(appConfigblockSizeWidth * 4))),
                    padding: EdgeInsets.all(0),
                    child: FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight:
                              Radius.circular(appConfigblockSizeHeight * 2),
                          bottomLeft:
                              Radius.circular(appConfigblockSizeHeight * 2),
                        ),
                      ),
                      color: Color.fromRGBO(131, 137, 137, 1),
                      textColor: Color.fromRGBO(34, 36, 86, 1),
                      padding: EdgeInsets.all(0),
                      onPressed: () {},
                      child: Container(
                        width: appConfigblockSizeWidth * 33.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Notes",
                              style: TextStyle(
                                fontSize: fontSize * 7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: appConfigblockSizeHeight * 1.5),
              Container(
                height: appConfigblockSizeHeight * 150,
                width: appConfigblockSizeWidth * 80,
                child: Column(
                  children: [
                    Text(
                      'Tap on the body of the note to change it.',
                      style: TextStyle(
                        color: Color.fromRGBO(34, 36, 86, 1),
                        fontSize: fontSize * 6,
                      ),
                    ),
                    SizedBox(height: appConfigblockSizeHeight * 1.5),
                    Column(
                      children: [
                        Text(
                          'Temperament',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color.fromRGBO(34, 36, 86, 1),
                            fontSize: fontSize * 12,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            _addTemperament();
                          },
                          child: Container(
                            child: Text(
                              data[ID]['temperament'],
                              style: TextStyle(
                                color: Color.fromRGBO(34, 36, 86, 1),
                                fontSize: fontSize * 8,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 4,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Medical Notes',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color.fromRGBO(34, 36, 86, 1),
                            fontSize: fontSize * 12,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            _addMedicalNotes();
                          },
                          child: Container(
                            child: Text(
                              data[ID]['medicalnotes'],
                              style: TextStyle(
                                color: Color.fromRGBO(34, 36, 86, 1),
                                fontSize: fontSize * 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: appConfigblockSizeHeight * 4,
                    ),
                    Column(
                      children: [
                        Text(
                          'Owner\'s Notes',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color.fromRGBO(34, 36, 86, 1),
                            fontSize: fontSize * 12,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            _addOwnerNotes();
                          },
                          child: Container(
                            child: Text(
                              data[ID]['ownernotes'],
                              style: TextStyle(
                                color: Color.fromRGBO(34, 36, 86, 1),
                                fontSize: fontSize * 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: appConfigblockSizeHeight * 4,
                    ),
                    Column(
                      children: [
                        Text(
                          'My Own Notes',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color.fromRGBO(34, 36, 86, 1),
                            fontSize: fontSize * 12,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            _addMyOwnNotes();
                          },
                          child: Container(
                            child: Text(
                              data[ID]['mynotes'],
                              style: TextStyle(
                                color: Color.fromRGBO(34, 36, 86, 1),
                                fontSize: fontSize * 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: appConfigblockSizeHeight * 4,
                    ),
                  ],
                ),
              )
            ])),
      ),
    );
  }

  //TEXT CHECKERS

  isThereATemperament() {
    String temperamentValue;
    if (addTemperament.text == null) {
      temperamentValue = 'No Recorded Temperament Details for Doggo';
    } else if (addTemperament.text == "") {
      temperamentValue = data[0]['temperament'];
    } else {
      temperamentValue = addTemperament.text;
    }
    return temperamentValue;
  }

  isThereAMedicalNote() {
    String medicalValue;
    if (addMedicalNotes.text == null) {
      medicalValue = 'No Recorded Medical Notes for Doggo';
    } else if (addMedicalNotes.text == '') {
      medicalValue = data[0]['medicalnotes'];
    } else {
      medicalValue = addMedicalNotes.text;
    }
    return medicalValue;
  }

  isThereAnOwnerNote() {
    String ownerValue;
    if (addOwnerNotes.text == null) {
      ownerValue = 'No Recorded Owner\'s Notes For Doggo';
    } else if (addOwnerNotes.text == "") {
      ownerValue = data[0]['ownernotes'];
    } else {
      ownerValue = addOwnerNotes.text;
    }
    return ownerValue;
  }

  isThereAMyOwnNote() {
    String myNotes;
    if (addMyOwnNotes.text == null) {
      myNotes = 'My Notes Are Ewmpty, For Now';
    } else if (addMyOwnNotes.text == '') {
      myNotes = 'My Notes Are empty, For Now';
    } else {
      myNotes = addMyOwnNotes.text;
    }
    return myNotes;
  }

  //POPUP INPUTS

  void _addTemperament() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text(
            "How's the Temperament?",
            style: TextStyle(
              color: Color.fromRGBO(34, 36, 86, 1),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                maxLines: 14,
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Add a note about the doggo\'s temperament',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(34, 36, 86, 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(34, 36, 86, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(34, 36, 86, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                ),
                textAlign: TextAlign.center,
                controller: addTemperament,
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              textColor: Colors.black45,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            new FlatButton(
              child: new Text("Save"),
              textColor: Colors.black45,
              onPressed: () {
                _updateTemperament();
                Navigator.of(context).pushReplacementNamed(HomeInfo3.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _addMedicalNotes() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text(
            "Any Medical Notes?",
            style: TextStyle(
              color: Color.fromRGBO(34, 36, 86, 1),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                maxLines: 14,
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Add some medical notes about the doggo.',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(34, 36, 86, 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(34, 36, 86, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(34, 36, 86, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                ),
                textAlign: TextAlign.center,
                controller: addMedicalNotes,
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              textColor: Colors.black45,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            new FlatButton(
              child: new Text("Save"),
              textColor: Colors.black45,
              onPressed: () {
                _updateMedicalNotes();
                Navigator.of(context).pushReplacementNamed(HomeInfo3.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _addOwnerNotes() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text(
            "Any Owners Notes?",
            style: TextStyle(
              color: Color.fromRGBO(34, 36, 86, 1),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                maxLines: 14,
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Add some notes from the owner about the doggo.',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(34, 36, 86, 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(34, 36, 86, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(34, 36, 86, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                ),
                textAlign: TextAlign.center,
                controller: addOwnerNotes,
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              textColor: Colors.black45,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            new FlatButton(
              child: new Text("Save"),
              textColor: Colors.black45,
              onPressed: () {
                _updateOwnerNotes();
                Navigator.of(context).pushReplacementNamed(HomeInfo3.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _addMyOwnNotes() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text(
            "Add Your Own Notes?",
            style: TextStyle(
              color: Color.fromRGBO(34, 36, 86, 1),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                maxLines: 14,
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Add a few notes about the doggo.',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(34, 36, 86, 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(34, 36, 86, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(34, 36, 86, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                ),
                textAlign: TextAlign.center,
                controller: addMyOwnNotes,
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              textColor: Colors.black45,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            new FlatButton(
              child: new Text("Save"),
              textColor: Colors.black45,
              onPressed: () {
                _updateMyOwnNotes();
                Navigator.of(context).pushReplacementNamed(HomeInfo3.id);
              },
            ),
          ],
        );
      },
    );
  }

  //DATABASE

  void _updateTemperament() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnTemperament: isThereATemperament()
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _updateMedicalNotes() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnMedicalNotes: isThereAMedicalNote(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _updateOwnerNotes() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnOwnerNotes: isThereAnOwnerNote(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _updateMyOwnNotes() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnMyNotes: isThereAMyOwnNote(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }
}
