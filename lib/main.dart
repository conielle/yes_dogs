import 'package:daniellesdoggrooming/screens/supply_info.dart';
import 'package:flutter/material.dart';

import 'package:daniellesdoggrooming/screens/welcome.dart';
import 'package:daniellesdoggrooming/screens/home.dart';
import 'package:daniellesdoggrooming/screens/doggos.dart';
import 'package:daniellesdoggrooming/screens/appointments.dart';
import 'package:daniellesdoggrooming/screens/supplies.dart';
import 'package:daniellesdoggrooming/screens/statistics.dart';
import 'package:daniellesdoggrooming/screens/add_doggo.dart';
import 'package:daniellesdoggrooming/screens/doggo_info.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {



  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: Welcome.id,
      routes: {
        Welcome.id: (context) => Welcome(),
        Home.id: (context) => Home(),
        Doggos.id: (context) => Doggos(),
        AddDoggo.id: (context) => AddDoggo(),
        DoggoInfo.id: (context) => DoggoInfo(),
        SupplyInfo.id: (context) => SupplyInfo(),
        Appointments.id: (context) => Appointments(),
        Supplies.id: (context) => Supplies(),
        Statistics.id: (context) => Statistics(),

      },
    );
  }
}
