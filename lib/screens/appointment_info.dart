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
//    mapRead['my_column'] = 1;
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
    indexID = result[0]['_id'];

    setState(() {
      var extractdata = result;
      data = extractdata;
      return data.toList();
    });
  }

  /////////INIT STATE
  @override
  void initState() {
    fetchUniqueID();
    fetchSchedules();
    fetchID();
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
                                          data[ID]["dog_name"],
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
                                              data[ID]["date"],
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
                                        Text(data[ID]["time"],
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
                                    Text((data[0]['type'] == ' ') ? '' : data[0]['type'] ,
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
                                        data[ID]["dog_name"],
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
                                  :

                              (scheduledata[0]['date'] == 'Date')
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

  ///////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////
  ////////////                RESCHULDER LOGIC             //////////////////
  ///////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////

  ////////////DATE ARRANGERS
  seconddaterearranger() async {
    var theyear;
    var themonth;
    var theday;
    var newday;
    var checkday;
    var pulledDate = newdate;

    if (pulledDate.length == 9) {
      theyear = pulledDate.substring(5, 9);
      themonth = pulledDate.substring(2, 4);
      theday = pulledDate.substring(0, 1);
    } else {
      theyear = pulledDate.substring(6, 10);
      themonth = pulledDate.substring(3, 5);
      theday = pulledDate.substring(0, 2);
    }

    checkday = int.parse(theday);

    if (checkday <= 9) {
      newday = checkday.toString().padLeft(2, '0');
    } else {
      newday = checkday;
    }

    rescheduleddate = '$theyear-$themonth-$newday';
  }

  daterearranger() async {
    var theyear;
    var themonth;
    var theday;
    var pulledDate = data[ID]['date'];

    theyear = pulledDate.substring(0, 4);
    themonth = pulledDate.substring(5, 7);
    theday = pulledDate.substring(8, 10);

    fulldate = '$theday-$themonth-$theyear';

    var theactualyear = int.parse(theyear.substring(0, 4));
    resyear = theactualyear;
  }

  ///////////SPECIAL CONDITIONS
  newyearleap() {
    var year = newyear;
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return mth2 = 29;
        } else {
          return mth2 = 30;
        }
      } else {
        return mth2 = 29;
      }
    } else {
      return mth2 = 30;
    }
  }

  february() {
    var year = int.parse(fulldate.substring(7, 10));
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return mth2 = 29;
        } else {
          return mth2 = 30;
        }
      } else {
        return mth2 = 29;
      }
    } else {
      return mth2 = 30;
    }
  }

/////////1 Week////////////
  void oneweek() {
    int actualday = 1;
    var year = int.parse(fulldate.substring(7, 10));
    month = fulldate.substring(3, 5);
    day = int.parse(fulldate.substring(0, 2));
    finalday = day;

    if (month == jan) {
      if (day <= 24 && day >= 1) {
        finalday = ((31 - 11) + (day) + actualday - 14);
      } else if (day <= 31 && day >= 25) {
        finalday = ((30 - 7) + 1 + (day) - (35) + actualday - 14);
      }
      result =
          (day <= 24) ? '$finalday-$jan-$resyear' : '$finalday-$feb-$resyear';
    } else if (month == feb) {
      if (day <= 21 && day >= 1) {
        finalday = (february() == 29)
            ? (february() + day - 30 + 22 - 14)
            : (february() + day - 30 + 7);
      } else if (day == 22) {
        finalday = ((february() == 29 ? (29) : 1));
      } else if (day <= 31 && day >= 23) {
        finalday = (february() == 29)
            ? (february() + day - 37 - 14)
            : (february() + day - 37 - 14);
      }

      result = (february() == 29 && day >= 23)
          ? '$finalday-$mar-$resyear'
          : (february() == 30 && day >= 22)
              ? '$finalday-$mar-$resyear'
              : '$finalday-$feb-$resyear';

      print('$result');
    } else if (month == mar) {
      if (day <= 24 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 21);
      } else if (day <= 31 && day >= 25) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 21);
      }
      result =
          (day <= 24) ? '$finalday-$mar-$resyear' : '$finalday-$apr-$resyear';

      print('$result');
    } else if (month == apr) {
      if (day <= 23 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 21);
      } else if (day <= 31 && day >= 24) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday - 21);
      }
      result =
          (day <= 23) ? '$finalday-$apr-$resyear' : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == ma) {
      if (day <= 24 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 21);
      } else if (day <= 31 && day >= 25) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 21);
      }
      result =
          (day <= 24) ? '$finalday-$ma-$resyear' : '$finalday-$jun-$resyear';

      print('$result');
    } else if (month == jun) {
      if (day <= 23 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 21);
      } else if (day <= 31 && day >= 24) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday - 21);
      }
      result =
          (day <= 23) ? '$finalday-$jun-$resyear' : '$finalday-$jul-$resyear';

      print('$result');
    } else if (month == jul) {
      if (day <= 24 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 21);
      } else if (day <= 31 && day >= 25) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 21);
      }
      result =
          (day <= 24) ? '$finalday-$jul-$resyear' : '$finalday-$aug-$resyear';

      print('$result');
    } else if (month == aug) {
      if (day <= 24 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 21);
      } else if (day <= 31 && day >= 25) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 21);
      }
      result =
          (day <= 24) ? '$finalday-$aug-$resyear' : '$finalday-$sep-$resyear';

      print('$result');
    } else if (month == sep) {
      if (day <= 23 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 21);
      } else if (day <= 31 && day >= 24) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday - 21);
      }
      result =
          (day <= 23) ? '$finalday-$sep-$resyear' : '$finalday-$oct-$resyear';

      print('$result');
    } else if (month == oct) {
      if (day <= 24 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 21);
      } else if (day <= 31 && day >= 25) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 21);
      }
      result =
          (day <= 24) ? '$finalday-$oct-$resyear' : '$finalday-$nov-$resyear';

      print('$result');
    } else if (month == nov) {
      if (day <= 23 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 21);
      } else if (day <= 31 && day >= 24) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday - 21);
      }
      result =
          (day <= 23) ? '$finalday-$nov-$resyear' : '$finalday-$dec-$resyear';

      print('$result');
    } else if (month == dec) {
      var newyear = resyear + 1;
      if (day <= 24 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 21);
      } else if (day <= 31 && day >= 25) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 21);
      }
      result =
          (day <= 24) ? '$finalday-$dec-$resyear' : '$finalday-$jan-$newyear';

      print('$result');
    }

    newdate = result;
  }

//////////////2 Weeks//////////////
  void twoweek() {
    int actualday = 1;
    var year = int.parse(fulldate.substring(7, 10));
    month = fulldate.substring(3, 5);
    day = int.parse(fulldate.substring(0, 2));
    finalday = day;

    if (month == jan) {
      if (day <= 17 && day >= 1) {
        finalday = ((31 - 11) + (day) + actualday - 7);
      } else if (day <= 31 && day >= 17) {
        finalday = ((30 - 7) + 1 + (day) - (35) + actualday - 7);
      }
      result =
          (day <= 17) ? '$finalday-$jan-$resyear' : '$finalday-$feb-$resyear';
      print('$result');
    } else if (month == feb) {
      if (day <= 14 && day >= 1) {
        finalday = (february() == 29)
            ? (february() + day - 30 + 22 - 7)
            : (february() + day - 30 + 14);
      } else if (day == 15) {
        finalday = ((february() == 29 ? (29) : 1));
      } else if (day <= 31 && day >= 16) {
        finalday = (february() == 29)
            ? (february() + day - 37 - 7)
            : (february() + day - 37 - 7);
      }

      result = (february() == 29 && day == 15)
          ? '$finalday-$feb-$resyear'
          : (february() == 30 && day == 15)
              ? '$finalday-$mar-$resyear'
              : '$finalday-$mar-$resyear';

      print('$result');
    } else if (month == mar) {
      if (day <= 17 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 14);
      } else if (day <= 31 && day >= 18) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 14);
      }
      result =
          (day <= 17) ? '$finalday-$mar-$resyear' : '$finalday-$apr-$resyear';

      print('$result');
    } else if (month == apr) {
      if (day <= 16 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 14);
      } else if (day <= 31 && day >= 17) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday - 14);
      }
      result =
          (day <= 16) ? '$finalday-$apr-$resyear' : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == ma) {
      if (day <= 17 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 14);
      } else if (day <= 31 && day >= 18) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 14);
      }
      result =
          (day <= 17) ? '$finalday-$ma-$resyear' : '$finalday-$jun-$resyear';

      print('$result');
    } else if (month == jun) {
      if (day <= 16 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 14);
      } else if (day <= 31 && day >= 17) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday - 14);
      }
      result =
          (day <= 16) ? '$finalday-$jun-$resyear' : '$finalday-$jul-$resyear';

      print('$result');
    } else if (month == jul) {
      if (day <= 17 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 14);
      } else if (day <= 31 && day >= 18) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 14);
      }
      result =
          (day <= 17) ? '$finalday-$jul-$resyear' : '$finalday-$aug-$resyear';

      print('$result');
    } else if (month == aug) {
      if (day <= 17 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 14);
      } else if (day <= 31 && day >= 18) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 14);
      }
      result =
          (day <= 17) ? '$finalday-$aug-$resyear' : '$finalday-$sep-$resyear';

      print('$result');
    } else if (month == sep) {
      if (day <= 16 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 14);
      } else if (day <= 31 && day >= 17) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday - 14);
      }
      result =
          (day <= 16) ? '$finalday-$sep-$resyear' : '$finalday-$oct-$resyear';

      print('$result');
    } else if (month == oct) {
      if (day <= 17 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 14);
      } else if (day <= 31 && day >= 18) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 14);
      }
      result =
          (day <= 17) ? '$finalday-$oct-$resyear' : '$finalday-$nov-$resyear';

      print('$result');
    } else if (month == nov) {
      if (day <= 16 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 14);
      } else if (day <= 31 && day >= 17) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday - 14);
      }
      result =
          (day <= 16) ? '$finalday-$nov-$resyear' : '$finalday-$dec-$resyear';

      print('$result');
    } else if (month == dec) {
      var newyear = resyear + 1;
      if (day <= 17 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 14);
      } else if (day <= 31 && day >= 18) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 14);
      }
      result =
          (day <= 17) ? '$finalday-$dec-$resyear' : '$finalday-$jan-$newyear';

      print('$result');
    }

    newdate = result;
  }

