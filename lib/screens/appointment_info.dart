import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:daniellesdoggrooming/database/database_logic.dart';
import 'package:daniellesdoggrooming/screens/appointments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class AppointmentInfo extends StatefulWidget {
  static const String id = 'appointmentinfo';

  @override
  _AppointmentInfoState createState() => _AppointmentInfoState();
}

class _AppointmentInfoState extends State<AppointmentInfo>
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
  }



  fetchID() async{

    // get a reference to the database
    Database db = await DatabaseHelper.instance.database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseHelper.columnId,
      DatabaseHelper.columnDogUniqueId,
      DatabaseHelper.columnDogName,
      DatabaseHelper.columnName,
      DatabaseHelper.columnScheduleDate,
      DatabaseHelper.columnScheduleTime,
      DatabaseHelper.columnAge,
      DatabaseHelper.columnPicture,

    ];
    String whereString = '${DatabaseHelper.columnDogUniqueId} = "${dogUniqueID}"';
    int rowId = 2;
    List<dynamic> whereArguments = [rowId];
    List<Map> result = await db.query(
        DatabaseHelper.table,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);

    print(result);

    indexID = result[0]['_id'];
    print ('This is the $indexID number');

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: previewImage == null
                                      ? CircleAvatar(
                                          backgroundImage: AssetImage(
                                              data[ID]['picture']),
                                          backgroundColor: Colors.transparent,
                                          radius: appConfigblockSizeWidth * 10,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                          AssetImage(data[ID]["picture"]),
                                          backgroundColor: Colors.transparent,
                                          radius: appConfigblockSizeWidth * 10,
                                        ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        data[ID]["dog_name"],
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(34, 36, 86, 1),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 25),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            (data[ID]["age"]).toString(),
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(34, 36, 86, 1),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            ' years old',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(34, 36, 86, 1),
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "This beautiful ",
                              style: TextStyle(
                                color: Color.fromRGBO(34, 36, 86, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "doggo",
                              style: TextStyle(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              " belongs to...",
                              style: TextStyle(
                                color: Color.fromRGBO(34, 36, 86, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 1,
                        ),
                        Container(
                          child: Text(
                            data[ID]["owner_name"],
                            style: TextStyle(
                              color: Color.fromRGBO(34, 36, 86, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: appConfigblockSizeHeight * 5,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        data[ID]["dog_name"],
                                        style: TextStyle(
                                          color: Color.fromRGBO(34, 36, 86, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        " is scheduled",
                                        style: TextStyle(
                                          color: Color.fromRGBO(34, 36, 86, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [Text(
                                    "to be groomed on",
                                    style: TextStyle(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),],),
                                  SizedBox(height: appConfigblockSizeHeight * 3,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        data[ID]["date"],
                                        style: TextStyle(
                                          color: Color.fromRGBO(34, 36, 86, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                      Text(
                                        " at ",
                                        style: TextStyle(
                                          color: Color.fromRGBO(34, 36, 86, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        data[ID]["time"],
                                        style: TextStyle(
                                          color: Color.fromRGBO(34, 36, 86, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: appConfigblockSizeHeight * 5,
                            ),

                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [Text("To reschedule ",
                                    style: TextStyle(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    data[ID]["dog_name"],
                                    style: TextStyle(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text("'s appointment...",
                                    style: TextStyle(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],),
                                SizedBox(height: appConfigblockSizeHeight * 2,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [Text("Select the date or time to change it and tap +",
                                  style: TextStyle(
                                    color: Color.fromRGBO(34, 36, 86, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [Text("To completely remove a booking just tap the -",
                                  style: TextStyle(
                                    color: Color.fromRGBO(34, 36, 86, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),],),
                                SizedBox(height: appConfigblockSizeHeight * 4,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                          color: Color.fromRGBO(34, 36, 86, 1),
                                          onPressed: () => _selectDate(context),
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
                                          color: Color.fromRGBO(34, 36, 86, 1),
                                          onPressed: () => _selectTime(context),
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
                        SizedBox(
                          height: appConfigblockSizeHeight * 4,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: 'remove',
                              onPressed: () {
                                _removeGroom();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Appointments()));
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
                                _updateGroomDate(); _updateGroomTime();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Appointments()));
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

  void _updateGroomDate() async {

    if(finalDate == null){} else if(finalDate != null){ Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnScheduleDate: "${dateCheck()}",
    };
    final rowsAffected = await dbHelper.updateDoggos(row);}
  }

  void _updateGroomTime() async {

    if(finalTime == null){} else if(finalTime != null){ Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnScheduleTime: "${timeCheck()}",
    };
    final rowsAffected = await dbHelper.updateDoggos(row);}
  }


  void _removeGroom() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnScheduleDate: "No Grooming Scheduled",
      DatabaseHelper.columnScheduleTime: "No Time",
    };
    final rowsAffected = await dbHelper.updateDoggos(row);
  }
}
