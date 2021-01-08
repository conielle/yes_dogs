import 'package:daniellesdoggrooming/screens/add_owner.dart';
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
import 'package:uuid/uuid.dart';

class random {
  static final Random _random = Random.secure();

  static String Number([int length = 6]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }
}

class AddDoggo extends StatefulWidget {
  static const String id = 'adddoggo';

  @override
  _AddDoggoState createState() => _AddDoggoState();
}

class _AddDoggoState extends State<AddDoggo> with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  String tempPath;
  String previewPath;
  File previewImage;
  String newImagePath;
  String savedImagePath;
  String savedImageRealPath;

  final addDoggoName = TextEditingController();
  final addDoggoAge = TextEditingController();
  final addBreed = TextEditingController();
  String doggoFixed;
  String doggoSex;
  String doggoTrained;
  String doggoGroomed;

  String finalDate;
  String finalTime;

  var uuid = Uuid();

  bool isSwitched = false;
  bool isGroomingSwitched = false;
  bool isTrainingSwitched = false;
  List<bool> _selections = List.generate(2, (_) => false);


  var uuiddog;
  uniqueIDGenerated() {

      var rng = new Random();
      for (var i = 0; i < 1; i++) {
        uuiddog = (rng.nextInt(10000000));
      }

    return uuiddog;
  }

  setID() async {
    uniqueIDGenerated();
    SharedPreferences doggoinfo =
        await SharedPreferences.getInstance();
    doggoinfo.setString('doggouniqueid', '${isThereADogName()}$uuiddog');

  }


  void _addPhoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text("Add a photo!", style: TextStyle(color: Color.fromRGBO(34, 36, 86, 1),),),
          content: Container(child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  backgroundColor: Color.fromRGBO(34, 36, 86, 1),
                  onPressed: () {
                    _getImage();
                    Navigator.of(context).pop(true);
                  },
                  heroTag: 'image1',
                  tooltip: 'Pick a photo',
                  child: const Icon(
                    Icons.photo_library,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  backgroundColor: Color.fromRGBO(34, 36, 86, 1),
                  onPressed: () {
                    _takeImage();
                    Navigator.of(context).pop(true);
                  },
                  heroTag: 'image2',
                  tooltip: 'Take a Photo',
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          ),

          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              textColor: Color.fromRGBO(34, 36, 86, 1),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override

  //UNIQUE ID GENERATOR

  String appDocPath;
  var uuidimage;
  uniqueImage() {
    uuidimage = uuid.v1();
    print(uuidimage);
    return uuidimage;
  }

  /////////GALLERY IMAGE SELECTOR//////

  Future _getImage() async {
    uniqueImage();

    //DEFINITIONS
    Directory tempDir = await getTemporaryDirectory();
    tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;

    String labelgallery = '${uuidimage}gallery.jpg';
    File _image;
    File savedImage;
    final picker = ImagePicker();


    //LOGIC
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    previewImage = savedImage;
    print("this is preview $savedImage");

    setState(() {
      _image = File(pickedFile.path);
      previewImage = _image;

      savedImagePath = previewImage.path;
      print(savedImagePath);
    });

    savedImage = await previewImage.copy('${appDocPath}/${labelgallery}');
    savedImageRealPath = savedImage.path;
    isThereAPic();
    return  previewImage;
  }

  /////////CAMERA IMAGE SELECTOR//////

  Future _takeImage() async {
    uniqueImage();

    //DEFINITIONS
    Directory tempDir = await getTemporaryDirectory();
    tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;

    String labelgallery = '${uuidimage}camera.jpg';
    File _image;
    File savedImage;
    final picker = ImagePicker();

    //LOGIC
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    previewImage = savedImage;
    print(savedImage);

    setState(() {
      _image = File(pickedFile.path);
      previewImage = _image;

      savedImagePath = previewImage.path;
      print(savedImagePath);
    });

    savedImage = await _image.copy('${appDocPath}/${labelgallery}');
    savedImageRealPath = savedImage.path;
    isThereAPic();
    return  previewImage;
  }

  final dbHelper = DatabaseHelper.instance;

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

  @override
  void initState() {
    super.initState();
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
          'Add A Doggo',
          style: TextStyle(color: Colors.white),
        ),leading: new Container(),
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
                      Column(
                        children: [
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Color.fromRGBO(34, 36, 86, 1),
                            decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(vertical: appConfigblockSizeHeight * 2, horizontal: appConfigblockSizeWidth * 2),
                              hintText: 'Doggo\'s Name',
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35.0)),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.white),
                              ),
                              hintStyle: TextStyle(
                                fontSize: fontSize * 8,
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
                                FontAwesomeIcons.dog,
                                color: Color.fromRGBO(34, 36, 86, 1),
                              ),
                            ),
                            textAlign: TextAlign.center,
                            controller: addDoggoName,
                          ),
                          SizedBox(
                            height: appConfigblockSizeHeight * 1,
                          ),
                          TextFormField(

                            style: TextStyle(
                                color: Colors.white),
                            cursorColor: Color.fromRGBO(34, 36, 86, 1),
                            decoration: InputDecoration(

                              contentPadding: new EdgeInsets.symmetric(vertical: appConfigblockSizeHeight * 2, horizontal: appConfigblockSizeWidth * 2),
                              hintText: 'Doggo\'s Age',
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35.0)),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.white),
                              ),
                              hintStyle: TextStyle(
                                fontSize: fontSize * 8,
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
                                FontAwesomeIcons.clock,
                                color: Color.fromRGBO(34, 36, 86, 1),
                              ),
                            ),
                            textAlign: TextAlign.center,
                            controller: addDoggoAge,
                          ),
                          SizedBox(
                            height: appConfigblockSizeHeight * 1,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Color.fromRGBO(34, 36, 86, 1),
                            decoration: InputDecoration(

                              contentPadding: new EdgeInsets.symmetric(vertical: appConfigblockSizeHeight * 2, horizontal: appConfigblockSizeWidth * 2),
                              hintText: 'Doggo\'s Breed',
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35.0)),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.white),
                              ),
                              hintStyle: TextStyle(
                                fontSize: fontSize * 8,
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
                                FontAwesomeIcons.paw,
                                color: Color.fromRGBO(34, 36, 86, 1),
                              ),
                            ),
                            textAlign: TextAlign.center,
                            controller: addBreed,
                          ),
                          Column(
                            children: [
                              Row(

                                children: [
                                  Text(
                                    'Is doggo neutered or spayed?',
                                    style: TextStyle(
                                      fontSize: fontSize * 7,
                                        color: Color.fromRGBO(34, 36, 86, 1)),
                                  ),
                                  SizedBox(width: fontSize * 17,),
                                  Switch(
                                      activeTrackColor:
                                          Color.fromRGBO(68, 70, 128, 1),
                                      activeColor: Color.fromRGBO(34, 36, 86, 1),
                                      value: isSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                          isDoggoFixed();
                                        });
                                      })
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Is the doggo being groomed?',
                                    style: TextStyle(
                                        fontSize: fontSize * 7,
                                        color: Color.fromRGBO(34, 36, 86, 1)),
                                  ),
                                  SizedBox(width: fontSize * 18,),
                                  Switch(
                                      activeTrackColor:
                                      Color.fromRGBO(68, 70, 128, 1),
                                      activeColor: Color.fromRGBO(34, 36, 86, 1),
                                      value: isGroomingSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isGroomingSwitched = value;
                                          isDoggoGrooming();
                                        });
                                      })
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Is doggo being trained?',
                                    style: TextStyle(
                                        fontSize: fontSize * 7,
                                        color: Color.fromRGBO(34, 36, 86, 1)),
                                  ),
                                  SizedBox(width: fontSize * 37,),
                                  Switch(
                                      activeTrackColor:
                                      Color.fromRGBO(68, 70, 128, 1),
                                      activeColor: Color.fromRGBO(34, 36, 86, 1),
                                      value: isTrainingSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isTrainingSwitched = value;
                                          isDoggoTraining();
                                        });
                                      })
                                ],
                              ),
                            ],
                          ),
                          ToggleButtons(
                            color: Color.fromRGBO(34, 36, 86, 1),
                            selectedColor: Color.fromRGBO(34, 36, 86, 1),
                            fillColor: Color.fromRGBO(101, 107, 107, 1),
                            splashColor: Colors.grey,
                            highlightColor: Color.fromRGBO(107, 107, 177, 1),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            disabledColor: Colors.blueGrey,
                            disabledBorderColor: Colors.blueGrey,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.mars, size: fontSize * 14,),
                              Icon(FontAwesomeIcons.venus, size: fontSize * 14,),
                            ],
                            isSelected: _selections,
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < _selections.length; i++) {
                                  _selections[i] = i == index;
                                }
                                isThereASex();
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: appConfigblockSizeWidth * 1,
                      ),
                      FlatButton(
                        onPressed: () {
                          _addPhoto();
                        },
                        child: Container(
                          child:  previewImage == null ?
                          CircleAvatar(backgroundImage: AssetImage('images/doggo_add.png'), backgroundColor: Colors.transparent, radius: appConfigblockSizeWidth * 20,) :
                          CircleAvatar(backgroundImage: FileImage(previewImage), backgroundColor: Colors.transparent, radius: appConfigblockSizeWidth * 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: appConfigblockSizeWidth * 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2, right: 2, top: 3),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                          textColor: Colors.white,
                          color: Color.fromRGBO(34, 36, 86, 1),
                          onPressed: () async {
                            _insert();
                            dogSchedule();
                            setID();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddOwner()));
                          },
                          child: Center(
                            child: Text('Continue...',
                                style: new TextStyle(
                                  color: Colors.white,
                                )),
                          ),
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
    );
  }

  isThereASex() {
    if (_selections[0] == true) {
      doggoSex = 'male';
      print('Doggo Is Male');
    } else if (_selections[1] == true) {
      doggoSex = 'female';
      print('Doggo Is Feale');
    } else {
      doggoSex = 'unknown';
      print('Doggo Is Sexless');
    }

    return doggoSex;
  }

  isDoggoFixed() {
    if (isSwitched == true) {
      doggoFixed = "is";
      print('Doggo Is Fixed');
    } else if (isSwitched == false) {
      doggoFixed = "is not";
      print("Doggo Is Not Fixed");
    }

    return doggoFixed;
  }

  isDoggoTraining() {
    if (isTrainingSwitched == true) {
      doggoTrained = "is";
      print('Doggo Is Training');
    } else if (isTrainingSwitched == false) {
      doggoTrained = "is not";
      print("Doggo Is Not Training");
    }

    return doggoTrained;
  }

  isDoggoGrooming() {
    if (isGroomingSwitched == true) {
      doggoGroomed = "is";
      print('Doggo Is Grooming');
    } else if (isGroomingSwitched == false) {
      doggoGroomed = "is not";
      print("Doggo Is Not Grooming");
    }

    return doggoGroomed;
  }

  isThereADogName() {

    String dogNameValue;
    if (addDoggoName.text == null) {
      dogNameValue = 'Nameless';
    } else if (addDoggoName.text == "") {
      dogNameValue = 'Nameless';
    } else {
      dogNameValue = addDoggoName.text;
    }
    return dogNameValue;
  }

  isThereABreed() {
    String nameValue;
    if (addBreed.text == null) {
      nameValue = 'Unknown Breed';
    } else if (addBreed.text == '') {
      nameValue = 'Unknown Breed';
    } else {
      nameValue = addBreed.text;
    }
    return nameValue;
  }

  isThereAnAge() {
    String ageValue;
    if (addDoggoAge.text == null) {
      ageValue = '?';
    } else if (addDoggoAge.text == "") {
      ageValue = '?';
    } else {
      ageValue = addDoggoAge.text;
    }

    return ageValue;
  }

  isThereAPic() {
    String picturePath;
    if (savedImagePath == null) {
      picturePath = 'images/doggo.png';
    } else {
      picturePath = savedImageRealPath;
    }
    return picturePath;
  }

  timeCheck() {
    var time;

    if (finalTime == null) {
      time = 'Time';
    } else {
      time = finalTime;
    }

    return time;
  }

  dateCheck() {
    var date;

    if (finalDate == null) {
      date = 'Date';
    } else {
      date = finalDate;
    }

    return date;
  }

  dogSchedule()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${isThereADogName()}$uuiddog', true);
    print('Scheduling database has been created');
  }


  void _insert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('doggosFirstLaunch', false);
    prefs.setBool('isFirstLaunch', false);

    Map<String, dynamic> row = {
      DatabaseHelper.columnDogName: '${isThereADogName()}',
      DatabaseHelper.columnDogUniqueId: '${isThereADogName()}$uuiddog',
      DatabaseHelper.columnBreed: '${isThereABreed()}',
      DatabaseHelper.columnFixed: '${isDoggoFixed()}',
      DatabaseHelper.columnSex: '${isThereASex()}',
      DatabaseHelper.columnScheduleDate: '${dateCheck()}',
      DatabaseHelper.columnScheduleTime: '${timeCheck()}',
      DatabaseHelper.columnGType: ' ',
      DatabaseHelper.columnAge: '${isThereAnAge()}',
      DatabaseHelper.columnPicture: '${isThereAPic()}',
      DatabaseHelper.columnTraining: '${isDoggoTraining()}',
      DatabaseHelper.columnGrooming: '${isDoggoGrooming()}',
      DatabaseHelper.columnOwnerName: 'Nameless Owner',
      DatabaseHelper.columnOwnerID: 'No ID Number',
      DatabaseHelper.columnPhone: 'No Phone Number',
      DatabaseHelper.columnEmail: 'No Email Address',
      DatabaseHelper.columnAddress: 'No Physical Address',
      DatabaseHelper.columnVet: 'No Vet Details',
      DatabaseHelper.columnMyNotes: 'My Notes Are Empty, For Now',
      DatabaseHelper.columnOwnerNotes: 'No Recorded Owner\'s Notes For Doggo',
      DatabaseHelper.columnMedicalNotes: 'No Recorded Medical Notes for Doggo',
      DatabaseHelper.columnTemperament: 'No Recorded Temperament Details for Doggo',
    };
    final id = await dbHelper.insertDoggos(row);
    print('inserted row id: $id');
  }
}