////////3 Week//////////////
  void threeweek() {
    int actualday = 1;
    var year = int.parse(fulldate.substring(7, 10));
    month = fulldate.substring(3, 5);
    day = int.parse(fulldate.substring(0, 2));
    finalday = day;

    if (month == jan) {
      if (day <= 10 && day >= 1) {
        finalday = ((31 - 11) + (day) + actualday);
      } else if (day <= 31 && day >= 11) {
        finalday = ((30 - 7) + 1 + (day) - (35) + actualday);
      }
      result =
          (day <= 10) ? '$finalday-$jan-$resyear' : '$finalday-$feb-$resyear';
      print('$result');
    } else if (month == feb) {
      if (day <= 7 && day >= 1) {
        finalday = (february() == 29)
            ? (february() + day - 30 + 22)
            : (february() + day - 30);
      } else if (day == 8) {
        finalday = ((february() == 29 ? (29) : 1));
      } else if (day <= 31 && day >= 9) {
        finalday = (february() == 29)
            ? (february() + day - 37)
            : (february() + day - 37);
      }

      result = (february() == 29 && day <= 8)
          ? '$finalday-$feb-$resyear'
          : (february() == 30 && day == 8)
              ? '$finalday-$mar-$resyear'
              : '$finalday-$mar-$resyear';

      print('$result');
    } else if (month == mar) {
      if (day <= 10 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 7);
      } else if (day <= 31 && day >= 11) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 7);
      }
      result =
          (day <= 10) ? '$finalday-$mar-$resyear' : '$finalday-$apr-$resyear';

      print('$result');
    } else if (month == apr) {
      if (day <= 9 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 7);
      } else if (day <= 31 && day >= 10) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday - 7);
      }
      result =
          (day <= 9) ? '$finalday-$apr-$resyear' : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == ma) {
      if (day <= 10 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 7);
      } else if (day <= 31 && day >= 11) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 7);
      }
      result =
          (day <= 10) ? '$finalday-$ma-$resyear' : '$finalday-$jun-$resyear';

      print('$result');
    } else if (month == jun) {
      if (day <= 9 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 7);
      } else if (day <= 31 && day >= 10) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday - 7);
      }
      result =
          (day <= 9) ? '$finalday-$jun-$resyear' : '$finalday-$jul-$resyear';

      print('$result');
    } else if (month == jul) {
      if (day <= 10 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 7);
      } else if (day <= 31 && day >= 11) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 7);
      }
      result =
          (day <= 10) ? '$finalday-$jul-$resyear' : '$finalday-$aug-$resyear';

      print('$result');
    } else if (month == aug) {
      if (day <= 10 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 7);
      } else if (day <= 31 && day >= 11) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 7);
      }
      result =
          (day <= 10) ? '$finalday-$aug-$resyear' : '$finalday-$sep-$resyear';

      print('$result');
    } else if (month == sep) {
      if (day <= 9 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 7);
      } else if (day <= 31 && day >= 10) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday - 7);
      }
      result =
          (day <= 9) ? '$finalday-$sep-$resyear' : '$finalday-$oct-$resyear';

      print('$result');
    } else if (month == oct) {
      if (day <= 10 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 7);
      } else if (day <= 31 && day >= 11) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 7);
      }
      result =
          (day <= 10) ? '$finalday-$oct-$resyear' : '$finalday-$nov-$resyear';

      print('$result');
    } else if (month == nov) {
      if (day <= 9 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 7);
      } else if (day <= 31 && day >= 10) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday - 7);
      }
      result =
          (day <= 9) ? '$finalday-$nov-$resyear' : '$finalday-$dec-$resyear';

      print('$result');
    } else if (month == dec) {
      var newyear = resyear + 1;
      if (day <= 10 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday - 7);
      } else if (day <= 31 && day >= 11) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday - 7);
      }
      result =
          (day <= 10) ? '$finalday-$dec-$resyear' : '$finalday-$jan-$newyear';

      print('$result');
    }

    newdate = result;
  }

//////////4 Week/////////////
  void fourweek() {
    int actualday = 1;
    var year = int.parse(fulldate.substring(7, 10));
    month = fulldate.substring(3, 5);
    day = int.parse(fulldate.substring(0, 2));
    finalday = day;

    if (month == jan) {
      if (day <= 3 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday);
      } else if (day <= 31 && day >= 4) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday);
      }

      result = (february() == 29 && day >= 4)
          ? '$finalday-$feb-$resyear'
          : (february() == 30 && day >= 4)
              ? '$finalday-$feb-$resyear'
              : '$finalday-$jan-$resyear';
      print('$result');
    } else if (month == feb) {
      if (day == 1) {
        finalday = ((february() == 29 ? (29) : 1));
      } else if (day <= 29 && day >= 2) {
        finalday = (february() == 29)
            ? (february() + day - 30)
            : (february() + day - 30);
      }
      result = (february() == 29 && day == 1)
          ? '$finalday-$feb-$resyear'
          : (february() == 30 && day >= 1)
              ? '$finalday-$mar-$resyear'
              : '$finalday-$mar-$resyear';

      print('$result');
    } else if (month == mar) {
      if (day <= 3 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday);
      } else if (day <= 31 && day >= 4) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday);
      }
      result =
          (day <= 3) ? '$finalday-$mar-$resyear' : '$finalday-$apr-$resyear';

      print('$result');
    } else if (month == apr) {
      if (day <= 2 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday);
      } else if (day <= 31 && day >= 3) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday);
      }
      result =
          (day <= 2) ? '$finalday-$apr-$resyear' : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == ma) {
      if (day <= 3 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday);
      } else if (day <= 31 && day >= 4) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday);
      }
      result =
          (day <= 3) ? '$finalday-$ma-$resyear' : '$finalday-$jun-$resyear';

      print('$result');
    } else if (month == jun) {
      if (day <= 2 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday);
      } else if (day <= 31 && day >= 3) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday);
      }
      result =
          (day <= 3) ? '$finalday-$jun-$resyear' : '$finalday-$jul-$resyear';

      print('$result');
    } else if (month == jul) {
      if (day <= 3 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday);
      } else if (day <= 31 && day >= 4) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday);
      }
      result =
          (day <= 3) ? '$finalday-$jul-$resyear' : '$finalday-$aug-$resyear';

      print('$result');
    } else if (month == aug) {
      if (day <= 3 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday);
      } else if (day <= 31 && day >= 4) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday);
      }
      result =
          (day <= 3) ? '$finalday-$aug-$resyear' : '$finalday-$sep-$resyear';

      print('$result');
    } else if (month == sep) {
      if (day <= 2 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday);
      } else if (day <= 31 && day >= 3) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday);
      }
      result =
          (day <= 3) ? '$finalday-$sep-$resyear' : '$finalday-$oct-$resyear';

      print('$result');
    } else if (month == oct) {
      if (day <= 3 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday);
      } else if (day <= 31 && day >= 4) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday);
      }
      result =
          (day <= 3) ? '$finalday-$oct-$resyear' : '$finalday-$nov-$resyear';

      print('$result');
    } else if (month == nov) {
      if (day <= 2 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday);
      } else if (day <= 31 && day >= 3) {
        finalday = ((30 - 7) + 2 + (day) - (28) + actualday);
      }
      result =
          (day <= 3) ? '$finalday-$nov-$resyear' : '$finalday-$dec-$resyear';

      print('$result');
    } else if (month == dec) {
      newyear = resyear + 1;
      if (day <= 3 && day >= 1) {
        finalday = ((31 - 4) + (day) + actualday);
      } else if (day <= 31 && day >= 4) {
        finalday = ((30 - 7) + 1 + (day) - (28) + actualday);
      }
      result =
          (day <= 3) ? '$finalday-$dec-$resyear' : '$finalday-$jan-$newyear';

      print('$result');
    }

    newdate = result;
  }

