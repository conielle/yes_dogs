import 'package:daniellesdoggrooming/screens/appointment_info.dart';
import 'package:daniellesdoggrooming/screens/home_info_screen1.dart';
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
import 'package:daniellesdoggrooming/screens/doggos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class random {
  static final Random _random = Random.secure();

  static String Number([int length = 6]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }
}

class DoggoInfo extends StatefulWidget {
  static const String id = 'doggoinfo';

  @override
  _DoggoInfoState createState() => _DoggoInfoState();
}

class _DoggoInfoState extends State<DoggoInfo> with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final dbHelper = DatabaseHelper.instance;

  var ID = 0;
  int indexID;
  var dogUniqueID;
  List data;

  bool isSwitched = false;
  bool isGroomingSwitched = false;
  bool isTrainingSwitched = false;
  List<bool> _selections = List.generate(2, (_) => false);

  String tempPath;
  String previewPath;
  File previewImage;
  String newImagePath;
  String savedImagePath;

  final addDoggoName = TextEditingController();
  final addDoggoBreed = TextEditingController();
  final addDoggoAge = TextEditingController();


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
  ////////////ERROR POPUP////////////////


  /////////GALLERY IMAGE SELECTOR AND RESIZER//////
  File rawGalleryImage;

  Future _getImage() async {
    Directory tempDir = await getTemporaryDirectory();
    tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    var galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    print("Path : " + galleryImage.path);
    rawGalleryImage = galleryImage;

    File myCompressedFile;
    img.Image image = img.decodeImage(rawGalleryImage.readAsBytesSync());

    img.Image thumbnail = img.copyResize(image, height: 200);

    String labelgallery = '${random.Number()}${addDoggoName.text}gallery.jpg';

    myCompressedFile = new File(appDocPath + '$labelgallery')
      ..writeAsBytesSync(img.encodeJpg(thumbnail));
    print(appDocPath + '$labelgallery');
    newImagePath = myCompressedFile.path;
    print(newImagePath);

    final File copiedImage =
    await myCompressedFile.copy('$appDocPath/$labelgallery');

    print(copiedImage.path);
    savedImagePath = copiedImage.path;

    setState(() {
      previewImage = copiedImage;

    });
    _updatePicture();
    return previewImage;
  }

  /////////CAMERA IMAGE SELECTOR AND RESIZER//////
  File rawCamImage;

  Future _takeImage() async {
    Directory tempDir = await getTemporaryDirectory();
    tempPath = tempDir.path;


    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    rawCamImage = image;
    File convert = rawCamImage;
    File myCompressedFile;
    img.Image images = img.decodeImage(convert.readAsBytesSync());
    print("Compressed");

    // Resize the image to a 200x? thumbnail (maintaining the aspect ratio).
    img.Image thumbnail = img.copyResize(images, height: 200);
    img.Image rotated = img.copyRotate(thumbnail, 90);

    // Save the thumbnail as a JPG.

    String labelcamera = '${random.Number()}${addDoggoName.text}camera.jpg';

    myCompressedFile = new File(appDocPath + '$labelcamera')
      ..writeAsBytesSync(img.encodeJpg(thumbnail));
    print(appDocPath + '$labelcamera');
    newImagePath = myCompressedFile.path;

    print(newImagePath);

    final File copiedImage =
    await myCompressedFile.copy('$appDocPath/$labelcamera');

    print(copiedImage.path);
    savedImagePath = copiedImage.path;
    setState(() {
      previewImage = copiedImage;
    });

    _updatePicture();
    return previewImage;
  }


  fetchUniqueID() async {
    SharedPreferences doginfo = await SharedPreferences.getInstance();
    dogUniqueID = doginfo.getString('doguniqueid') ?? '';

    print(dogUniqueID);
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
      DatabaseHelper.columnGrooming,
      DatabaseHelper.columnTraining,
    ];
    String whereString = '${DatabaseHelper.columnDogUniqueId} = "${dogUniqueID}"';
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

      //BOOL CHECK FOR FIXED
      if (data[0]['fixed'] == 'is'){isSwitched = true;} else {isSwitched = false;}
      //BOOL CHECK FOR GROOMING
      if (data[0]['grooming'] == 'is'){isGroomingSwitched = true;} else {isGroomingSwitched = false;}
      //BOOL CHECK FOR TRAINING
      if (data[0]['training'] == 'is'){isTrainingSwitched = true;} else {isTrainingSwitched = false;}
      //BOOL CHECK FOR SEX
      if(data[0]['sex'] == 'unknown') {} else if (data[0]['sex'] == 'male'){_selections[0] = true;} else if (data[0]['sex'] == 'female') {_selections[1] = true;}

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
    double fontSize = appConfigWidth * 0.005;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(34, 36, 86, 1),
        title: Text(
          'Manage This Doggo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () {Navigator.of(context).pop(true);},
          )],
        leading: new Container(),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: appConfigblockSizeHeight * 100,
          color: Color.fromRGBO( 171, 177, 177, 1),
          child: Center(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 50.0, left: 50.0, top: 20, bottom: 20),
                child: Container(
                  child: Container(

                    child: Column(
                      children: [

                        SizedBox(
                          width: appConfigblockSizeWidth * 1,
                        ),
                        Text('Tap an item to change it', style: TextStyle(
                            color: Color.fromRGBO(
                                34, 36, 86, 1),

                            fontSize: fontSize * 6),),
                        SizedBox(height: appConfigblockSizeHeight * 1.5,),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            //PICTURE

                            Column(
                              children: <Widget>[
                                //DOG NAME
                                InkWell(onTap: () {_changeDoggoName();},
                                  child: Container(
                                    child: Text(
                                      data[ID]["dog_name"],
                                      style: TextStyle(
                                          color: Color.fromRGBO(
                                              34, 36, 86, 1),
                                          fontWeight:
                                          FontWeight.w900,
                                          fontSize: fontSize * 10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: appConfigblockSizeHeight * 0.5,),
                                //AGE
                                Container(
                                  child: Row(
                                    children: [InkWell(onTap: (){_changeAge();},
                                      child: Container(child:  Row(children: [
                                        Text(
                                          (data[ID]["age"])
                                              .toString(),
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                34, 36, 86, 1),
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          ' years old, ',
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                34, 36, 86, 1),
                                            fontStyle:
                                            FontStyle.italic,
                                            fontWeight:
                                            FontWeight.w400,
                                          ),
                                        ),
                                       ],),),
                                    ),
                                      Text(
                                        (data[ID]["sex"])
                                            .toString(),
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              34, 36, 86, 1),
                                          fontWeight:
                                          FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
SizedBox(height: appConfigblockSizeHeight * 0.5,),
                                InkWell(
                                  onTap: (){_changeDoggoBreed();},
                                  child: Text(
                                    (data[ID]["breed"]).toString(),
                                    style: TextStyle(
                                      color: Color.fromRGBO(
                                          34, 36, 86, 1),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                  appConfigblockSizeHeight *
                                      0.5,
                                ),
                                InkWell(onTap: (){

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AppointmentInfo()));

                                },
                                  child: Container(child: (data[0]['date'] == "No Grooming Scheduled") ? Row(children: [Text(
                                    'Groom To Be Scheduled',
                                    style: TextStyle(
                                      color: Color.fromRGBO(
                                          34, 36, 86, 1),
                                      fontWeight:
                                      FontWeight.w400,
                                      fontSize: fontSize * 7,
                                    ),
                                  ),
                                  ],) : Row(
                                    children: [
                                      Text(
                                        'Due for a groom on ',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              34, 36, 86, 1),
                                          fontWeight:
                                          FontWeight.w400,
                                          fontSize: fontSize * 7,
                                        ),
                                      ),
                                      Text(data[0]['date'],
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                34, 36, 86, 1),
                                            fontWeight:
                                            FontWeight.w600,
                                            fontSize: fontSize * 7,
                                          ))
                                    ],
                                  )
                                  ),
                                )],
                            ),
                          ],
                        ),




                        SizedBox(height: appConfigblockSizeHeight * 2,
                        ),
                        FlatButton(
                          onPressed: () {
                            _addPhoto();
                          },
                          child: Container(
                            child:  previewImage == null ?
                            CircleAvatar(backgroundImage: AssetImage(data[ID]['picture']), backgroundColor: Colors.transparent, radius: appConfigblockSizeWidth * 20,) :
                            CircleAvatar(backgroundImage: FileImage(previewImage), backgroundColor: Colors.transparent, radius: appConfigblockSizeWidth * 20,
                            ),
                          ),
                          ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 2,
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
                                        _updateFixed();
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
                                        _updateGrooming();


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
                                        _updateTraining();
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
                              _updateSex();
                            });
                          },
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(height: appConfigblockSizeHeight * 4,),
                            Text("Remove this doggo or save changes?",
                              style: TextStyle(
                                fontSize: fontSize * 6,
                                color: Color.fromRGBO(34, 36, 86, 1),),
                            ),
                            SizedBox(height:  appConfigblockSizeHeight * 2,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [

                              FloatingActionButton(
                                heroTag: 'remove',
                                onPressed: () {
                                  _deleteDoggos();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Doggos()));
                                },
                                child: Icon(
                                  Icons.remove,
                                ),
                                backgroundColor: Color.fromRGBO(34, 36, 86, 1),
                              ),

                              SizedBox( width: appConfigblockSizeWidth * 3,),

                              FloatingActionButton(
                                heroTag: 'add',
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeInfo1()));
                                },
                                child: Icon(
                                  Icons.add,
                                ),
                                backgroundColor: Color.fromRGBO(34, 36, 86, 1),
                              ),

                            ],),
                            SizedBox(height: appConfigblockSizeHeight * 5,)
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  isThereADogName() {
    String dogNameValue;
    if (addDoggoName.text == null) {
      dogNameValue = 'No Named Doggo';
    } else if (addDoggoName.text == "") {
      dogNameValue = 'No Named Doggo';
    } else {
      dogNameValue = addDoggoName.text;
    }
    return dogNameValue;
  }

  isThereABreed() {
    String breedValue;
    if (addDoggoBreed.text == null) {
      breedValue = 'Unknown Breed';
    } else if (addDoggoBreed.text == '') {
      breedValue = 'Unknown Breed';
    } else {
      breedValue = addDoggoBreed.text;
    }
    return breedValue;
  }

  isThereAnAge() {
    String ageValue;
    if (addDoggoAge.text == null) {
      ageValue = 'Doggo has no age';
    } else if (addDoggoAge.text == "") {
      ageValue = 'Doggo has no age';
    } else {
      ageValue = addDoggoAge.text;
    }
    return ageValue;
  }

  isThereAPic() {
    String picturePath;
    if (newImagePath == null) {
      picturePath = 'images/doggo.png';
    } else {
      picturePath = newImagePath;
    }
    return picturePath;
  }


  void _changeAge() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text("Age Change!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("What is the doggos age?"),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Doggo\'s Age',
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
                controller: addDoggoAge,
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
              textColor: Colors.black45,
              onPressed: () {_updateAge();
              Navigator.of(context).pushReplacementNamed(DoggoInfo.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _changeDoggoName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text("Doggo Name Change!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("What is the doggos real name?"),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Doggo\'s Name',
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
                controller: addDoggoName,
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
              textColor: Colors.black45,
              onPressed: () {_updateDoggoName();
              Navigator.of(context).pushReplacementNamed(DoggoInfo.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _changeDoggoBreed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(171, 177, 177, 1),
          title: new Text("Doggo Breed Change!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("What is the doggos real breed?"),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(34, 36, 86, 1),
                decoration: InputDecoration(
                  hintText: 'Doggo\'s Breed',
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
                controller: addDoggoBreed,
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
              textColor: Colors.black45,
              onPressed: () {_updateDoggoBreed();
              Navigator.of(context).pushReplacementNamed(DoggoInfo.id);
              },
            ),
          ],
        );
      },
    );
  }



  isThereASex() {
    var doggoSex;
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
    var doggoFixed;
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
    var doggoTrained;
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
    var doggoGroomed;
    if (isGroomingSwitched == true) {
      doggoGroomed = "is";
      print('Doggo Is Grooming');
    } else if (isGroomingSwitched == false) {
      doggoGroomed = "is not";
      print("Doggo Is Not Grooming");
    }

    return doggoGroomed;
  }



  void _updatePicture() async {


    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnPicture: savedImagePath
    };
    final rowsAffected = await dbHelper.updateDoggos(row);
  }

  void _updateAge() async {


    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnAge: addDoggoAge.text,
    };
    final rowsAffected = await dbHelper.updateDoggos(row);
  }

  void _updateDoggoName() async {


    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnDogName: addDoggoName.text,
    };
    final rowsAffected = await dbHelper.updateDoggos(row);
  }

  void _updateDoggoBreed() async {


    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnBreed: isThereABreed(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _updateFixed() async {


    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnFixed: isDoggoFixed(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _updateSex() async {


    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnSex: isThereASex(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _updateGrooming() async {


    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnGrooming: isDoggoGrooming(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _updateTraining() async {


    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (indexID),
      DatabaseHelper.columnTraining: isDoggoTraining(),
    };
    final rowsAffected = await dbHelper.updateDoggos(row);

    print(rowsAffected);
  }

  void _deleteDoggos() async {

    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.deleteDoggos(indexID);
    print('deleted $rowsDeleted row(s): row $id');
  }
}


