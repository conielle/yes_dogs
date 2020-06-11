import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:daniellesdoggrooming/database/database_logic.dart';
import 'package:daniellesdoggrooming/screens/doggos.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';

class random {
  static final Random _random = Random.secure();

  static String Number([int length = 6]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }
}

class AddOwner extends StatefulWidget {
  static const String id = 'addowner';

  @override
  _AddOwnerState createState() => _AddOwnerState();
}

class _AddOwnerState extends State<AddOwner> with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final dbHelper = DatabaseHelper.instance;

  final addOwnerName = TextEditingController();
  final addOwnerID = TextEditingController();
  final addOwnerPhone = TextEditingController();
  final addOwnerEmail = TextEditingController();
  final addOwnerAddress = TextEditingController();
  final addOwnerVet = TextEditingController();

  var ownerUniqueID;
  var ID = 0;
  int indexID;
  List data;


  fetchUniqueID() async {
    SharedPreferences ownerinfo = await SharedPreferences.getInstance();
    ownerUniqueID = ownerinfo.getString('owneruniqueid') ?? '';

    print('Unique ID Fetched on Owner Page');
    return ownerUniqueID;
  }

  fetchID() async{

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
    ];
    String whereString = '${DatabaseHelper.columnDogUniqueId} = "${ownerUniqueID}"';
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
            'Owner Details',
            style: TextStyle(color: Colors.white),
          ),
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
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: appConfigblockSizeWidth * 2,
                        ),
                        Column(
                          children: [
                            TextField(
                              style: TextStyle(color: Colors.white),
                              cursorColor: Color.fromRGBO(34, 36, 86, 1),
                              decoration: InputDecoration(
                                hintText: 'Owner\'s Name',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.white),
                                ),
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                icon: Icon(FontAwesomeIcons.userAlt,
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              controller: addOwnerName,
                            ),
                            SizedBox(
                              height: appConfigblockSizeHeight * 2,
                            ),
                            TextField(
                              style: TextStyle(color: Colors.white),
                              cursorColor: Color.fromRGBO(34, 36, 86, 1),
                              decoration: InputDecoration(
                                hintText: 'Owner\'s ID Number',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.white),
                                ),
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                icon: Icon(FontAwesomeIcons.idCardAlt,
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              controller: addOwnerID,
                            ),
                            SizedBox(
                              height: appConfigblockSizeHeight * 2.5,
                            ),
                            TextField(
                              style: TextStyle(color: Colors.white),
                              cursorColor: Color.fromRGBO(34, 36, 86, 1),
                              decoration: InputDecoration(
                                hintText: 'Owner\'s Phone Number',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                  borderSide:
                                  BorderSide(width: 2, color: Colors.white),
                                ),
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      width: 2),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      width: 2),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                ),
                                icon: Icon(Icons.phone_iphone,
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              controller: addOwnerPhone,
                            ),
                            SizedBox(
                              height: appConfigblockSizeHeight * 2.5,
                            ),
                            TextField(
                              style: TextStyle(color: Colors.white),
                              cursorColor: Color.fromRGBO(34, 36, 86, 1),
                              decoration: InputDecoration(
                                hintText: 'Owner\'s Email Address',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                  borderSide:
                                  BorderSide(width: 2, color: Colors.white),
                                ),
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      width: 2),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      width: 2),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                ),
                                icon: Icon(Icons.alternate_email,
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              controller: addOwnerEmail,
                            ),
                            SizedBox(
                              height: appConfigblockSizeHeight * 2.5,
                            ),
                            TextField(
                              maxLines: 7,
                              style: TextStyle(
                                  color: Colors.white),
                              cursorColor: Color.fromRGBO(34, 36, 86, 1),
                              decoration: InputDecoration(
                                hintText: 'Owner\'s Address',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                  borderSide:
                                  BorderSide(width: 2, color: Colors.white),
                                ),
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      width: 2),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      width: 2),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                ),
                                icon: Icon(Icons.home,
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              controller: addOwnerAddress,
                            ),

                            SizedBox(
                              height: appConfigblockSizeHeight * 2.5,
                            ),
                            TextField(
                              style: TextStyle(color: Colors.white),
                              cursorColor: Color.fromRGBO(34, 36, 86, 1),
                              decoration: InputDecoration(
                                hintText: 'Owner\'s Vet Details',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                  borderSide:
                                  BorderSide(width: 2, color: Colors.white),
                                ),
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      width: 2),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 36, 86, 1),
                                      width: 2),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                ),
                                icon: Icon(
                                  FontAwesomeIcons.userMd,
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              controller: addOwnerVet,
                            ),

                            SizedBox(
                              height: appConfigblockSizeWidth * 5,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 2, right: 2, top: 3),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                ),
                                textColor: Colors.white,
                                color: Color.fromRGBO(34, 36, 86, 1),
                                onPressed: () {
                                  _updateOwner();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Doggos()));
                                },
                                child: Center(
                                  child: Text('Add Now!',
                                      style: new TextStyle(
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }




  isThereName() {
    String finalName;
    if (addOwnerName.text == null) {finalName = "Nameless Owner";
    } else if (addOwnerName.text == ''){finalName = "Nameless Owner";
    } else {finalName = addOwnerName.text;}
    return finalName;
  }

   isThereID() {
    String finalID;
    if (addOwnerID.text == null) {finalID = "No ID Number";
    } else if (addOwnerID.text == ''){finalID = "No ID Number";
    } else {finalID = addOwnerID.text;}
    return finalID;
  }

  isTherePhone() {
    String finalPhone;
    if (addOwnerPhone.text == null) {finalPhone = "No Phone Number";
    } else if (addOwnerPhone.text == ''){finalPhone = "No Phone Number";
    } else {finalPhone = addOwnerPhone.text;}
    return finalPhone;
  }

  isThereEmail() {
    String finalEmail;
    if (addOwnerEmail.text == null) {finalEmail = "No Email Address";
    } else if (addOwnerEmail.text == ''){finalEmail = "No Email Address";
    } else {finalEmail = addOwnerEmail.text;}
    return finalEmail;
  }

  isThereAddress() {
    String finalAddress;
    if (addOwnerAddress.text == null) {finalAddress = "No Email Address";
    } else if (addOwnerAddress.text == ''){finalAddress = "No Email Address";
    } else {finalAddress = addOwnerAddress.text;}
    return finalAddress;
  }

  isThereVet() {
    String finalVet;
    if (addOwnerVet.text == null) {finalVet = "No Vet Details";
    } else if (addOwnerVet.text == ''){finalVet = "No Vet Details";
    } else {finalVet = addOwnerVet.text;}
    return finalVet;
  }


  void _updateOwner() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnOwnerName: '${isThereName()}',
      DatabaseHelper.columnOwnerID: '${isThereID()}',
      DatabaseHelper.columnPhone: '${isTherePhone()}',
      DatabaseHelper.columnEmail: '${isThereEmail()}',
      DatabaseHelper.columnVet: '${isThereVet()}',
      DatabaseHelper.columnAddress: '${isThereAddress()}',

    };
    final rowsAffected = await dbHelper.updateDoggos(row);
    print('database updated');
  }
}