////////////5 Week////////////////
  void fiveweek() {
    int actualday = 1;
    var year = int.parse(fulldate.substring(7, 10));
    month = fulldate.substring(3, 5);
    day = int.parse(fulldate.substring(0, 2));
    finalday = day;

    if (month == jan) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday);
      } else if (day <= 21 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday);
      } else if (day <= 24 && day >= 22) {
        finalday = ((30 - 7) + 1 + (day) - (21) + actualday);
      } else if (day == 25) {
        finalday = february() == 29 ? 29 : 01;
      } else if (day <= 31 && day >= 26) {
        finalday = february() == 29
            ? (((30) + (day) - (25) + actualday) - february()) - 2
            : (((30) + (day) - (25) + actualday) - february());
      }

      result = (february() == 29 && day >= 26)
          ? '$finalday-$mar-$resyear'
          : (february() == 30 && day >= 26)
              ? '$finalday-$mar-$resyear'
              : '$finalday-$feb-$resyear';
      print('$result');
    } else if (month == feb) {
      if (day <= 7 && day >= 1) {
        finalday = ((february() - 28) + 4 + (day) + actualday);
      } else if (day <= 14 && day >= 8) {
        finalday = ((february() - 17) + (day) - (7) + actualday);
      } else if (day <= 21 && day >= 15) {
        finalday = ((february() - 10) + (day) - (14) + actualday);
      } else if (day <= 24 && day >= 22) {
        finalday = ((february() - 3) + (day) - (21) + actualday);
      } else if (day == 25) {
        finalday = february() == 29 ? 31 : 01;
      } else if (day <= 29 && day >= 26) {
        finalday = (((february()) + 3) + (day) - (27) + actualday) - mth3;
      }

      result = (february() == 29 && day >= 26)
          ? '$finalday-$apr-$resyear'
          : (february() == 30 && day >= 25)
              ? '$finalday-$apr-$resyear'
              : '$finalday-$mar-$resyear';

      print('$result');
    } else if (month == mar) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday);
      } else if (day <= 21 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday);
      } else if (day <= 26 && day >= 22) {
        finalday = ((30 - 7) + 1 + (day) - (21) + actualday);
      } else if (day <= 31 && day >= 27) {
        finalday = ((30) + (day) - (27) + actualday) - mth4;
      }
      result = (day >= 27)
          ? '$finalday-$ma-$resyear'
          : (day >= 27)
              ? '$finalday-$ma-$resyear'
              : '$finalday-$apr-$resyear';

      print('$result');
    } else if (month == apr) {
      if (day <= 7 && day >= 1) {
        finalday = ((30 - 28) + 2 + (day) + actualday);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (6) + actualday);
      } else if (day <= 21 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (13) + actualday);
      } else if (day <= 26 && day >= 22) {
        finalday = ((30 - 7) + 1 + (day) - (20) + actualday);
      } else if (day <= 30 && day >= 27) {
        finalday = ((30) + (day) - (26) + actualday) - mth5;
      }
      result = (day >= 26)
          ? '$finalday-$jun-$resyear'
          : (day >= 26)
              ? '$finalday-$jun-$resyear'
              : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == ma) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday);
      } else if (day <= 21 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday);
      } else if (day <= 26 && day >= 22) {
        finalday = ((30 - 7) + 1 + (day) - (21) + actualday);
      } else if (day <= 31 && day >= 27) {
        finalday = ((30) + (day) - (27) + actualday) - mth6;
      }
      result = (day >= 27)
          ? '$finalday-$jul-$resyear'
          : (day >= 27)
              ? '$finalday-$jul-$resyear'
              : '$finalday-$jun-$resyear';

      print('$result');
    } else if (month == jun) {
      if (day <= 7 && day >= 1) {
        finalday = ((30 - 28) + 2 + (day) + actualday);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (6) + actualday);
      } else if (day <= 21 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (13) + actualday);
      } else if (day <= 26 && day >= 22) {
        finalday = ((30 - 7) + 1 + (day) - (20) + actualday);
      } else if (day <= 30 && day >= 27) {
        finalday = ((30) + (day) - (26) + actualday) - mth7;
      }
      result = (day >= 26)
          ? '$finalday-$aug-$year'
          : (day >= 26)
              ? '$finalday-$aug-$year'
              : '$finalday-$jul-$year';

      print('$result');
    } else if (month == jul) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday);
      } else if (day <= 21 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday);
      } else if (day <= 27 && day >= 22) {
        finalday = ((30 - 7) + 1 + (day) - (21) + actualday);
      } else if (day <= 31 && day >= 28) {
        finalday = ((30) + (day) - (27) + actualday) - mth8;
      }
      result = (day >= 28)
          ? '$finalday-$sep-$resyear'
          : (day >= 28)
              ? '$finalday-$sep-$resyear'
              : '$finalday-$aug-$resyear';

      print('$result');
    } else if (month == aug) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday);
      } else if (day <= 21 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday);
      } else if (day <= 26 && day >= 22) {
        finalday = ((30 - 7) + 1 + (day) - (21) + actualday);
      } else if (day <= 31 && day >= 27) {
        finalday = ((30) + (day) - (27) + actualday) - mth9;
      }
      result = (day >= 27)
          ? '$finalday-$oct-$resyear'
          : (day >= 27)
              ? '$finalday-$oct-$resyear'
              : '$finalday-$sep-$resyear';

      print('$result');
    } else if (month == sep) {
      if (day <= 7 && day >= 1) {
        finalday = ((30 - 28) + 2 + (day) + actualday);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (6) + actualday);
      } else if (day <= 21 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (13) + actualday);
      } else if (day <= 26 && day >= 22) {
        finalday = ((30 - 7) + 1 + (day) - (20) + actualday);
      } else if (day <= 30 && day >= 27) {
        finalday = ((30) + (day) - (26) + actualday) - mth10;
      }
      result = (day >= 26)
          ? '$finalday-$nov-$resyear'
          : (day >= 26)
              ? '$finalday-$nov-$resyear'
              : '$finalday-$oct-$resyear';

      print('$result');
    } else if (month == oct) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday);
      } else if (day <= 21 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday);
      } else if (day <= 26 && day >= 22) {
        finalday = ((30 - 7) + 1 + (day) - (21) + actualday);
      } else if (day <= 31 && day >= 27) {
        finalday = ((30) + (day) - (27) + actualday) - mth11;
      }
      result = (day >= 27)
          ? '$finalday-$dec-$resyear'
          : (day >= 27)
              ? '$finalday-$dec-$resyear'
              : '$finalday-$nov-$resyear';

      print('$result');
    } else if (month == nov) {
      if (day <= 7 && day >= 1) {
        finalday = ((30 - 28) + 2 + (day) + actualday);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (6) + actualday);
      } else if (day <= 21 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (13) + actualday);
      } else if (day <= 26 && day >= 22) {
        finalday = ((30 - 7) + 1 + (day) - (20) + actualday);
      } else if (day <= 30 && day >= 27) {
        finalday = ((30) + (day) - (26) + actualday) - mth12;
      }
      newyear = resyear + 1;
      result = (day >= 26)
          ? '$finalday-$jan-$newyear'
          : (day >= 26)
              ? '$finalday-$jan-$newyear'
              : '$finalday-$dec-$resyear';

      print('$result');
    } else if (month == dec) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday);
      } else if (day <= 21 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday);
      } else if (day <= 27 && day >= 22) {
        finalday = ((30 - 7) + 1 + (day) - (21) + actualday);
      } else if (day <= 31 && day >= 27) {
        finalday = ((30) + (day) - (27) + actualday) - mth1;
      }
      newyear = resyear + 1;
      result = (day >= 27)
          ? '$finalday-$feb-$newyear'
          : (day >= 27)
              ? '$finalday-$feb-$newyear'
              : '$finalday-$jan-$newyear';

      print('$result');
    }

    newdate = result;
  }

