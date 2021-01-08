import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:intl/intl.dart';
import 'package:daniellesdoggrooming/database/database_logic.dart';
import 'package:daniellesdoggrooming/screens/appointments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/cupertino.dart';
import 'doggo_info.dart';
import 'package:daniellesdoggrooming/database/scheduler.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:daniellesdoggrooming/screens/addgroom.dart';
import 'package:daniellesdoggrooming/screens/addhistory.dart';
import 'package:daniellesdoggrooming/screens/addhistory_update.dart';






class AppointmentInfo extends StatefulWidget {
  static const String id = 'appointmentinfo';

  @override
  _AppointmentInfoState createState() => _AppointmentInfoState();
}

class _AppointmentInfoState extends State<AppointmentInfo>
    with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  //////////////DEFINITIONS
  final dbHelper = DatabaseHelper.instance;

  var ID = 0;
  int indexID;

  var dogUniqueID;
  var number;
  var doggoID;
  var owner;
  var scheduledata;
  List data;
  var result;
  var groomHistoryUniqueID;

  String rescheduleddate;
  String newdate;
  String fulldate;
  String month;
  int day;
  int newyear;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  Duration initialtimer = new Duration();
  int selectitem = 1;

  String jan = '01';
  String feb = '02';
  String mar = '03';
  String apr = '04';
  String ma = '05';
  String jun = '06';
  String jul = '07';
  String aug = '08';
  String sep = '09';
  String oct = '10';
  String nov = '11';
  String dec = '12';

  int mth1 = 31;
  int mth2;
  int mth3 = 31;
  int mth4 = 30;
  int mth5 = 31;
  int mth6 = 30;
  int mth7 = 31;
  int mth8 = 31;
  int mth9 = 30;
  int mth10 = 31;
  int mth11 = 30;
  int mth12 = 31;

  var resyear;
  var supplyUniqueID;
  var supplyID;

  String finalDate;
  String finalTime;
  var dogInfoID;

  var previewImage = Image(image: AssetImage('images/doggo.png'));

  //////////CHECK IF FIRST SCHEDULE IS THERE
  firstSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstSchedule = prefs.getBool('$dogUniqueID') ?? false;
    if (isFirstSchedule == false) {
      print("This Is Not The First Schedule");
    } else if (isFirstSchedule == true) {
      print("This Is The First Schedule");
      initDb();
    }
  }
  //////////CREATE SCHEDULE TABLE IN DATABASE
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentDirectory.path, 'database.db');
    var ourDb = await openDatabase(path);
    print('DB Opened');
    print(dogUniqueID);
    _onCreate();
    return ourDb;
  }
  _onCreate() async {
    final table = dogUniqueID;
    final columnId = '_id';
    final columnGroomDate = 'date';
    final columnGroomTime = 'time';
    final columnGroomType = 'type';

    Database db = await DatabaseHelper.instance.database;
    await db.execute(
        "CREATE TABLE $dogUniqueID($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnGroomDate TEXT NOT NULL,$columnGroomTime TEXT NOT NULL,$columnGroomType TEXT NOT NULL)");
    print("Table Created");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$dogUniqueID', false);
    print('Scheduling database has been created');

    Map<String, dynamic> row = {
      DatabaseHelper.columnGroomDate: 'Date',
      DatabaseHelper.columnGroomTime: 'Time',
      DatabaseHelper.columnGroomType: 'Nothing'
    };
    await db.insert('$dogUniqueID', row);
    print('inserted row ');
  }

  /////////FETCH INFO FROM DATABASE
  Future<String> fetchDogs() async {
    var database = await openDatabase('database.db');
    List<Map<String, dynamic>> records = await database.query('doggos');
    Map<String, dynamic> mapRead = records.first;
//    mapRead['my_column'] = 1;
    Map<String, dynamic> map = Map<String, dynamic>.from(mapRead);

    var newlist = records.toList();

    var hello = newlist
      ..sort((a, b) => a["date"].toString().compareTo(b["date"].toString()));

    data = hello;

    setState(() {
      data;
    });
  }
  Future<String> fetchSchedules() async {
    var database = await openDatabase('database.db');
    List<Map<String, dynamic>> records = await database.query('$dogUniqueID');
    Map<String, dynamic> mapRead = records.first;
    Map<String, dynamic> map = Map<String, dynamic>.from(mapRead);

    var newlist = records.toList();
    var hello = newlist
      ..sort((b, a) => a["date"].toString().compareTo(b["date"].toString()));

    scheduledata = hello;
    print(scheduledata);

    setState(() {
      scheduledata;
    });
  }

  fetchUniqueID() async {
    SharedPreferences doginfo = await SharedPreferences.getInstance();
    dogUniqueID = doginfo.getString('doguniqueid') ?? '';
  }

  var results;
  fetchID() async {

    SharedPreferences doginfoid = await SharedPreferences.getInstance();
    dogInfoID = doginfoid.getString('pulluniqueid') ?? '';
    Database db = await DatabaseHelper.instance.database;
    // raw query
    List<Map> result = await db.rawQuery('SELECT * FROM doggos WHERE _id=?', ['$dogInfoID']);

    indexID = result[0]['_id'];


    print('Dog Name is ${result[0]['dog_name']}');
    setState(() {
      results = result;
      return data.toList();
    });
  }

  /////////INIT STATE
  @override
  void initState() {
    fetchUniqueID();
    fetchID();
    fetchSchedules();
    fetchDogs();
  }

  //////////////MAIN UI
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Appointments()),
            ),
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
                        //////////////DOG INFORMATION
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
                                                AssetImage(data[0]['picture']),
                                            backgroundColor: Colors.transparent,
                                            radius:
                                                appConfigblockSizeWidth * 10,
                                          )
                                        : CircleAvatar(
                                            backgroundImage:
                                                AssetImage(data[0]["picture"]),
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
                                          results[ID]["dog_name"],
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
                                              (results[ID]["age"]).toString(),
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
                                              (results[ID]["sex"]).toString(),
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
                                        (results[ID]["breed"]).toString(),
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

                        /////////////SCHEDULE GROOM
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
                                          results[ID]["dog_name"],
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(34, 36, 86, 1),
                                            fontWeight: FontWeight.w900,
                                            fontSize: fontSize * 9,
                                          ),
                                        ),
                                        Text(
                                          " is scheduled",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(34, 36, 86, 1),
                                            fontWeight: FontWeight.w600,
                                            fontSize: fontSize * 9,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "to be groomed on",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(34, 36, 86, 1),
                                            fontWeight: FontWeight.w500,
                                            fontSize: fontSize * 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
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
                                            Text(
                                              results[ID]["date"],
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    34, 36, 86, 1),
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSize * 11,
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
                                        Text(results[ID]["time"],
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(34, 36, 86, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSize * 11,
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: appConfigblockSizeHeight * 1,),
                                    Text((results[ID]['type'] == ' ') ? '' : results[ID]['type'] ,
                                      style: TextStyle(
                                        color:
                                        Color.fromRGBO(34, 36, 86, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize * 7,
                                      ),
                                    ),
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
                                    children: [
                                      Text(
                                        "Update ",
                                        style: TextStyle(
                                          color: Color.fromRGBO(34, 36, 86, 1),
                                          fontSize: fontSize * 6.5,
                                        ),
                                      ),
                                      Text(
                                        results[ID]["dog_name"],
                                        style: TextStyle(
                                          color: Color.fromRGBO(34, 36, 86, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize * 7,
                                        ),
                                      ),
                                      Text(
                                        "'s appointment",
                                        style: TextStyle(
                                          color: Color.fromRGBO(34, 36, 86, 1),
                                          fontSize: fontSize * 6.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: appConfigblockSizeHeight * 2,
                                  ),
                                  SizedBox(
                                    height: appConfigblockSizeHeight * 1,
                                  ),
                                  Container(
                                    height: appConfigblockSizeHeight * 5,
                                    width: appConfigblockSizeHeight * 5,
                                    child: FloatingActionButton(
                                      heroTag: 'addgroom',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AddGroom()));
                                      },
                                      child: Icon(
                                        Icons.add,
                                      ),
                                      backgroundColor:
                                          Color.fromRGBO(34, 36, 86, 1),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: appConfigblockSizeHeight * 1,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 2,
                        ),

                        /////////////PAST GROOM SCHEDULE
                        Container(
                          width: appConfigblockSizeWidth * 100,
                          constraints: BoxConstraints(
                            maxHeight: appConfigblockSizeHeight * 33,
                            maxWidth: appConfigblockSizeWidth * 100,
                          ),
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
                            children: [
                              SizedBox(
                                height: appConfigblockSizeHeight * 1,
                              ),
                              Text(
                                'Grooming History',
                                style: TextStyle(
                                    color: Color.fromRGBO(34, 36, 86, 1),
                                    fontWeight: FontWeight.w900,
                                    fontSize: fontSize * 8),
                              ),

                              (scheduledata == null)
                                  ? (Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Container(
                                    height: 73,
                                    width: 73,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                        AssetImage('images/logo.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ))
                                      : Stack(
                                          children: <Widget>[
                                            Container(
                                              constraints: BoxConstraints(
                                                maxHeight:
                                                    appConfigblockSizeHeight *
                                                        20,
                                                maxWidth:
                                                    appConfigblockSizeWidth *
                                                        100,
                                              ),
                                              child: (ListView.builder(
                                                itemCount: scheduledata.length,
                                                itemBuilder:
                                                    (BuildContext context, i) {
                                                  return new ListTile(
                                                    onTap: () async {
                                                      groomHistoryUniqueID =
                                                      scheduledata[i][
                                                      "uniqueID"];
                                                      SharedPreferences
                                                      groomhistory =
                                                      await SharedPreferences
                                                          .getInstance();
                                                      groomhistory.setString(
                                                          'groomhistoryuniqueid',
                                                          '$groomHistoryUniqueID');


                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                  (AddHistoryUpdate())));

                                                    },
                                                    title: new Text(
                                                      scheduledata[i]['date'],
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              34, 36, 86, 1)),
                                                    ),
                                                    subtitle: new Text(
                                                      scheduledata[i]['type'],
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              54, 56, 96, 1)),
                                                    ),
                                                    trailing: (Text(
                                                      scheduledata[i]['time'],
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              34, 36, 86, 1)),
                                                    )),
                                                  );
                                                },
                                              )),
                                            ),
                                          ],
                                        ),
                              Container(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: appConfigblockSizeHeight * 1,
                                    ),
                                    Container(
                                      height: appConfigblockSizeHeight * 5,
                                      width: appConfigblockSizeHeight * 5,
                                      child: FloatingActionButton(
                                        heroTag: 'addhistory',
                                        onPressed: () {



                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => AddHistory()));
                                        },
                                        child: Icon(
                                          Icons.add,
                                        ),
                                        backgroundColor:
                                            Color.fromRGBO(34, 36, 86, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

  /////////////DATABASE CHECKERS
  timeCheck() {
    var time;

    if (finalTime == null) {
      time = 'No Time';
    } else {
      time = finalTime;
    }

    return time;
  }

  dateCheck() {
    var date;

    if (finalDate == null) {
      date = 'No Groom Scheduled';
    } else {
      date = finalDate;
    }

    return date;
  }

  /////////////INSERT TO DATABASE
  void _addPastGroom() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> records = await db.query('$dogUniqueID');

    final columnGroomDate = 'date';
    final columnGroomTime = 'time';
    final columnGroomType = 'type';

    Map<String, dynamic> row = {
      columnGroomDate: '2020-03-10',
      columnGroomTime: '11:00',
      columnGroomType: 'Bath'
    };

    await db.insert(dogUniqueID, row);

    print("Completed");
  }

  void _updateGroomDate() async {
    if (finalDate == null) {
    } else if (finalDate != null) {
      Map<String, dynamic> row = {
        DatabaseHelper.columnId: (indexID),
        DatabaseHelper.columnScheduleDate: "${dateCheck()}",
      };
      final rowsAffected = await dbHelper.updateDoggos(row);
    }
  }

  void _updateGroomTime() async {
    if (finalTime == null) {
    } else if (finalTime != null) {
      Map<String, dynamic> row = {
        DatabaseHelper.columnId: (indexID),
        DatabaseHelper.columnScheduleTime: "${timeCheck()}",
      };
      final rowsAffected = await dbHelper.updateDoggos(row);
    }
  }

  void _rescheduleByWeeks() async {
    if (rescheduleddate == null) {
    } else if (rescheduleddate != null) {
      Map<String, dynamic> row = {
        DatabaseHelper.columnId: (indexID),
        DatabaseHelper.columnScheduleDate: "$rescheduleddate",
      };
      final rowsAffected = await dbHelper.updateDoggos(row);
    }
  }

  /////////////REMOVE FROM DATABASE
  void _removeGroom() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnScheduleDate: "No Grooming Scheduled",
      DatabaseHelper.columnScheduleTime: "No Time",
    };
    final rowsAffected = await dbHelper.updateDoggos(row);
  }
}
