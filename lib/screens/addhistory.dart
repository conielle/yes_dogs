import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:intl/intl.dart';
import 'package:daniellesdoggrooming/database/database_logic.dart';
import 'package:daniellesdoggrooming/screens/appointments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/cupertino.dart';
import 'doggo_info.dart';
import 'appointment_info.dart';
import 'dart:math';


class AddHistory extends StatefulWidget {
  static const String id = 'addhistory';

  @override
  _AddHistoryState createState() => _AddHistoryState();
}

class _AddHistoryState extends State<AddHistory>
    with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final dbHelper = DatabaseHelper.instance;

  var ID = 0;
  int indexID;
  var dogUniqueID;
  var doggoID;
  List data;

  String finalDate;
  String finalTime;

  var previewImage = Image(image: AssetImage('images/doggo.png'));

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  DateTime _setDate = DateTime.now();
  Duration initialtimer = new Duration();
  int selectitem = 1;
  var scheduledata;

  bool nails = false;
  bool wash = false;
  bool cut = false;
  bool other = false;





  Widget datetime() {
    return CupertinoDatePicker(
      initialDateTime: DateTime.now(),
      onDateTimeChanged: (DateTime newdate) {
        var date = newdate;
        var formatter = new DateFormat('yyyy-MM-dd');
        String formatted = formatter.format(date);
        finalDate = formatted;
        dbDate = formatted;
        print(formatted);
        setState(() {
        return dbDate;});
      },
      use24hFormat: true,
      maximumDate: new DateTime(2100, 12, 30),
      minimumYear: 2020,
      maximumYear: 2100,
      minuteInterval: 1,
      mode: CupertinoDatePickerMode.date,


    );



  }
  String dbDate;
  String dbTime;
  Widget time() {
    var time;
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      initialDateTime: DateTime.now(),
      use24hFormat: true,
      onDateTimeChanged: (DateTime newDateTime) {
        //setState(() => time = newDateTime);
        time =
        new TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
        print(time);

        setState(() {
          selectedTime = time;
          final MaterialLocalizations localizations =
          MaterialLocalizations.of(context);
          final String formattedTime =
          localizations.formatTimeOfDay(selectedTime);
          finalTime = formattedTime.toString();
          dbTime = finalTime;
          print(finalTime);
          return dbTime;
        });
      },
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var stringDate = selectedDate.toString();

        var date = selectedDate;
        var formatter = new DateFormat('yyyy-MM-dd');
        String formatted = formatter.format(date);
        finalDate = formatted;
        print(formatted);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
    await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
        final String formattedTime =
        localizations.formatTimeOfDay(selectedTime);
        finalTime = formattedTime.toString();
      });
    }
  }

  fetchUniqueID() async {
    SharedPreferences doginfo = await SharedPreferences.getInstance();
    dogUniqueID = doginfo.getString('doguniqueid') ?? '';

    print(dogUniqueID);
    fetchSchedules();
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

  Future<String> fetchSchedules() async {
    var database = await openDatabase('database.db');
    List<Map<String, dynamic>> records = await database.query('$dogUniqueID');
    Map<String, dynamic> mapRead = records.first;
//    mapRead['my_column'] = 1;
    Map<String, dynamic> map = Map<String, dynamic>.from(mapRead);

    var newlist = records.toList();

    var hello = newlist
      ..sort((a, b) => a["date"].toString().compareTo(b["date"].toString()));

    scheduledata = hello;
    print(scheduledata);

    setState(() {
      scheduledata;
    });
  }

  @override
  void initState() {
    fetchUniqueID();
    fetchID();
  }

  @override
  Widget build(BuildContext context) {
    double appConfigWidth = MediaQuery
        .of(context)
        .size
        .width;
    double appConfigHeight = MediaQuery
        .of(context)
        .size
        .height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;
    double fontSize = appConfigWidth * 0.005;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(34, 36, 86, 1),
        title: Text(
          'Add History',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () =>  Navigator.pop(context),
          ),
        ],
        leading: new Container(),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: appConfigblockSizeHeight * 100,
          color: Color.fromRGBO(171, 177, 177, 1),
          child: Center(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 50.0, left: 50.0, top: 20, bottom: 20),
                child: Container(
                  child: Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            dogUniqueID = data[ID]["uniqueID"];
                            SharedPreferences doginfo =
                            await SharedPreferences.getInstance();
                            doginfo.setString('doguniqueid', '$dogUniqueID');

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DoggoInfo()));
                          },
                          child: Container(
                            width: appConfigblockSizeWidth * 90,
                            padding:
                            EdgeInsets.all(appConfigblockSizeWidth * 2),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                              color: Color.fromRGBO(156, 156, 156, 1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(appConfigblockSizeWidth * 4)),
                            ),
                            child: SingleChildScrollView(
                              child: Row(
                                children: [
                                  //PICTURE
                                  Container(
                                    child: previewImage == null
                                        ? CircleAvatar(
                                      backgroundImage:
                                      AssetImage(data[ID]['picture']),
                                      backgroundColor: Colors.transparent,
                                      radius:
                                      appConfigblockSizeWidth * 10,
                                    )
                                        : CircleAvatar(
                                      backgroundImage:
                                      AssetImage(data[ID]["picture"]),
                                      backgroundColor: Colors.transparent,
                                      radius:
                                      appConfigblockSizeWidth * 10,
                                    ),
                                  ),
                                  SizedBox(
                                    width: appConfigblockSizeWidth * 4,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //DOG NAME
                                      Container(
                                        child: Text(
                                          data[ID]["dog_name"],
                                          style: TextStyle(
                                              color:
                                              Color.fromRGBO(34, 36, 86, 1),
                                              fontWeight: FontWeight.w900,
                                              fontSize: fontSize * 8),
                                        ),
                                      ),

                                      //AGE
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              (data[ID]["age"]).toString(),
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    34, 36, 86, 1),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              ' years old, ',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    34, 36, 86, 1),
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              ', ',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    34, 36, 86, 1),
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              (data[ID]["sex"]).toString(),
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    34, 36, 86, 1),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Text(
                                        (data[ID]["breed"]).toString(),
                                        style: TextStyle(
                                          color: Color.fromRGBO(34, 36, 86, 1),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: appConfigblockSizeHeight * 0.5,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 2,
                        ),
                        Container(
                          width: appConfigblockSizeWidth * 90,
                          padding: EdgeInsets.all(appConfigblockSizeWidth * 2),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset:
                                Offset(0, 0), // changes position of shadow
                              ),
                            ],
                            color: Color.fromRGBO(156, 156, 156, 1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(appConfigblockSizeWidth * 4)),
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: appConfigblockSizeHeight * 1,
                              ),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          data[ID]["dog_name"],
                                          style: TextStyle(
                                            color:
                                            Color.fromRGBO(34, 36, 86, 1),
                                            fontWeight: FontWeight.w900,
                                            fontSize: fontSize * 8,
                                          ),
                                        ),
                                        Text(
                                          " was groomed on",
                                          style: TextStyle(
                                            color:
                                            Color.fromRGBO(34, 36, 86, 1),
                                            fontWeight: FontWeight.w600,
                                            fontSize: fontSize * 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: appConfigblockSizeHeight * 2,),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                maxHeight: 30,),
                                              child: FlatButton(
                                                child: Text(
                                                  (finalDate == null)
                                                      ? 'Date'
                                                      : finalDate,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        34, 36, 86, 1),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: fontSize * 10,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder:
                                                          (BuildContext builder) {
                                                        return Container(
                                                            height: MediaQuery
                                                                .of(
                                                                context)
                                                                .copyWith()
                                                                .size
                                                                .height /
                                                                3,
                                                            child: Container(
                                                                child: datetime()));
                                                      });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(" at ",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    34, 36, 86, 1),
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSize * 8.5)),
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxHeight: 30,),
                                          child: FlatButton(

                                            child: Text(
                                              (finalTime == null)
                                                  ? 'Time'
                                                  : finalTime,
                                              style: TextStyle(
                                                color:
                                                Color.fromRGBO(34, 36, 86, 1),
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSize * 10,
                                              ),
                                            ),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext builder) {
                                                    return Container(
                                                        height: MediaQuery
                                                            .of(
                                                            context)
                                                            .copyWith()
                                                            .size
                                                            .height /
                                                            3,
                                                        child: time());
                                                  });
                                            },
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Switch(
                                                activeColor: Color.fromRGBO(34, 36, 86, 1),
                                                value: nails,
                                                onChanged: (value) {
                                                  setState(() {
                                                    nails = value;
                                                  });
                                                }),
                                            Text('Did you cut nails?', style: TextStyle(fontSize: fontSize * 8, color: Color.fromRGBO(34, 36, 86, 1),),)
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Switch(
                                                activeColor: Color.fromRGBO(34, 36, 86, 1),
                                                value: cut,
                                                onChanged: (value) {
                                                  setState(() {
                                                    cut = value;
                                                  });
                                                }),
                                            Text('Did you trim, shave or cut?', style: TextStyle(fontSize: fontSize * 8, color: Color.fromRGBO(34, 36, 86, 1),),)
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Switch(
                                                activeColor: Color.fromRGBO(34, 36, 86, 1),
                                                value: wash,
                                                onChanged: (value) {
                                                  setState(() {
                                                    wash = value;
                                                  });
                                                }),
                                            Text('Did you wash?', style: TextStyle(fontSize: fontSize * 8, color: Color.fromRGBO(34, 36, 86, 1),),)
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Switch(
                                              activeColor: Color.fromRGBO(34, 36, 86, 1),
                                                value: other,
                                                onChanged: (value) {
                                                  setState(() {
                                                    other = value;
                                                    print(other);
                                                  });
                                                }),
                                            Text('Did you do anything else?', style: TextStyle(fontSize: fontSize * 8, color: Color.fromRGBO(34, 36, 86, 1),),)
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),



                              SizedBox(
                                height: appConfigblockSizeHeight * 2,
                              ),
                              Column(
                                children: <Widget>[


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                  color: Color.fromRGBO(
                                                      34, 36, 86, 1),
                                                )),
                                            textColor: Colors.white,
                                            color:
                                            Color.fromRGBO(34, 36, 86, 1),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext builder) {
                                                    return Container(
                                                        height: MediaQuery
                                                            .of(
                                                            context)
                                                            .copyWith()
                                                            .size
                                                            .height /
                                                            3,
                                                        child: Container(
                                                            child: datetime()));
                                                  });
                                            },
                                            child: Text('Select date'),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: appConfigblockSizeWidth * 4,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                  color: Color.fromRGBO(
                                                      34, 36, 86, 1),
                                                )),
                                            textColor: Colors.white,
                                            color:
                                            Color.fromRGBO(34, 36, 86, 1),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext builder) {
                                                    return Container(
                                                        height: MediaQuery
                                                            .of(
                                                            context)
                                                            .copyWith()
                                                            .size
                                                            .height /
                                                            3,
                                                        child: time());
                                                  });
                                            },
                                            child: Text('Select time'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 2,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: 'remove',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AppointmentInfo()));
                              },
                              child: Icon(
                                Icons.remove,
                              ),
                              backgroundColor: Color.fromRGBO(34, 36, 86, 1),
                            ),
                            SizedBox(
                              width: appConfigblockSizeWidth * 5,
                            ),
                            FloatingActionButton(
                              heroTag: 'add',
                              onPressed: () {
                                isItIndexZero();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AppointmentInfo()));
                              },
                              child: Icon(
                                Icons.add,
                              ),
                              backgroundColor: Color.fromRGBO(34, 36, 86, 1),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  timeCheck() {
    String time;

    if (dbTime == null) {
      time = 'Time';
    } else {
      time = dbTime;
    }
    return time;
  }

  dateCheck() {
    String date;

    if (dbDate == null) {
      date = 'Date';
    } else {
      date = dbDate;
    }
    return date;
  }



  String dbnails;
  String dbcut;
  String dbwash;
  String dbother;
  String dbtype;


  nailsCheck() {
    if (nails == true) {
      dbnails = 'Nails, ';
    } else {
      dbnails = ' ';
    }

    return dbnails;
  }

  cutCheck() {

    if (cut == true) {
      dbcut = 'Cut, ';
    } else {
      dbcut = ' ';
    }

    return dbcut;
  }

  washCheck() {

    if (wash == true) {
      dbwash = 'Wash, ';
    } else {
      dbwash = ' ';
    }

    return dbwash;
  }

  otherCheck() {

    if (other == true) {
      dbother = 'Other';
    } else {
      dbother = ' ';
    }

    return dbother;
  }


  _addType(){
    nailsCheck();
    cutCheck();
    washCheck();
    otherCheck();

    dbtype = '$dbnails$dbcut$dbwash$dbother';
    return dbtype;
  }

  isItIndexZero(){
    uniqueIDGenerated();

    if (scheduledata == null){_onInsert();}
    else if (scheduledata[0]['date'] == "Date"){_onUpdate();}
    else {_onInsert();}

  }

  _onUpdate() async {
    _addType();
    Database db = await DatabaseHelper.instance.database;
    Map<String, dynamic> row = {
      DatabaseHelper.columnGroomDate: '${dateCheck()}',
      DatabaseHelper.columnGroomTime: '${timeCheck()}',
      DatabaseHelper.columnGroomType: '${dbtype}',
      DatabaseHelper.columnGroomUnique: 'ID$uuidgroom'
    };
    await db.update('$dogUniqueID', row);
  }

  _onInsert() async {
    _addType();
    Database db = await DatabaseHelper.instance.database;
    Map<String, dynamic> row = {
      DatabaseHelper.columnGroomDate: '${dateCheck()}',
      DatabaseHelper.columnGroomTime: '${timeCheck()}',
      DatabaseHelper.columnGroomType: '${dbtype}',
      DatabaseHelper.columnGroomUnique: 'ID$uuidgroom'
    };
    await db.insert('$dogUniqueID', row);
  }

  var uuidgroom;
  uniqueIDGenerated() {
    var rng = new Random();
    for (var i = 0; i < 1; i++) {
      uuidgroom = (rng.nextInt(10000));
    }
    return uuidgroom;
  }

}