/////////6 Week//////////
  void sixweek() {
    int actualday = 1;
    var year = int.parse(fulldate.substring(7, 10));
    month = fulldate.substring(3, 5);
    day = int.parse(fulldate.substring(0, 2));
    finalday = day;

    if (month == jan) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 7);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 7);
      } else if (day <= 17 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday + 7);
      } else if (day == 18) {
        finalday = february() == 29 ? 29 : 01;
      } else if (day <= 29 && day >= 19) {
        finalday = february() == 29
            ? (((30) + (day) - (25) + actualday) - february()) + 5
            : (((30) + (day) - (25) + 7 + actualday) - february());
      }

      result = (february() == 29 && day >= 19)
          ? '$finalday-$mar-$resyear'
          : (february() == 30 && day >= 18)
              ? '$finalday-$mar-$resyear'
              : '$finalday-$feb-$resyear';
      print('$result');
    } else if (month == feb) {
      if (day <= 7 && day >= 1) {
        finalday = ((february() - 28) + 4 + (day) + actualday + 14);
      } else if (day <= 14 && day >= 8) {
        finalday = ((february() - 17) + (day) - (7) + actualday + 7);
      } else if (day <= 17 && day >= 15) {
        finalday = ((february() - 10) + (day) - (14) + actualday + 7);
      } else if (day == 18) {
        finalday = february() == 29 ? 31 : 01;
      } else if (day <= 29 && day >= 19) {
        finalday = february() - 28 + day - 19;
      }

      result = (february() == 29 && day >= 19)
          ? '$finalday-$apr-$resyear'
          : (february() == 30 && day >= 18)
              ? '$finalday-$apr-$resyear'
              : '$finalday-$mar-$resyear';

      print('$result');
    } else if (month == mar) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 7);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 7);
      } else if (day <= 20 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday + 7);
      } else if (day == 21) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 7);
      } else if (day <= 31 && day >= 22) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 7);
      }
      result = (day >= 21)
          ? '$finalday-$ma-$resyear'
          : (day >= 21)
              ? '$finalday-$ma-$resyear'
              : '$finalday-$apr-$resyear';

      print('$result');
    } else if (month == apr) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 8);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 8);
      } else if (day <= 19 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday + 8);
      } else if (day == 20) {
        finalday = ((15 - 14) + 1 + day - 31 + 2 + actualday + 7);
      } else if (day <= 30 && day >= 21) {
        finalday = ((15 - 14) + 1 + day - 31 + 2 + actualday + 7);
      }
      result = (day >= 20)
          ? '$finalday-$jun-$resyear'
          : (day >= 20)
              ? '$finalday-$jun-$resyear'
              : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == ma) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 7);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 7);
      } else if (day <= 20 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday + 7);
      } else if (day == 21) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 7);
      } else if (day <= 31 && day >= 22) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 7);
      }
      result = (day >= 21)
          ? '$finalday-$jul-$resyear'
          : (day >= 21)
              ? '$finalday-$jul-$resyear'
              : '$finalday-$jun-$resyear';

      print('$result');
    } else if (month == jun) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 8);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 8);
      } else if (day <= 19 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday + 8);
      } else if (day == 20) {
        finalday = ((15 - 14) + 1 + day - 31 + 2 + actualday + 7);
      } else if (day <= 30 && day >= 21) {
        finalday = ((15 - 14) + 1 + day - 31 + 2 + actualday + 7);
      }
      result = (day >= 20)
          ? '$finalday-$aug-$year'
          : (day >= 20)
              ? '$finalday-$aug-$year'
              : '$finalday-$jul-$year';

      print('$result');
    } else if (month == jul) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 7);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 7);
      } else if (day <= 20 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday + 7);
      } else if (day == 21) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 7);
      } else if (day <= 31 && day >= 22) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 7);
      }
      result = (day >= 21)
          ? '$finalday-$sep-$resyear'
          : (day >= 21)
              ? '$finalday-$sep-$resyear'
              : '$finalday-$aug-$resyear';

      print('$result');
    } else if (month == aug) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 7);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 7);
      } else if (day <= 20 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday + 7);
      } else if (day == 21) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 7);
      } else if (day <= 31 && day >= 22) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 7);
      }
      result = (day >= 21)
          ? '$finalday-$oct-$resyear'
          : (day >= 21)
              ? '$finalday-$oct-$resyear'
              : '$finalday-$sep-$resyear';

      print('$result');
    } else if (month == sep) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 8);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 8);
      } else if (day <= 19 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday + 8);
      } else if (day == 20) {
        finalday = ((15 - 14) + 1 + day - 31 + 2 + actualday + 7);
      } else if (day <= 30 && day >= 21) {
        finalday = ((15 - 14) + 1 + day - 31 + 2 + actualday + 7);
      }
      result = (day >= 20)
          ? '$finalday-$nov-$resyear'
          : (day >= 20)
              ? '$finalday-$nov-$resyear'
              : '$finalday-$oct-$resyear';

      print('$result');
    } else if (month == oct) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 7);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 7);
      } else if (day <= 20 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday + 7);
      } else if (day == 21) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 7);
      } else if (day <= 31 && day >= 22) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 7);
      }
      result = (day >= 21)
          ? '$finalday-$dec-$resyear'
          : (day >= 21)
              ? '$finalday-$dec-$resyear'
              : '$finalday-$nov-$resyear';

      print('$result');
    } else if (month == nov) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 8);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 8);
      } else if (day <= 19 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday + 8);
      } else if (day == 20) {
        finalday = ((15 - 14) + 1 + day - 31 + 2 + actualday + 7);
      } else if (day <= 30 && day >= 21) {
        finalday = ((15 - 14) + 1 + day - 31 + 2 + actualday + 7);
      }
      newyear = resyear + 1;
      result = (day >= 20)
          ? '$finalday-$jan-$newyear'
          : (day >= 20)
              ? '$finalday-$jan-$newyear'
              : '$finalday-$dec-$resyear';

      print('$result');
    } else if (month == dec) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 7);
      } else if (day <= 14 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 7);
      } else if (day <= 20 && day >= 15) {
        finalday = ((30 - 14) + 1 + (day) - (14) + actualday + 7);
      } else if (day == 21) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 7);
      } else if (day <= 31 && day >= 22) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 7);
      }
      newyear = resyear + 1;
      result = (day >= 21)
          ? '$finalday-$feb-$newyear'
          : (day >= 21)
              ? '$finalday-$feb-$newyear'
              : '$finalday-$jan-$newyear';

      print('$result');
    }

    newdate = result;
  }

