import 'package:daniellesdoggrooming/screens/doggo_info.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:daniellesdoggrooming/screens/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:daniellesdoggrooming/database/database_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:daniellesdoggrooming/screens/home_info_screen1.dart';
import 'package:daniellesdoggrooming/screens/home_info_screen3.dart';

class random {
  static final Random _random = Random.secure();

  static String Number([int length = 6]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }
}

class HomeInfo2 extends StatefulWidget {
  static const String id = 'homeinfo2';

  @override
  _HomeInfo2State createState() => _HomeInfo2State();
}

class _HomeInfo2State extends State<HomeInfo2> with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final dbHelper = DatabaseHelper.instance;

  var ID = 0;
  int indexID;
  var dogUniqueID;
  List data;
  String owner;
  List ownerdata;


  final updateAddress = TextEditingController();
  final updateOwnerName = TextEditingController();
  final updatePhoneNumber = TextEditingController();
  final updateEmail = TextEditingController();
  final updateIDNumber = TextEditingController();
  final updateVet = TextEditingController();

  @override

  fetchUniqueID() async {
    SharedPreferences doginfo = await SharedPreferences.getInstance();
    dogUniqueID = doginfo.getString('doguniqueid') ?? '';
    owner = doginfo.getString('owner') ?? '';

    print(owner);
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

  fetchOwner() async {
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
        '${DatabaseHelper.columnOwnerName} = "$owner"';
    int rowId = 2;
    List<dynamic> whereArguments = [rowId];
    List<Map> result = await db.query(DatabaseHelper.table,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);

    print(result);

    setState(() {
      var extractdata = result;
      ownerdata = extractdata;
      print(ownerdata);
      return ownerdata.toList();
    });

    print("Owner Database Query");
  }

  @override
  void initState() {
    fetchUniqueID();
    fetchID();
    fetchOwner();
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
        child: Container(padding: EdgeInsets.only(top: 0),
            color: Color.fromRGBO(171, 177, 177, 1),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(appConfigblockSizeWidth * 4)),
                    color: Color.fromRGBO(111,117,117,1),),
                    child: FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(appConfigblockSizeHeight * 2),
                          )),
                      color: Color.fromRGBO(101, 107, 107, 1),
                      textColor: Color.fromRGBO(34, 36, 86, 1),
                      padding: EdgeInsets.all(0),
                      onPressed: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeInfo1()));},
                      child: Container(
                        width: appConfigblockSizeWidth * 33.3,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
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
                      color: Color.fromRGBO(101,107,107, 1),

                    ),

                    child: Container(

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(appConfigblockSizeHeight * 2),),
                        color: Color.fromRGBO(81,87,87, 1),

                      ),
                      child: FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(appConfigblockSizeHeight * 2), bottomRight: Radius.circular(appConfigblockSizeHeight * 2, ),
                            )),
                        color: Color.fromRGBO(131, 137, 137, 1),
                        textColor: Color.fromRGBO(34, 36, 86, 1),
                        padding: EdgeInsets.all(0),
                        onPressed: () {},
                        child: Container(width: appConfigblockSizeWidth * 33.3,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
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
                        color: Color.fromRGBO(81, 87, 87, 1),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(appConfigblockSizeWidth * 4))),
                    padding: EdgeInsets.all(0),

                    child: FlatButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(appConfigblockSizeHeight * 2), bottomLeft: Radius.circular(appConfigblockSizeHeight * 2),
                          ),
                          ),
                      color: Color.fromRGBO(81, 87, 87, 1),
                      textColor: Color.fromRGBO(34, 36, 86, 1),
                      padding: EdgeInsets.all(0),
                      onPressed: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeInfo3()));},
                      child: Container(width: appConfigblockSizeWidth * 33.3,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
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
              Container(height: appConfigblockSizeHeight * 150,
                child: Column(
                  children: [ Container(
                    child: Container(
                      color: Color.fromRGBO(171, 177, 177, 1),
                      child: Center(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: Container(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: appConfigblockSizeWidth * 90,
                                      padding: EdgeInsets.all(
                                          appConfigblockSizeWidth * 2),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black54.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                        color: Color.fromRGBO(156, 156, 156, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                appConfigblockSizeWidth * 4)),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Row(

                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Tap on an item below to change it.',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(34, 36, 86, 1),
                                                    fontSize: fontSize * 6,
                                                  ),
                                                ),
                                                SizedBox(height: appConfigblockSizeHeight * 0.5,),
                                                //DOG NAME
                                                InkWell(

                                                  onTap: (){_addOwnerName();},
                                                  child: Container(
                                                    child: Text(
                                                      data[ID]["owner_name"],
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              34, 36, 86, 1),
                                                          fontWeight:
                                                          FontWeight.w900,
                                                          fontSize: fontSize * 8),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: appConfigblockSizeHeight * 1,),
                                                //AGE
                                                InkWell(
                                                  onTap: (){_addIDNumber();},
                                                  child: Container(
                                                    child: Row(

                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: [

                                                        Text(
                                                          'ID Number: ',
                                                          style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                34, 36, 86, 1),
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            fontSize: fontSize * 7,
                                                          ),
                                                        ),

                                                        Text(
                                                          (data[ID]["idnumber"])
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                34, 36, 86, 1),
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: fontSize * 7,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: appConfigblockSizeHeight * 0.5,),
                                                Container(
                                                  child: InkWell(
                                                    onTap: (){_addPhoneNumber();},
                                                    child: Row(

                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: [

                                                        Text(
                                                          'Phone Number: ',
                                                          style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                34, 36, 86, 1),
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            fontSize: fontSize * 7,
                                                          ),
                                                        ),

                                                        Text(
                                                          (data[ID]["phone"])
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                34, 36, 86, 1),
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: fontSize * 7,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
SizedBox(height: appConfigblockSizeHeight * 0.5,),
                                                Container(
                                                  child: InkWell(
                                                    onTap: (){_addEmail();},
                                                    child: Row(

                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: [

                                                        Text(
                                                          'Email: ',
                                                          style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                34, 36, 86, 1),
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            fontSize: fontSize * 7,
                                                          ),
                                                        ),

                                                        Text(
                                                          (data[ID]["email"])
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                34, 36, 86, 1),
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: fontSize * 7,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(top:
                                          appConfigblockSizeWidth * 4, bottom: appConfigblockSizeWidth * 4),
                                          child: Container(
                                            height: appConfigblockSizeHeight * 28,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(156, 156, 156, 1),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                  Colors.black54.withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0,
                                                      0), // changes position of shadow
                                                ),
                                              ],

                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      appConfigblockSizeWidth * 4)),
                                            ),
                                            child: Column(

                                              //////////////TOP STREAM////////////
                                              children: <Widget>[
                                                SizedBox(height: appConfigblockSizeHeight * 2,),
                                                Text(
                                                  'Owner\'s Doggos',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          34, 36, 86, 1),
                                                      fontWeight: FontWeight.w900,
                                                      fontSize: fontSize * 8),
                                                ),
                                                Container(
                                                  child: (Expanded(
                                                    child: ListView.builder(
                                                      itemCount:
                                                      ownerdata.length,
                                                      itemBuilder:
                                                          (BuildContext
                                                      context,
                                                          i) {
                                                        return new ListTile(
                                                          onTap: () async {
                                                            dogUniqueID = ownerdata[
                                                            i][
                                                            "uniqueID"];
                                                            SharedPreferences
                                                            doginfo =
                                                            await SharedPreferences
                                                                .getInstance();
                                                            doginfo.setString(
                                                                'doguniqueid',
                                                                '$dogUniqueID');

                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                        DoggoInfo()));
                                                          },
                                                          title: new Text(ownerdata[
                                                          i]
                                                          ["dog_name"], style: TextStyle(color: Color.fromRGBO(34, 36, 86, 1)),),
                                                          subtitle:
                                                          new Text(ownerdata[
                                                          i][
                                                          "breed"], style: TextStyle(color: Color.fromRGBO(34, 36, 86, 1)),),
                                                          leading:
                                                          new CircleAvatar(
                                                            backgroundColor:
                                                            Colors
                                                                .transparent,
                                                            backgroundImage:
                                                            new AssetImage(
                                                                ownerdata[i][
                                                                "picture"]),
                                                          ),
                                                          trailing: Text(ownerdata[i]['age'], style: TextStyle(color: Color.fromRGBO(34, 36, 86, 1)),),
                                                        );
                                                      },
                                                    ),
                                                  )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: appConfigblockSizeWidth * 90,
                                      padding: EdgeInsets.all(
                                          appConfigblockSizeWidth * 2),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black54.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                        color: Color.fromRGBO(156, 156, 156, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                appConfigblockSizeWidth * 4)),
                                      ),
                                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Address',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      34, 36, 86, 1),
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: fontSize * 8),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    FlatButton(
                                                      onPressed: (){_addAddress();},
                                                      child: Text(
                                                        (data[ID]["address"])
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              34, 36, 86, 1),
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          fontSize: fontSize * 7,
                                                        ),
                                                      ),

                                                    ),

                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: appConfigblockSizeHeight * 2,
                                    ),
                                    Container(
                                      width: appConfigblockSizeWidth * 90,
                                      padding: EdgeInsets.all(
                                          appConfigblockSizeWidth * 4),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black54.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                        color: Color.fromRGBO(156, 156, 156, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                appConfigblockSizeWidth * 4)),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              'Medical',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      34, 36, 86, 1),
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: fontSize * 8),
                                            ),
                                          ),
                                          FlatButton(onPressed: (){_addVet();},
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            child: Container(
                                              child: Text(
                                                data[ID]['vet'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                  Color.fromRGBO(34, 36, 86, 1),
                                                  fontSize: fontSize * 7,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                            appConfigblockSizeHeight * 0.5,
                                          ),
                                          Container(
                                            child: Text(
                                              data[ID]['medicalnotes'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color:
                                                Color.fromRGBO(34, 36, 86, 1),
                                                fontSize: fontSize * 7,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: appConfigblockSizeHeight * 2,
                                    ),
                                    Container(
                                      width: appConfigblockSizeWidth * 90,
                                      padding: EdgeInsets.all(
                                          appConfigblockSizeWidth * 4),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black54.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                        color: Color.fromRGBO(156, 156, 156, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                appConfigblockSizeWidth * 4)),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              'Notes',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      34, 36, 86, 1),
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: fontSize * 8),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              data[ID]['ownernotes'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color:
                                                Color.fromRGBO(34, 36, 86, 1),
                                                fontSize: fontSize * 7,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                            appConfigblockSizeHeight * 0.5,
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
                  ),],
                ),
              )
            ])),
      ),
    );
  }



  //TEXT CHECKERS

  isThereAnOwnerName() {
    String ownerValue;
    if (updateOwnerName.text == null) {
      ownerValue = data[0]['owner_name'];
    } else if (updateOwnerName.text == "") {
      ownerValue = data[0]['owner_name'];
    } else {
      ownerValue = updateOwnerName.text;
    }
    return ownerValue;
  }

  isThereAnIDNumber() {
    String idNumValue;
    if (updateIDNumber.text == null) {
      idNumValue = data[0]['idnumber'];
    } else if (updateIDNumber.text == '') {
      idNumValue = data[0]['idnumber'];
    } else {
      idNumValue = updateIDNumber.text;
    }
    return idNumValue;
  }

  isThereAPhoneNumber() {
    String phoneValue;
    if (updatePhoneNumber.text == null) {
      phoneValue = data[0]['phone'];
    } else if (updatePhoneNumber.text == "") {
      phoneValue = data[0]['phone'];
    } else {
      phoneValue = updatePhoneNumber.text;
    }
    return phoneValue;
  }

  isThereAEmail() {
    String emailValue;
    if (updateEmail.text == null) {
      emailValue = data[0]['email'];
    } else if (updateEmail.text == '') {
      emailValue = data[0]['email'];
    } else {
      emailValue = updateEmail.text;
    }
    return emailValue;
  }

  isThereAnAddress() {
    String addressValue;
    if (updateAddress.text == null) {
      addressValue = data[0]['address'];
    } else if (updateAddress.text == '') {
      addressValue = data[0]['address'];
    } else {
      addressValue = updateAddress.text;
    }
    return addressValue;
  }

  isThereVet() {
    String vetValue;
    if (updateVet.text == null) {
      vetValue = data[0]['vet'];
    } else if (updateVet.text == '') {
      vetValue = data[0]['vet'];
    } else {
      vetValue = updateAddress.text;
    }
    return vetValue;
  }

  //POPUP INPUTS

  void _addOwnerName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text(
            "Change Owner's Name?",
            style: TextStyle(
              color: Color.fromRGBO(34, 36, 86, 1),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Type Owner\'s Name',
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
                controller: updateOwnerName,
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
              textColor: Color.fromRGBO(34, 36, 86, 1),
              onPressed: () {
                _updateOwnerName();
                Navigator.of(context).pushReplacementNamed(HomeInfo2.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _addIDNumber() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text(
            "Change ID Number?",
            style: TextStyle(
              color: Color.fromRGBO(34, 36, 86, 1),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Type new ID Number',
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
                controller: updateIDNumber,
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
              textColor: Color.fromRGBO(34, 36, 86, 1),
              onPressed: () {
                _updateIDNumber();
                Navigator.of(context).pushReplacementNamed(HomeInfo2.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _addPhoneNumber() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text(
            "Change Phone Number?",
            style: TextStyle(
              color: Color.fromRGBO(34, 36, 86, 1),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Type new phone number',
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
                controller: updatePhoneNumber,
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
              textColor: Color.fromRGBO(34, 36, 86, 1),
              onPressed: () {
                _updatePhoneNumber();
                Navigator.of(context).pushReplacementNamed(HomeInfo2.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _addEmail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text(
            "Change Owner's Email?",
            style: TextStyle(
              color: Color.fromRGBO(34, 36, 86, 1),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Type new Email',
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
                controller: updateEmail,
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
              textColor: Color.fromRGBO(34, 36, 86, 1),
              onPressed: () {
                _updateEmail();
                Navigator.of(context).pushReplacementNamed(HomeInfo2.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _addAddress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text(
            "Change the Address?",
            style: TextStyle(
              color: Color.fromRGBO(34, 36, 86, 1),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                maxLines: 7,
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Type new Address here',
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
                controller: updateAddress,
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
              textColor: Color.fromRGBO(34, 36, 86, 1),
              onPressed: () {
                _updateAddress();
                Navigator.of(context).pushReplacementNamed(HomeInfo2.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _addVet() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text(
            "Change the Vet?",
            style: TextStyle(
              color: Color.fromRGBO(34, 36, 86, 1),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                maxLines: 7,
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Type new Vet here',
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
                controller: updateVet,
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
              textColor: Color.fromRGBO(34, 36, 86, 1),
              onPressed: () {
                _updateVet();
                Navigator.of(context).pushReplacementNamed(HomeInfo2.id);
              },
            ),
          ],
        );
      },
    );
  }


  //DATABASE

  void _updateOwnerName() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnOwnerName: isThereAnOwnerName()
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _updateIDNumber() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnOwnerID: isThereAnIDNumber(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _updatePhoneNumber() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnPhone: isThereAPhoneNumber(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _updateEmail() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnEmail: isThereAEmail(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _updateAddress() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnAddress: isThereAnAddress(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _updateVet() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnVet: isThereVet(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }





}
