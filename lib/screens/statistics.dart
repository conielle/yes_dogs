import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

import 'package:daniellesdoggrooming/screens/home.dart';
import 'package:daniellesdoggrooming/screens/doggos.dart';
import 'package:daniellesdoggrooming/screens/appointments.dart';
import 'package:daniellesdoggrooming/screens/supplies.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Statistics extends StatefulWidget {
  static const String id = 'statistics';

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> with TickerProviderStateMixin {

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    double appConfigWidth = MediaQuery.of(context).size.width;
    double appConfigHeight = MediaQuery.of(context).size.height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(255, 187, 204, 1),
        child: Center(
          child: RaisedButton(
            onPressed: () {
              if (fabKey.currentState.isOpen) {
                fabKey.currentState.close();
              } else {
                fabKey.currentState.open();
              }
            },
            color: Color.fromRGBO(255, 187, 204, 1),
            child: Container(),
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FabCircularMenu(
          key: fabKey,
          alignment: Alignment.bottomRight,
          ringColor: Color.fromRGBO(245, 66, 145, 1),
          ringDiameter: 500.0,
          ringWidth: 110.0,
          fabSize: 80.0,
          fabElevation: 8.0,
          fabColor: Color.fromRGBO(245, 66, 145, 1),
          fabOpenIcon: Icon(Icons.menu, color: Colors.white),
          fabCloseIcon: Icon(Icons.close, color: Colors.white),
          fabMargin: const EdgeInsets.all(16.0),
          animationDuration: const Duration(milliseconds: 800),
          animationCurve: Curves.easeInOutCirc,
          children: <Widget>[
            RawMaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: IconButton(icon: FaIcon(FontAwesomeIcons.home, color: Colors.white,)),
            ),
            RawMaterialButton(
              onPressed: () {
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: IconButton(icon: FaIcon(FontAwesomeIcons.sortNumericDownAlt, color: Colors.white10,)),
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Supplies()) );
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: IconButton(icon: FaIcon(FontAwesomeIcons.flask, color: Colors.white,)),
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Appointments()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: IconButton(icon: FaIcon(FontAwesomeIcons.clipboardList, color: Colors.white,)),
            ),
            RawMaterialButton(
              onPressed: () {
                _showSnackBar(context, "Doggos");
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Doggos()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: IconButton(icon: FaIcon(FontAwesomeIcons.dog, color: Colors.white,)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar (BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 1000),
        )
    );
  }

}