/////////7 Week//////////////////
  void sevenweek() {
    int actualday = 1;
    var year = int.parse(fulldate.substring(7, 10));
    month = fulldate.substring(3, 5);
    day = int.parse(fulldate.substring(0, 2));
    finalday = day;

    if (month == jan) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 14);
      } else if (day <= 10 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 14);
      } else if (day == 11) {
        finalday = february() == 29 ? 29 : 01;
      } else if (day <= 31 && day >= 12) {
        finalday = february() == 29
            ? ((-14) + 1 + (day) - (13) + actualday + 14)
            : ((-12) + 1 + (day) - (14) + actualday + 14);
      }

      result = (february() == 29 && day >= 12)
          ? '$finalday-$mar-$resyear'
          : (february() == 30 && day >= 11)
              ? '$finalday-$mar-$resyear'
              : '$finalday-$feb-$resyear';
      print('$result');
    } else if (month == feb) {
      if (day <= 4 && day >= 1) {
        finalday = ((february() - 28) + 4 + (day) + actualday + 21);
      } else if (day <= 29 && day >= 5) {
        finalday = ((february()) + (day) - (41) + actualday + 7);
      }

      result = (february() == 29 && day >= 5)
          ? '$finalday-$apr-$resyear'
          : (february() == 30 && day >= 18)
              ? '$finalday-$apr-$resyear'
              : '$finalday-$mar-$resyear';

      print('$result');
    } else if (month == mar) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 14);
      } else if (day <= 12 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 14);
      } else if (day == 13) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 15);
      } else if (day <= 31 && day >= 14) {
        finalday = ((-14) + 1 + (day) - (14) + actualday + 14);
      }
      result = (day >= 13)
          ? '$finalday-$ma-$resyear'
          : (day >= 13)
              ? '$finalday-$ma-$resyear'
              : '$finalday-$apr-$resyear';

      print('$result');
    } else if (month == apr) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 15);
      } else if (day <= 12 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 15);
      } else if (day == 13) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 15);
      } else if (day <= 31 && day >= 13) {
        finalday = ((-14) + 1 + (day) - (14) + actualday + 14);
      }
      result = (day >= 13)
          ? '$finalday-$jun-$resyear'
          : (day >= 13)
              ? '$finalday-$jun-$resyear'
              : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == ma) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 14);
      } else if (day <= 12 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 14);
      } else if (day == 13) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 15);
      } else if (day <= 31 && day >= 14) {
        finalday = ((-14) + 1 + (day) - (14) + actualday + 14);
      }
      result = (day >= 13)
          ? '$finalday-$jul-$resyear'
          : (day >= 13)
              ? '$finalday-$jul-$resyear'
              : '$finalday-$jun-$resyear';

      print('$result');
    } else if (month == jun) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 15);
      } else if (day <= 12 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 15);
      } else if (day == 13) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 15);
      } else if (day <= 31 && day >= 14) {
        finalday = ((-14) + 1 + (day) - (14) + actualday + 14);
      }
      result = (day >= 13)
          ? '$finalday-$aug-$year'
          : (day >= 13)
              ? '$finalday-$aug-$year'
              : '$finalday-$jul-$year';

      print('$result');
    } else if (month == jul) {
      if (day <= 13 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 14);
      } else if (day <= 31 && day >= 14) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 14);
      }
      result = (day >= 14)
          ? '$finalday-$sep-$resyear'
          : (day >= 14)
              ? '$finalday-$sep-$resyear'
              : '$finalday-$aug-$resyear';

      print('$result');
    } else if (month == aug) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 14);
      } else if (day <= 12 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 14);
      } else if (day == 13) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 15);
      } else if (day <= 31 && day >= 14) {
        finalday = ((-14) + 1 + (day) - (14) + actualday + 14);
      }
      result = (day >= 13)
          ? '$finalday-$oct-$resyear'
          : (day >= 13)
              ? '$finalday-$oct-$resyear'
              : '$finalday-$sep-$resyear';

      print('$result');
    } else if (month == sep) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 15);
      } else if (day <= 13 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 14);
      } else if (day == 14) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 14);
      } else if (day <= 31 && day >= 15) {
        finalday = ((-14) + 1 + (day) - (14) + actualday + 13);
      }
      result = (day >= 14)
          ? '$finalday-$nov-$resyear'
          : (day >= 14)
              ? '$finalday-$nov-$resyear'
              : '$finalday-$oct-$resyear';

      print('$result');
    } else if (month == oct) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 14);
      } else if (day <= 12 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 14);
      } else if (day == 13) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 15);
      } else if (day <= 31 && day >= 14) {
        finalday = ((-14) + 1 + (day) - (14) + actualday + 14);
      }
      result = (day >= 13)
          ? '$finalday-$dec-$resyear'
          : (day >= 13)
              ? '$finalday-$dec-$resyear'
              : '$finalday-$nov-$resyear';

      print('$result');
    } else if (month == nov) {
      newyear = resyear + 1;

      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 15);
      } else if (day <= 12 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 15);
      } else if (day == 13) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 15);
      } else if (day <= 31 && day >= 14) {
        finalday = ((-14) + 1 + (day) - (14) + actualday + 14);
      }
      result = (day >= 13)
          ? '$finalday-$jan-$newyear'
          : (day >= 13)
              ? '$finalday-$jan-$newyear'
              : '$finalday-$dec-$resyear';

      print('$result');
    } else if (month == dec) {
      if (day <= 7 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 14);
      } else if (day <= 12 && day >= 8) {
        finalday = ((30 - 21) + 1 + (day) - (7) + actualday + 14);
      } else if (day == 13) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 15);
      } else if (day <= 31 && day >= 14) {
        finalday = ((-14) + 1 + (day) - (14) + actualday + 14);
      }
      newyear = resyear + 1;
      result = (day >= 13)
          ? '$finalday-$feb-$newyear'
          : (day >= 13)
              ? '$finalday-$feb-$newyear'
              : '$finalday-$jan-$newyear';

      print('$result');
    }

    newdate = result;
  }

////////8 Weeks//////////
  void eightweek() {
    int actualday = 1;
    var year = int.parse(fulldate.substring(7, 10));
    month = fulldate.substring(3, 5);
    day = int.parse(fulldate.substring(0, 2));
    finalday = day;

    if (month == jan) {
      if (day <= 3 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 21);
      } else if (day == 4) {
        finalday = february() == 29 ? 29 : 01;
      } else if (day <= 31 && day >= 5) {
        finalday = february() == 29
            ? ((-14) + 1 + (day) - (13) + actualday + 21)
            : ((-12) + 1 + (day) - (14) + actualday + 21);
      }
      result = (february() == 29 && day >= 5)
          ? '$finalday-$mar-$resyear'
          : (february() == 30 && day >= 4)
              ? '$finalday-$mar-$resyear'
              : '$finalday-$feb-$resyear';
      print('$result');
    } else if (month == feb) {
      if (day <= 3 && day >= 1) {
        finalday = ((february() - 28) + 4 + (day) + actualday + 21);
      } else if (day == 4) {
        finalday = february() == 29 ? 31 : 01;
      } else if (day <= 29 && day >= 5) {
        finalday = ((february() - 17) + (day) - (17) + actualday);
      }

      result = (february() == 29 && day >= 5)
          ? '$finalday-$apr-$resyear'
          : (february() == 30 && day >= 4)
              ? '$finalday-$apr-$resyear'
              : '$finalday-$mar-$resyear';

      print('$result');
    } else if (month == mar) {
      if (day <= 5 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 21);
      } else if (day == 6) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 22);
      } else if (day <= 31 && day >= 7) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 21);
      }
      result = (day >= 6)
          ? '$finalday-$ma-$resyear'
          : (day >= 6)
              ? '$finalday-$ma-$resyear'
              : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == apr) {
      if (day <= 5 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 22);
      } else if (day == 6) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 22);
      } else if (day <= 31 && day >= 7) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 21);
      }
      result = (day >= 6)
          ? '$finalday-$jun-$resyear'
          : (day >= 6)
              ? '$finalday-$jun-$resyear'
              : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == ma) {
      if (day <= 5 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 21);
      } else if (day == 6) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 22);
      } else if (day <= 31 && day >= 7) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 21);
      }
      result = (day >= 6)
          ? '$finalday-$jul-$resyear'
          : (day >= 6)
              ? '$finalday-$jul-$resyear'
              : '$finalday-$jun-$resyear';

      print('$result');
    } else if (month == jun) {
      if (day <= 5 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 22);
      } else if (day == 6) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 22);
      } else if (day <= 31 && day >= 7) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 21);
      }
      result = (day >= 6)
          ? '$finalday-$aug-$year'
          : (day >= 6)
              ? '$finalday-$aug-$year'
              : '$finalday-$jul-$year';

      print('$result');
    } else if (month == jul) {
      if (day <= 5 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 21);
      } else if (day == 6) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 22);
      } else if (day <= 31 && day >= 7) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 21);
      }
      result = (day >= 6)
          ? '$finalday-$sep-$resyear'
          : (day >= 6)
              ? '$finalday-$sep-$resyear'
              : '$finalday-$aug-$resyear';

      print('$result');
    } else if (month == aug) {
      if (day <= 5 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 21);
      } else if (day == 6) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 22);
      } else if (day <= 31 && day >= 7) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 21);
      }
      result = (day >= 6)
          ? '$finalday-$oct-$resyear'
          : (day >= 6)
              ? '$finalday-$oct-$resyear'
              : '$finalday-$sep-$resyear';

      print('$result');
    } else if (month == sep) {
      if (day <= 5 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 22);
      } else if (day == 6) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 22);
      } else if (day <= 31 && day >= 7) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 21);
      }
      result = (day >= 6)
          ? '$finalday-$nov-$resyear'
          : (day >= 6)
              ? '$finalday-$nov-$resyear'
              : '$finalday-$oct-$resyear';

      print('$result');
    } else if (month == oct) {
      if (day <= 5 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 21);
      } else if (day == 6) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 22);
      } else if (day <= 31 && day >= 7) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 21);
      }
      result = (day >= 6)
          ? '$finalday-$dec-$resyear'
          : (day >= 6)
              ? '$finalday-$dec-$resyear'
              : '$finalday-$nov-$resyear';

      print('$result');
    } else if (month == nov) {
      if (day <= 5 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 22);
      } else if (day == 6) {
        finalday = ((15 - 14) + 1 + day - 31 + 1 + actualday + 22);
      } else if (day <= 31 && day >= 7) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 21);
      }
      newyear = resyear + 1;
      result = (day >= 6)
          ? '$finalday-$jan-$newyear'
          : (day >= 6)
              ? '$finalday-$jan-$newyear'
              : '$finalday-$dec-$resyear';

      print('$result');
    } else if (month == dec) {
      if (day <= 6 && day >= 1) {
        finalday = ((31 - 28) + (day) + actualday + 21);
      } else if (day == 7) {
        finalday = ((15 - 14) + day - 31 + 1 + actualday + 22);
      } else if (day <= 31 && day >= 8) {
        finalday = ((-21) + (day) - (7) + actualday + 21);
      }
      newyear = resyear + 1;
      result = (day >= 7)
          ? '$finalday-$feb-$newyear'
          : (day >= 7)
              ? '$finalday-$feb-$newyear'
              : '$finalday-$jan-$newyear';

      print('$result');
    }

    newdate = result;
  }

