import 'package:daniellesdoggrooming/screens/add_doggo.dart';
import 'package:daniellesdoggrooming/screens/add_supply.dart';
import 'package:daniellesdoggrooming/screens/home_info_screen1.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daniellesdoggrooming/screens/doggos.dart';
import 'package:daniellesdoggrooming/screens/appointments.dart';
import 'package:daniellesdoggrooming/screens/supplies.dart';
import 'package:daniellesdoggrooming/screens/supply_info.dart';
import 'package:daniellesdoggrooming/screens/statistics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daniellesdoggrooming/database/database_logic.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';

class Home extends StatefulWidget {
  static const String id = 'home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  ////KEYS FOR FILE////
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final dbHelper = DatabaseHelper.instance;

  //WELCOME CYCLE
  var welcomeList = List.from([
     'Welcome', 'Woof Woof', 'Boof!', 'GRRRRRR!', 'Where Go? I Come!', 'Give Me Chimpkin Nugger!', 'Belly Rub?', 'Scratch Back!', 'Don\'t Tickle Paws!', 'I Want Go Outside!', 'Mmmm Cat Poop! Delicious!'], growable: false);
  random(){
    Random rnd;
    int min = 0;
    int max = 11;
    int r;
    rnd = new Random();
    r = min + rnd.nextInt(max - min);
    print("$r is in the range of $min and $max");

    return r;
  }

  ////DEFINITIONS////
  var dogUniqueID;
  var number;
  var doggoID;

  var supplyUniqueID;
  var supplyID;

  List data;
  List data2;

  final userName = TextEditingController();
  String setUserName;

  ////POPUP FOR USERNAME////
  void _userName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Color.fromRGBO(171, 177, 177, 1),
            title: new Text("Whats your name?"),
            content: Column(
              children: <Widget>[
                Text("What is your real name?"),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: Color.fromRGBO(34, 36, 86, 1),
                  decoration: InputDecoration(
                    hintText: 'Your Name',
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
                    icon: Icon(
                      FontAwesomeIcons.solidHourglass,
                      color: Color.fromRGBO(34, 36, 86, 1),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  controller: userName,
                ),
              ],
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Continue"),
                textColor: Colors.black45,
                onPressed: () {
                  _setUserName();
                  Navigator.of(context).pushReplacementNamed(Home.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ////SAVE USERNAME TO MEMORY////
  _setUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', '${userName.text}');
    print("User Name Saved");
    setState(() {
      setUserName == userName.text;
    });
  }

  ////CHECK FOR USERNAME AND LOAD TO MEMORY////
  userNameCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setUserName = prefs.get('username');
    setState(() {
      setUserName;
    });
  }

  ////SET FIRST LAUNCH VARIABLE/////
  void firstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', true);
    print("Not First Launch Anymore");
  }

  ////CHECK IF ITS FIRST LAUNCH AND PULLING DATABASE DATA////
  fetchDataCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('doggosFirstLaunch') ?? true;

    if (isFirstLaunch == true) {
    } else {
      fetchDogs();
      fetchSupplies();
    }
  }

  /////FETCH DOGS INFO FROM DATABASE/////
  Future<String> fetchDogs() async {
    var database = await openDatabase('database.db');
    var thing = await database.rawQuery('SELECT * FROM doggos');

    setState(() {
      var extractdata = thing;
      data = extractdata;
      print(data.length);
      return data.toList();
    });
  }

  /////FETCH SUPPLIES INFO FROM DATABASE/////
  Future<String> fetchSupplies() async {
    var database = await openDatabase('database.db');
    var thing = await database.rawQuery('SELECT * FROM supplies');

    setState(() {
      var extractdata = thing;
      data2 = extractdata;
      print(data2.length);
      return data2.toList();
    });
  }

  ////INITIATE TASKS////
  @override
  void initState() {
    fetchDataCheck();
    userNameCheck();
    firstLaunch();
  }



