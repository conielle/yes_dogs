import 'package:daniellesdoggrooming/screens/supply_info.dart';
import 'package:flutter/material.dart';

import 'package:daniellesdoggrooming/screens/welcome.dart';
import 'package:daniellesdoggrooming/screens/home.dart';
import 'package:daniellesdoggrooming/screens/doggos.dart';
import 'package:daniellesdoggrooming/screens/appointments.dart';
import 'package:daniellesdoggrooming/screens/supplies.dart';
import 'package:daniellesdoggrooming/screens/help.dart';
import 'package:daniellesdoggrooming/screens/add_doggo.dart';
import 'package:daniellesdoggrooming/screens/doggo_info.dart';
import 'package:daniellesdoggrooming/screens/appointment_info.dart';
import 'package:daniellesdoggrooming/screens/owners.dart';
import 'package:daniellesdoggrooming/screens/owner_info.dart';
import 'package:daniellesdoggrooming/screens/add_owner.dart';
import 'package:daniellesdoggrooming/screens/home_info_screen1.dart';
import 'package:daniellesdoggrooming/screens/home_info_screen2.dart';
import 'package:daniellesdoggrooming/screens/home_info_screen3.dart';
import 'package:daniellesdoggrooming/screens/addgroom.dart';
import 'package:daniellesdoggrooming/screens/addhistory.dart';
import 'package:daniellesdoggrooming/screens/addhistory_update.dart';
import 'package:daniellesdoggrooming/screens/groomcompleted.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {



  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: Welcome.id,
      routes: {
        Welcome.id: (context) => Welcome(),
        Home.id: (context) => Home(store),
        Doggos.id: (context) => Doggos(),
        AddDoggo.id: (context) => AddDoggo(),
        DoggoInfo.id: (context) => DoggoInfo(),
        SupplyInfo.id: (context) => SupplyInfo(),
        Appointments.id: (context) => Appointments(),
        Supplies.id: (context) => Supplies(),
        Help.id: (context) => Help(),
        AppointmentInfo.id: (context) => AppointmentInfo(),
        AddOwner.id: (context) => AddOwner(),
        Owners.id: (context) =>  Owners(),
        OwnerInfo.id: (context) => OwnerInfo(),
        HomeInfo1.id: (context) => HomeInfo1(),
        HomeInfo2.id: (context) => HomeInfo2(),
        HomeInfo3.id: (context) => HomeInfo3(),
        AddGroom.id: (context) => AddGroom(),
        AddHistory.id: (context) => AddHistory(),
        AddHistoryUpdate.id: (context) => AddHistoryUpdate(),
        GroomCompleted.id: (context) => GroomCompleted(),
      },
    );
  }
}