//////////9 Weeks////////////
  void nineweek() {
    int actualday = 1;
    var year = int.parse(fulldate.substring(7, 10));
    month = fulldate.substring(3, 5);
    day = int.parse(fulldate.substring(0, 2));
    finalday = day;

    if (month == jan) {
      if (day <= 28 && day >= 1) {
        finalday = ((-20) + 1 + (day) - (7) + actualday + 28);
      } else if (february() == 29 && day == 28) {
        finalday = 29;
      } else if (february() == 30 && day == 28) {
        finalday = 01;
      } else if (day <= 31 && day >= 29) {
        finalday = (february() == 29)
            ? (february() - 26) + day - mth3
            : (february() - 27) + day - mth3;
      }
      result = (february() == 29 && day >= 29)
          ? '$finalday-$apr-$resyear'
          : (february() == 30 && day >= 29)
              ? '$finalday-$apr-$resyear'
              : '$finalday-$mar-$resyear';
      print('$result');
    } else if (month == feb) {
      if (day <= 3 && day >= 1) {
        finalday = ((february() - 28) + 4 + (day) + actualday + 21);
      } else if (day == 4) {
        finalday = february() == 29 ? 31 : 01;
      } else if (day <= 29 && day >= 5) {
        finalday = ((february() - 17) + (day) - (17) + actualday);
      }

      result = (february() == 29 && day >= 5)
          ? '$finalday-$apr-$resyear'
          : (february() == 30 && day >= 4)
              ? '$finalday-$apr-$resyear'
              : '$finalday-$mar-$resyear';

      print('$result');
    } else if (month == mar) {
      if (day <= 29 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 28);
      } else if (day <= 31 && day >= 30) {
        finalday = (2) + day - mth3;
      }
      result = (day >= 30)
          ? '$finalday-$jun-$resyear'
          : (day >= 30)
              ? '$finalday-$jun-$resyear'
              : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == apr) {
      if (day <= 28 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 28);
      } else if (day <= 31 && day >= 29) {
        finalday = (3) + day - mth3;
      }
      result = (day >= 29)
          ? '$finalday-$jul-$resyear'
          : (day >= 29)
              ? '$finalday-$jul-$resyear'
              : '$finalday-$jun-$resyear';

      print('$result');
    } else if (month == ma) {
      if (day <= 29 && day >= 1) {
        finalday = ((1 - 28) + (day) + actualday + 28);
      } else if (day <= 31 && day >= 30) {
        finalday = (2) + day - mth3;
      }
      result = (day >= 30)
          ? '$finalday-$aug-$resyear'
          : (day >= 30)
              ? '$finalday-$aug-$resyear'
              : '$finalday-$jul-$resyear';

      print('$result');
    } else if (month == jun) {
      if (day <= 29 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 28);
      } else if (day <= 31 && day >= 30) {
        finalday = (2) + day - mth3;
      }
      result = (day >= 29)
          ? '$finalday-$sep-$year'
          : (day >= 29)
              ? '$finalday-$sep-$year'
              : '$finalday-$aug-$year';

      print('$result');
    } else if (month == jul) {
      if (day <= 29 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 27);
      } else if (day <= 31 && day >= 30) {
        finalday = (2) + day - mth3;
      }
      result = (day >= 30)
          ? '$finalday-$oct-$resyear'
          : (day >= 30)
              ? '$finalday-$oct-$resyear'
              : '$finalday-$sep-$resyear';

      print('$result');
    } else if (month == aug) {
      if (day <= 29 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 28);
      } else if (day <= 31 && day >= 30) {
        finalday = (2) + day - mth3;
      }
      result = (day >= 30)
          ? '$finalday-$nov-$resyear'
          : (day >= 30)
              ? '$finalday-$nov-$resyear'
              : '$finalday-$oct-$resyear';

      print('$result');
    } else if (month == sep) {
      if (day <= 28 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 28);
      } else if (day <= 31 && day >= 29) {
        finalday = (3) + day - mth3;
      }
      result = (day >= 29)
          ? '$finalday-$dec-$resyear'
          : (day >= 29)
              ? '$finalday-$dec-$resyear'
              : '$finalday-$nov-$resyear';

      print('$result');
    } else if (month == oct) {
      newyear = resyear + 1;
      if (day <= 29 && day >= 1) {
        finalday = ((-21) + 2 + (day) - (7) + actualday + 27);
      } else if (day <= 31 && day >= 30) {
        finalday = (2) + day - mth3;
      }
      result = (day >= 30)
          ? '$finalday-$jan-$newyear'
          : (day >= 30)
              ? '$finalday-$jan-$newyear'
              : '$finalday-$dec-$resyear';

      print('$result');
    } else if (month == nov) {
      newyear = resyear + 1;
      if (day <= 29 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 28);
      } else if (day <= 31 && day >= 30) {
        finalday = (2) + day - mth3;
      }

      result = (day >= 30)
          ? '$finalday-$feb-$newyear'
          : (day >= 30)
              ? '$finalday-$feb-$resyear'
              : '$finalday-$jan-$newyear';

      print('$result');
    } else if (month == dec) {
      newyear = resyear + 1;
      if (day <= 27 && day >= 1) {
        finalday = ((-22) + 1 + (day) - (7) + actualday + 28);
      } else if (newyearleap() == 30 && day == 28) {
        finalday = 01;
      } else if (newyearleap() == 29 && day == 28) {
        finalday = 29;
      } else if (day <= 31 && day >= 29) {
        finalday = (newyearleap() - 26) + day - mth3;
      }
      newyear = resyear + 1;
      result = (day >= 29 && newyearleap() == 29)
          ? '$finalday-$mar-$newyear'
          : (day >= 28 && newyearleap() == 30)
              ? '$finalday-$mar-$newyear'
              : '$finalday-$feb-$newyear';

      print('$result');
    }

    newdate = result;
  }

