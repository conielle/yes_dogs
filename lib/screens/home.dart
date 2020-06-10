import 'package:daniellesdoggrooming/screens/add_doggo.dart';
import 'package:daniellesdoggrooming/screens/add_supply.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daniellesdoggrooming/screens/doggos.dart';
import 'package:daniellesdoggrooming/screens/doggo_info.dart';
import 'package:daniellesdoggrooming/screens/appointments.dart';
import 'package:daniellesdoggrooming/screens/supplies.dart';
import 'package:daniellesdoggrooming/screens/supply_info.dart';
import 'package:daniellesdoggrooming/screens/statistics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daniellesdoggrooming/database/database_logic.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  static const String id = 'home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final dbHelper = DatabaseHelper.instance;

  var dogUniqueID;
  var number;
  var doggoID;

  var supplyUniqueID;
  var supplyID;

  List data;
  List data2;

  void firstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', true);
    print("Not First Launch Anymore");
  }

  fetchDataCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('doggosFirstLaunch') ?? true;

    if (isFirstLaunch == true) {
    } else {
      fetchDogs();
      fetchSupplies();
    }
  }

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

//  doggoCheck(){print(data.length);}

  @override
  void initState() {
    firstLaunch();
    fetchDataCheck();
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
          'Whats Happening',
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
              width: appConfigblockSizeWidth * 100,
              child: Column(
                children: [
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          height: appConfigblockSizeHeight * 55,
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
                                        Text(
                                          "Welcome Danielle!",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(34, 36, 86, 1),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 24,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          height: 200,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image:
                                                  AssetImage('images/logo.png'),
                                              fit: BoxFit.fill,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Text(
                                          "Add Some Dogs",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(34, 36, 86, 1),
                                            fontWeight: FontWeight.bold,
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
                                                    builder: (context) =>
                                                        AddDoggo()));
                                          },
                                          child: Icon(
                                            Icons.add,
                                          ),
                                          backgroundColor:
                                              Color.fromRGBO(34, 36, 86, 1),
                                        ),
                                      ],
                                    ))
                                  : (data.length == 0)
                                      ? (Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Welcome Danielle!",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    34, 36, 86, 1),
                                                fontWeight: FontWeight.w900,
                                                fontSize: 24,
                                              ),
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
                                                fontWeight: FontWeight.bold,
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
                                                        builder: (context) =>
                                                            AddDoggo()));
                                              },
                                              child: Icon(
                                                Icons.add,
                                              ),
                                              backgroundColor:
                                                  Color.fromRGBO(34, 36, 86, 1),
                                            ),
                                          ],
                                        ))
                                      : (Expanded(
                                          child: ListView.builder(
                                            itemCount: data.length,
                                            itemBuilder:
                                                (BuildContext context, i) {
                                              return new ListTile(
                                                onTap: () async {
                                                  dogUniqueID =
                                                      data[i]["uniqueID"];
                                                  SharedPreferences doginfo =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  doginfo.setString(
                                                      'doguniqueid',
                                                      '$dogUniqueID');

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DoggoInfo()));
                                                },
                                                title: new Text(
                                                    data[i]["dog_name"]),
                                                subtitle: new Text(
                                                    data[i]["owner_name"]),
                                                leading: new CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage:
                                                      new AssetImage(
                                                          data[i]["picture"]),
                                                ),
                                              );
                                            },
                                          ),
                                        ))
                            ],

                            //////////////TOP STREAM////////////
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          height: appConfigblockSizeHeight * 30,
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
                                            color:
                                                Color.fromRGBO(34, 36, 86, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(
                                          height: appConfigblockSizeHeight * 1,
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
                                              Color.fromRGBO(34, 36, 86, 1),
                                        ),
                                      ],
                                    ))
                                  : (data2.length == 0)
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
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  appConfigblockSizeHeight * 1,
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
                                                  Color.fromRGBO(34, 36, 86, 1),
                                            ),
                                          ],
                                        ))
                                      : (Expanded(
                                          child: ListView.builder(
                                            itemCount: data2 == null
                                                ? 0
                                                : data2.length,
                                            itemBuilder: (context, i) {
                                              return new ListTile(
                                                onTap: () async {
                                                  supplyUniqueID =
                                                      data2[i]["uniqueID"];
                                                  SharedPreferences supplyinfo =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  supplyinfo.setString(
                                                      'supplyuniqueid',
                                                      '$supplyUniqueID');
                                                  print("supplyID");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SupplyInfo()));
                                                },
                                                title: new Text(
                                                    data2[i]["supply_type"]),
                                                subtitle: new Text(
                                                    data2[i]["brand_name"]),
                                                trailing: new Text(
                                                  data2[i]['level'],
                                                ),
                                                leading: new CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage:
                                                      new AssetImage(
                                                          data2[i]["picture"]),
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
                ],
              ),
            ),
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

  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    ));
  }
}