  ////WHATS VISIBLE ON SCREEN////
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
          'Whats Happening',
          style: TextStyle(color: Colors.white),
        ),
        leading: new Container(),
      ),
      body: Container(
        width: appConfigblockSizeWidth * 100,
        height: appConfigblockSizeHeight * 100,
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
                height: appConfigblockSizeHeight * 100,
                width: appConfigblockSizeWidth * 100,
                child: Center(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: appConfigblockSizeHeight * 1),

                            height: appConfigblockSizeHeight * 10,
                            width: appConfigblockSizeWidth * 80,
                            child: Column(
                              children: [
                                Text(
                                 welcomeList[random()],
                                  style: TextStyle(
                                    color: Color.fromRGBO(34, 36, 86, 1),
                                    fontWeight: FontWeight.w900,
                                    fontSize: fontSize * 10,
                                  ),
                                ),
                                Container(
                                  height: appConfigblockSizeHeight * 3,
                                  child: FlatButton(
                                    onPressed: () {
                                      _userName();
                                    },
                                    child: setUserName == null
                                        ? Text(
                                            "Tap to add your name",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    34, 36, 86, 1),
                                                fontWeight: FontWeight.w500,
                                                fontSize: fontSize * 7),
                                          )
                                        : Text(
                                            "${setUserName}",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(34, 36, 86, 1),
                                              fontWeight: FontWeight.w500,
                                              fontSize: fontSize * 7,
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: appConfigblockSizeHeight * 1,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              bottom: 0,
                              top: appConfigblockSizeWidth * 0.5,
                              left: appConfigblockSizeWidth * 2,
                              right: appConfigblockSizeWidth * 2,
                            ),
                            height: appConfigblockSizeHeight * 52,
                            width: appConfigblockSizeWidth * 80,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      width: appConfigblockSizeWidth * 80,
                                      height: appConfigblockSizeHeight * 52,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(136, 136, 136, 1),


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

                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                appConfigblockSizeHeight * 5),
                                            topLeft: Radius.circular(
                                                appConfigblockSizeHeight * 5)),
                                      ),
                                      child: Column(
                                        //////////////TOP STREAM////////////
                                        children: <Widget>[
                                          (data == null)
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
                                                      height: 200,
                                                      width: 200,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              'images/logo.png'),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Add Some Dogs",
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            34, 36, 86, 1),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 1,
                                                    ),
                                                    FloatingActionButton(
                                                      heroTag: 'adddoggo',
                                                      onPressed: () {
                                                        ;
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AddDoggo()));
                                                      },
                                                      child: Icon(
                                                        Icons.add,
                                                      ),
                                                      backgroundColor:
                                                          Color.fromRGBO(
                                                              34, 36, 86, 1),
                                                    ),
                                                  ],
                                                ))
                                              : (data.length == 0)
                                                  ? (Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Container(
                                                          height: 200,
                                                          width: 200,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                  'images/logo.png'),
                                                              fit: BoxFit.fill,
                                                            ),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Add Some Dogs",
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    34,
                                                                    36,
                                                                    86,
                                                                    1),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 1,
                                                        ),
                                                        FloatingActionButton(
                                                          heroTag: 'adddoggo',
                                                          onPressed: () {
                                                            ;
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            AddDoggo()));
                                                          },
                                                          child: Icon(
                                                            Icons.add,
                                                          ),
                                                          backgroundColor:
                                                              Color.fromRGBO(34,
                                                                  36, 86, 1),
                                                        ),
                                                      ],
                                                    ))
                                                  : Container(
                                                      child: (Expanded(
                                                        child: ListView.builder(
                                                          itemCount:
                                                              data.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  i) {
                                                            return new ListTile(
                                                              onTap: () async {
                                                                dogUniqueID = data[
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
                                                                                HomeInfo1()));
                                                              },
                                                              title: new Text(data[
                                                                      i]
                                                                  ["dog_name"]),
                                                              subtitle:
                                                                  new Text(data[
                                                                          i][
                                                                      "owner_name"]),
                                                              leading:
                                                                  new CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                backgroundImage:
                                                                    new AssetImage(
                                                                        data[i][
                                                                            "picture"]),
                                                              ),
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
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        top: appConfigblockSizeHeight * 56,
                        child: Container(
                            padding:
                                EdgeInsets.only(left: appConfigblockSizeWidth * 1, right: appConfigblockSizeWidth * 1, top: appConfigblockSizeWidth * 1),

                            height: appConfigblockSizeHeight * 34,
                            width: appConfigblockSizeWidth * 80,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      height: appConfigblockSizeHeight * 34,
                                      width: appConfigblockSizeWidth * 87,
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
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                appConfigblockSizeHeight * 5),
                                            topLeft: Radius.circular(
                                                appConfigblockSizeHeight * 5)),
                                      ),
                                      child: Column(
                                        //////////////BOTTOM STREAM////////////

                                        children: [
                                          (data2 == null)
                                              ? (Column(
                                                  children: [
                                                    Container(
                                                      height: 100,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              'images/supplies.png'),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Add Some Supplies",
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            34, 36, 86, 1),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          appConfigblockSizeHeight *
                                                              1,
                                                    ),
                                                    FloatingActionButton(
                                                      heroTag: 'addsupplies',
                                                      onPressed: () {
                                                        ;
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    AddSupply()));
                                                      },
                                                      child: Icon(
                                                        Icons.add,
                                                      ),
                                                      backgroundColor:
                                                          Color.fromRGBO(
                                                              34, 36, 86, 1),
                                                    ),
                                                  ],
                                                ))
                                              : (data2.length == 0)
                                                  ? (Column(
                                                      children: [
                                                        Container(
                                                          height: 100,
                                                          width: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                  'images/supplies.png'),
                                                              fit: BoxFit.fill,
                                                            ),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Add Some Supplies",
                                                          style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                34, 36, 86, 1),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              appConfigblockSizeHeight *
                                                                  1,
                                                        ),
                                                        FloatingActionButton(
                                                          heroTag: 'addsupplies',
                                                          onPressed: () {
                                                            ;
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            AddSupply()));
                                                          },
                                                          child: Icon(
                                                            Icons.add,
                                                          ),
                                                          backgroundColor:
                                                              Color.fromRGBO(
                                                                  34, 36, 86, 1),
                                                        ),
                                                      ],
                                                    ))
                                                  : (Expanded(
                                                      child: ListView.builder(
                                                        itemCount: data2 == null
                                                            ? 0
                                                            : data2.length,
                                                        itemBuilder:
                                                            (context, i) {
                                                          return new ListTile(
                                                            onTap: () async {
                                                              supplyUniqueID =
                                                                  data2[i][
                                                                      "uniqueID"];
                                                              SharedPreferences
                                                                  supplyinfo =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              supplyinfo.setString(
                                                                  'supplyuniqueid',
                                                                  '$supplyUniqueID');
                                                              print("supplyID");
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              SupplyInfo()));
                                                            },
                                                            title: new Text(data2[
                                                                    i]
                                                                ["supply_type"]),
                                                            subtitle: new Text(
                                                                data2[i][
                                                                    "brand_name"]),
                                                            trailing: new Text(
                                                                '${data2[i]['level']}%'

                                                            ),
                                                            leading:
                                                                new CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              backgroundImage:
                                                                  new AssetImage(
                                                                      data2[i][
                                                                          "picture"]),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )),
                                        ],

                                        //////////////BOTTOM STREAM////////////
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
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
}