/////////10 Week//////////////////
  void tenweek() {
    int actualday = 1;
    var year = int.parse(fulldate.substring(7, 10));
    month = fulldate.substring(3, 5);
    day = int.parse(fulldate.substring(0, 2));
    finalday = day;

    if (month == jan) {
      if (day <= 20 && day >= 1) {
        finalday = ((-20) + 1 + (day) - (7) + actualday + 35);
      } else if (day <= 31 && day >= 21) {
        finalday = (february() == 29)
            ? (february() - 26) + 8 + day - mth3
            : (february() - 27) + 8 + day - mth3;
      }
      result = (february() == 29 && day >= 21)
          ? '$finalday-$mar-$resyear'
          : (february() == 30 && day >= 15)
              ? '$finalday-$mar-$resyear'
              : '$finalday-$feb-$resyear';
      print('$result');
    } else if (month == feb) {
      if (day <= 19 && day >= 1) {
        finalday = (february() == 29)
            ? ((february() - 28) + 2 + (day) + actualday + 46) - 40
            : ((february() - 28) + 3 + (day) + actualday + 45) - 40;
      } else if (day == 20) {
        finalday = (february() == 29) ? (30) : (01);
      } else if (day <= 29 && day >= 21) {
        finalday = (february() == 29
            ? ((february() - 17) + (day) - (33) + actualday)
            : ((february() - 24) + (day) - (26) + actualday));
      }

      result = (february() == 29 && day >= 14)
          ? '$finalday-$apr-$resyear'
          : (february() == 30 && day >= 13)
              ? '$finalday-$apr-$resyear'
              : '$finalday-$mar-$resyear';

      print('$result');
    } else if (month == mar) {
      if (day <= 22 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 35);
      } else if (day <= 31 && day >= 23) {
        finalday = (9) + day - mth3;
      }
      result = (day >= 23)
          ? '$finalday-$jun-$resyear'
          : (day >= 23)
              ? '$finalday-$jun-$resyear'
              : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == apr) {
      if (day <= 21 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (14) + actualday + 42);
      } else if (day <= 31 && day >= 22) {
        finalday = (10) + day - mth3;
      }
      result = (day >= 22)
          ? '$finalday-$jul-$resyear'
          : (day >= 22)
              ? '$finalday-$jul-$resyear'
              : '$finalday-$jun-$resyear';

      print('$result');
    } else if (month == ma) {
      if (day <= 22 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 35);
      } else if (day <= 31 && day >= 23) {
        finalday = (9) + day - mth3;
      }
      result = (day >= 23)
          ? '$finalday-$aug-$resyear'
          : (day >= 23)
              ? '$finalday-$aug-$resyear'
              : '$finalday-$jul-$resyear';

      print('$result');
    } else if (month == jun) {
      if (day <= 22 && day >= 1) {
        finalday = ((-21) + 2 + (day) - (7) + actualday + 34);
      } else if (day <= 31 && day >= 23) {
        finalday = (9) + day - mth3;
      }
      result = (day >= 23)
          ? '$finalday-$sep-$year'
          : (day >= 23)
              ? '$finalday-$sep-$year'
              : '$finalday-$aug-$year';

      print('$result');
    } else if (month == jul) {
      if (day <= 22 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 34);
      } else if (day <= 31 && day >= 23) {
        finalday = (9) + day - mth3;
      }
      result = (day >= 23)
          ? '$finalday-$oct-$resyear'
          : (day >= 23)
              ? '$finalday-$oct-$resyear'
              : '$finalday-$sep-$resyear';

      print('$result');
    } else if (month == aug) {
      if (day <= 22 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 35);
      } else if (day <= 31 && day >= 23) {
        finalday = (9) + day - mth3;
      }
      result = (day >= 23)
          ? '$finalday-$nov-$resyear'
          : (day >= 23)
              ? '$finalday-$nov-$resyear'
              : '$finalday-$oct-$resyear';

      print('$result');
    } else if (month == sep) {
      if (day <= 21 && day >= 1) {
        finalday = ((-21) + 2 + (day) - (7) + actualday + 34);
      } else if (day <= 31 && day >= 22) {
        finalday = (10) + day - mth3;
      }
      result = (day >= 22)
          ? '$finalday-$dec-$resyear'
          : (day >= 23)
              ? '$finalday-$dec-$resyear'
              : '$finalday-$nov-$resyear';

      print('$result');
    } else if (month == oct) {
      newyear = resyear + 1;
      if (day <= 22 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 35);
      } else if (day <= 31 && day >= 23) {
        finalday = (9) + day - mth3;
      }
      result = (day >= 23)
          ? '$finalday-$jan-$newyear'
          : (day >= 23)
              ? '$finalday-$jan-$newyear'
              : '$finalday-$dec-$resyear';

      print('$result');
    } else if (month == nov) {
      newyear = resyear + 1;
      if (day <= 22 && day >= 1) {
        finalday = ((-21) + 1 + (day) - 14 + actualday + 42);
      } else if (day <= 31 && day >= 23) {
        finalday = (-21) + newyearleap() + day - mth3;
      }
      result = (day >= 23)
          ? '$finalday-$feb-$newyear'
          : (day >= 23)
              ? '$finalday-$feb-$resyear'
              : '$finalday-$jan-$newyear';

      print('$result');
    } else if (month == dec) {
      newyear = resyear + 1;
      if (day <= 20 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (14) + actualday + 41);
      } else if (newyearleap() == 30 && day == 21) {
        finalday = 01;
      } else if (newyearleap() == 29 && day == 21) {
        finalday = 29;
      } else if (day <= 31 && day >= 22) {
        finalday = (-19) + newyearleap() + day - mth3;
      }

      result = (day >= 22 && newyearleap() == 29)
          ? '$finalday-$mar-$newyear'
          : (day >= 21 && newyearleap() == 30)
              ? '$finalday-$mar-$newyear'
              : '$finalday-$feb-$newyear';

      print('$result');
    }

    newdate = result;
  }

///////////11 Week////////////
  void elevenweek() {
    int actualday = 1;
    var year = int.parse(fulldate.substring(7, 10));
    month = fulldate.substring(3, 5);
    day = int.parse(fulldate.substring(0, 2));
    finalday = day;

    if (month == jan) {
      if (day <= 14 && day >= 1) {
        finalday = ((-20) + 1 + (day) - (7) + actualday + 42);
      } else if (day <= 31 && day >= 15) {
        finalday = (february() == 29)
            ? (february() - 26) + 14 + day - mth3
            : (february() - 27) + 14 + day - mth3;
      }
      result = (february() == 29 && day >= 15)
          ? '$finalday-$apr-$resyear'
          : (february() == 30 && day >= 15)
              ? '$finalday-$apr-$resyear'
              : '$finalday-$mar-$resyear';
      print('$result');
    } else if (month == feb) {
      if (day <= 13 && day >= 1) {
        finalday = (february() == 29)
            ? ((february() - 28) + 3 + (day) + actualday + 46) - 34
            : ((february() - 28) + 5 + (day) + actualday + 45) - 35;
      } else if (day == 13) {
        finalday = (february() == 29) ? (31) : (01);
      } else if (day <= 29 && day >= 13) {
        finalday = (february() == 29
            ? ((february() - 17) + (day) - (26) + actualday)
            : ((february() - 18) + (day) - (26) + actualday));
      }

      result = (february() == 29 && day >= 14)
          ? '$finalday-$ma-$resyear'
          : (february() == 30 && day >= 13)
              ? '$finalday-$ma-$resyear'
              : '$finalday-$apr-$resyear';

      print('$result');
    } else if (month == mar) {
      if (day <= 15 && day >= 1) {
        finalday = ((-21) + 1 + (day) + actualday + 35);
      } else if (day <= 31 && day >= 16) {
        finalday = (16) + day - mth3;
      }
      result = (day >= 16)
          ? '$finalday-$jun-$resyear'
          : (day >= 16)
              ? '$finalday-$jun-$resyear'
              : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == apr) {
      if (day <= 14 && day >= 1) {
        finalday = ((-21) + 1 - 7 + (day) + actualday + 42);
      } else if (day <= 31 && day >= 14) {
        finalday = (17) + day - mth3;
      }
      result = (day >= 15)
          ? '$finalday-$jul-$resyear'
          : (day >= 15)
              ? '$finalday-$jul-$resyear'
              : '$finalday-$jun-$resyear';

      print('$result');
    } else if (month == ma) {
      if (day <= 15 && day >= 1) {
        finalday = ((-21) + 1 + (day) + actualday + 35);
      } else if (day <= 31 && day >= 16) {
        finalday = (16) + day - mth3;
      }
      result = (day >= 16)
          ? '$finalday-$aug-$resyear'
          : (day >= 16)
              ? '$finalday-$aug-$resyear'
              : '$finalday-$jul-$resyear';

      print('$result');
    } else if (month == jun) {
      if (day <= 15 && day >= 1) {
        finalday = ((-21) + 2 + (day) - (7) + actualday + 41);
      } else if (day <= 31 && day >= 15) {
        finalday = (16) + day - mth3;
      }
      result = (day >= 16)
          ? '$finalday-$sep-$year'
          : (day >= 16)
              ? '$finalday-$sep-$year'
              : '$finalday-$aug-$year';

      print('$result');
    } else if (month == jul) {
      if (day <= 15 && day >= 1) {
        finalday = ((-21) + (day) + actualday + 35);
      } else if (day <= 31 && day >= 16) {
        finalday = (16) + day - mth3;
      }
      result = (day >= 16)
          ? '$finalday-$oct-$resyear'
          : (day >= 16)
              ? '$finalday-$oct-$resyear'
              : '$finalday-$sep-$resyear';

      print('$result');
    } else if (month == aug) {
      if (day <= 15 && day >= 1) {
        finalday = ((-21) + 1 + (day) + actualday + 35);
      } else if (day <= 31 && day >= 16) {
        finalday = (16) + day - mth3;
      }
      result = (day >= 16)
          ? '$finalday-$nov-$resyear'
          : (day >= 16)
              ? '$finalday-$nov-$resyear'
              : '$finalday-$oct-$resyear';

      print('$result');
    } else if (month == sep) {
      if (day <= 14 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 42);
      } else if (day <= 31 && day >= 14) {
        finalday = (17) + day - mth3;
      }
      result = (day >= 15)
          ? '$finalday-$dec-$resyear'
          : (day >= 15)
              ? '$finalday-$dec-$resyear'
              : '$finalday-$nov-$resyear';

      print('$result');
    } else if (month == oct) {
      newyear = resyear + 1;
      if (day <= 15 && day >= 1) {
        finalday = ((-21) + 1 + (day) + actualday + 35);
      } else if (day <= 31 && day >= 16) {
        finalday = (16) + day - mth3;
      }
      result = (day >= 16)
          ? '$finalday-$jan-$newyear'
          : (day >= 16)
              ? '$finalday-$jan-$newyear'
              : '$finalday-$dec-$resyear';

      print('$result');
    } else if (month == nov) {
      newyear = resyear + 1;
      if (day <= 15 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 42);
      } else if (day <= 31 && day >= 16) {
        finalday = (-14) + newyearleap() + day - mth3;
      }
      result = (day >= 16)
          ? '$finalday-$feb-$newyear'
          : (day >= 16)
              ? '$finalday-$feb-$resyear'
              : '$finalday-$jan-$newyear';

      print('$result');
    } else if (month == dec) {
      newyear = resyear + 1;
      if (day <= 13 && day >= 1) {
        finalday = ((-21) + 1 + (day) - (7) + actualday + 41);
      } else if (newyearleap() == 30 && day == 14) {
        finalday = 01;
      } else if (newyearleap() == 29 && day == 14) {
        finalday = 29;
      } else if (day <= 31 && day >= 15) {
        finalday = (-12) + newyearleap() + day - mth3;
      }

      result = (day >= 15 && newyearleap() == 29)
          ? '$finalday-$mar-$newyear'
          : (day >= 14 && newyearleap() == 30)
              ? '$finalday-$mar-$newyear'
              : '$finalday-$feb-$newyear';

      print('$result');
    }

    newdate = result;
  }

