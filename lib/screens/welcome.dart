import 'dart:async';

import 'package:daniellesdoggrooming/screens/home.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  static const String id = 'welcome';

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    void firstLaunch() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

      if (isFirstLaunch == false){} else {SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('doggosFirstLaunch', true);
      prefs.setBool('suppliesFirstLaunch', true);}

    }

    Timer(Duration(seconds: 3), () {
      firstLaunch();
    Navigator.pushReplacementNamed(context, Home.id);
    });


    double appConfigWidth = MediaQuery.of(context).size.width;
    double appConfigHeight = MediaQuery.of(context).size.height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;

    return Scaffold(
      body: Container(
        width: appConfigblockSizeWidth * 100,
        height: appConfigblockSizeHeight * 100,
        decoration: BoxDecoration(
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Container(
                  child: Image.asset(
                    "images/background.png",
                    fit: BoxFit.cover,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
