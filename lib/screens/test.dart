import 'package:flutter/material.dart';

import 'package:fab_circular_menu/fab_circular_menu.dart';

import 'package:daniellesdoggrooming/screens/doggos.dart';
import 'package:daniellesdoggrooming/screens/appointments.dart';
import 'package:daniellesdoggrooming/screens/supplies.dart';
import 'package:daniellesdoggrooming/screens/help.dart';

class Test extends StatefulWidget {
  static const String id = 'test';

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> with TickerProviderStateMixin {

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
        color: const Color(0xFF192A56),
        child: Center(
          child: RaisedButton(
            onPressed: () {
              if (fabKey.currentState.isOpen) {
                fabKey.currentState.close();
              } else {
                fabKey.currentState.open();
              }
            },
            color: Colors.white,
            child: Text('Toggle menu programatically', style: TextStyle(color: primaryColor)),
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FabCircularMenu(
          key: fabKey,
          alignment: Alignment.bottomRight,
          ringColor: Colors.white.withAlpha(25),
          ringDiameter: 500.0,
          ringWidth: 150.0,
          fabSize: 64.0,
          fabElevation: 8.0,
          fabColor: Colors.white,
          fabOpenIcon: Icon(Icons.menu, color: primaryColor),
          fabCloseIcon: Icon(Icons.close, color: primaryColor),
          fabMargin: const EdgeInsets.all(16.0),
          animationDuration: const Duration(milliseconds: 800),
          animationCurve: Curves.easeInOutCirc,
          onDisplayChange: (isOpen) {
            _showSnackBar(context, "The menu is ${isOpen ? "open" : "closed"}");
          },
          children: <Widget>[
            RawMaterialButton(
              onPressed: () {
                _showSnackBar(context, "Doggos");
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Doggos()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(Icons.looks_one, color: Colors.white),
            ),
            RawMaterialButton(
              onPressed: () {
                _showSnackBar(context, "Appointments");
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Appointments()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(Icons.looks_two, color: Colors.white),
            ),
            RawMaterialButton(
              onPressed: () {
                _showSnackBar(context, "Supplies");
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Supplies()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(Icons.looks_3, color: Colors.white),
            ),
            RawMaterialButton(
              onPressed: () {
                _showSnackBar(context, "Statistics");
                fabKey.currentState.close();
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Help()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(Icons.looks_4, color: Colors.white),
            )
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