//////////12 Weeks/////////
  void twelveweek() {
    int actualday = 1;
    var year = int.parse(fulldate.substring(7, 10));
    month = fulldate.substring(3, 5);
    day = int.parse(fulldate.substring(0, 2));
    finalday = day;

    if (month == jan) {
      if (day <= 7 && day >= 1) {
        finalday = ((-20) + 1 + (day) + actualday + 42);
      } else if (day <= 31 && day >= 8) {
        finalday = (february() == 29)
            ? (february() - 26) + 21 + day - mth3
            : (february() - 27) + 21 + day - mth3;
      }
      result = (february() == 29 && day >= 8)
          ? '$finalday-$apr-$resyear'
          : (february() == 30 && day >= 8)
              ? '$finalday-$apr-$resyear'
              : '$finalday-$mar-$resyear';
      print('$result');
    } else if (month == feb) {
      if (day <= 5 && day >= 1) {
        finalday = (february() == 29)
            ? ((february() - 28) + 10 + (day) + actualday + 46) - 34
            : ((february() - 28) + 12 + (day) + actualday + 45) - 35;
      } else if (day == 6) {
        finalday = (february() == 29) ? (30) : (01);
      } else if (day <= 29 && day >= 7) {
        finalday = (february() == 29
            ? ((february() - 10) + (day) - (26) + actualday)
            : ((february() - 10) + (day) - (26) + actualday));
      }

      result = (february() == 29 && day >= 7)
          ? '$finalday-$ma-$resyear'
          : (february() == 30 && day >= 6)
              ? '$finalday-$ma-$resyear'
              : '$finalday-$apr-$resyear';

      print('$result');
    } else if (month == mar) {
      if (day <= 8 && day >= 1) {
        finalday = ((-14) + 1 + (day) + actualday + 35);
      } else if (day <= 31 && day >= 9) {
        finalday = (23) + day - mth3;
      }
      result = (day >= 9)
          ? '$finalday-$jun-$resyear'
          : (day >= 9)
              ? '$finalday-$jun-$resyear'
              : '$finalday-$ma-$resyear';

      print('$result');
    } else if (month == apr) {
      if (day <= 7 && day >= 1) {
        finalday = ((-21) + 1 + (day) + actualday + 42);
      } else if (day <= 31 && day >= 8) {
        finalday = (24) + day - mth3;
      }
      result = (day >= 8)
          ? '$finalday-$jul-$resyear'
          : (day >= 8)
              ? '$finalday-$jul-$resyear'
              : '$finalday-$jun-$resyear';

      print('$result');
    } else if (month == ma) {
      if (day <= 8 && day >= 1) {
        finalday = ((-21) + 1 + (day) + 7 + actualday + 35);
      } else if (day <= 31 && day >= 9) {
        finalday = (23) + day - mth3;
      }
      result = (day >= 9)
          ? '$finalday-$aug-$resyear'
          : (day >= 9)
              ? '$finalday-$aug-$resyear'
              : '$finalday-$jul-$resyear';

      print('$result');
    } else if (month == jun) {
      if (day <= 8 && day >= 1) {
        finalday = ((-21) + 2 + (day) + actualday + 41);
      } else if (day <= 31 && day >= 9) {
        finalday = (23) + day - mth3;
      }
      result = (day >= 9)
          ? '$finalday-$sep-$year'
          : (day >= 9)
              ? '$finalday-$sep-$year'
              : '$finalday-$aug-$year';

      print('$result');
    } else if (month == jul) {
      if (day <= 9 && day >= 1) {
        finalday = ((-21) + (day) + actualday + 42);
      } else if (day <= 31 && day >= 10) {
        finalday = (22) + day - mth3;
      }
      result = (day >= 10)
          ? '$finalday-$oct-$resyear'
          : (day >= 10)
              ? '$finalday-$oct-$resyear'
              : '$finalday-$sep-$resyear';

      print('$result');
    } else if (month == aug) {
      if (day <= 8 && day >= 1) {
        finalday = ((-21) + 1 + (day) + actualday + 42);
      } else if (day <= 31 && day >= 9) {
        finalday = (23) + day - mth3;
      }
      result = (day >= 10)
          ? '$finalday-$nov-$resyear'
          : (day >= 9)
              ? '$finalday-$nov-$resyear'
              : '$finalday-$oct-$resyear';

      print('$result');
    } else if (month == sep) {
      if (day <= 7 && day >= 1) {
        finalday = ((-21) + 1 + (day) + actualday + 42);
      } else if (day <= 31 && day >= 8) {
        finalday = (24) + day - mth3;
      }
      result = (day >= 8)
          ? '$finalday-$dec-$resyear'
          : (day >= 8)
              ? '$finalday-$dec-$resyear'
              : '$finalday-$nov-$resyear';

      print('$result');
    } else if (month == oct) {
      newyear = resyear + 1;
      if (day <= 8 && day >= 1) {
        finalday = ((-21) + 1 + (day) + actualday + 42);
      } else if (day <= 31 && day >= 9) {
        finalday = (23) + day - mth3;
      }
      result = (day >= 9)
          ? '$finalday-$jan-$newyear'
          : (day >= 9)
              ? '$finalday-$jan-$newyear'
              : '$finalday-$dec-$resyear';

      print('$result');
    } else if (month == nov) {
      newyear = resyear + 1;
      if (day <= 8 && day >= 1) {
        finalday = ((-21) + 1 + (day) + actualday + 42);
      } else if (day <= 31 && day >= 9) {
        finalday = (-7) + newyearleap() + day - mth3;
      }
      result = (day >= 9)
          ? '$finalday-$feb-$newyear'
          : (day >= 9)
              ? '$finalday-$feb-$newyear'
              : '$finalday-$jan-$newyear';

      print('$result');
    } else if (month == dec) {
      newyear = resyear + 1;
      if (day <= 6 && day >= 1) {
        finalday = ((-21) + 1 + (day) + actualday + 41);
      } else if (newyearleap() == 30 && day == 7) {
        finalday = 01;
      } else if (newyearleap() == 29 && day == 7) {
        finalday = 29;
      } else if (day <= 31 && day >= 8) {
        finalday = (-5) + newyearleap() + day - mth3;
      }

      result = (day >= 8 && newyearleap() == 29)
          ? '$finalday-$mar-$newyear'
          : (day >= 7 && newyearleap() == 30)
              ? '$finalday-$mar-$newyear'
              : '$finalday-$feb-$newyear';

      print('$result');
    }

    newdate = result;
  }
}
