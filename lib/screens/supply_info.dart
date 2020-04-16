import 'package:daniellesdoggrooming/screens/supplies.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'dart:io';
import 'dart:math';
import 'dart:convert';

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

class SupplyInfo extends StatefulWidget {
  static const String id = 'supplyinfo';

  @override
  _SupplyInfoState createState() => _SupplyInfoState();
}

class _SupplyInfoState extends State<SupplyInfo> with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  var supplyStringID;
  var supplyID;
  List data;

  Future<String> fetchDogs() async {
    var database = await openDatabase('database.db');
    var thing = await database.rawQuery('SELECT * FROM supplies');

    setState(() {
      var extractdata = thing;
      data = extractdata;
      return data.toList();
    });
  }

  String tempPath;
  String previewPath;
  File previewImage;
  String newImagePath;
  String savedImagePath;

  final addSupplyType = TextEditingController();
  final addSupplyName = TextEditingController();
  final addSupplyLevel = TextEditingController();

  void _photoLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 5), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(255, 217, 235, 1),
          content: Container(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                new Text('  '),
                new CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
                ),
                new Text('  '),
                new Text("Processing photo."),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  ////////////ERROR POPUP////////////////
  void _noDoggoNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(255, 217, 235, 1),
          title: new Text("Whoops! Big Mistake!"),
          content: new Text("You didn't put a name for the doggo"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              textColor: Colors.black45,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _noOwnerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(255, 217, 235, 1),
          title: new Text("Whoops! Big Mistake!"),
          content: new Text("You didn't put a name for the owner"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              textColor: Colors.black45,
              onPressed: () {
//                Navigator.pushNamed(context, AddDoggos.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(255, 217, 235, 1),
          content: Container(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                new Text('  '),
                new CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
                ),
                new Text('  '),
                new Text("Adding Doggo"),
              ],
            ),
          ),
        );
      },
    );
  }

  /////////GALLERY IMAGE SELECTOR AND RESIZER//////
  File rawGalleryImage;

  Future _getImage() async {
    Directory tempDir = await getTemporaryDirectory();
    tempPath = tempDir.path;
    _photoLoading();

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    var galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    print("Path : " + galleryImage.path);
    rawGalleryImage = galleryImage;

    File myCompressedFile;
    img.Image image = img.decodeImage(rawGalleryImage.readAsBytesSync());

    img.Image thumbnail = img.copyResize(image, height: 200);

    String labelgallery = '${random.Number()}${addSupplyType.text}gallery.jpg';

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
    _photoLoading();

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

    String labelcamera = '${random.Number()}${addSupplyType.text}camera.jpg';

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

  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    this.fetchDogs();
    loadsupplyID().then((supplyID) {
      setState(() {
        supplyID = supplyID;
      });
    });
    super.initState();
  }

  int doggoIntID;
  int doggoIndex;

  loadsupplyID() async {
    SharedPreferences doggoinfo = await SharedPreferences.getInstance();
    supplyStringID = doggoinfo.getString('supplyID') ?? '';
    doggoIntID = int.parse(supplyStringID);
    doggoIndex = (doggoIntID - 1);
    supplyID = doggoIndex;
    return (supplyID);
  }

  @override
  Widget build(BuildContext context) {
    double appConfigWidth = MediaQuery.of(context).size.width;
    double appConfigHeight = MediaQuery.of(context).size.height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 66, 145, 1),
        title: Text(
          'About This Supply',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () => Navigator.pushNamed(context, Supplies.id),
          ),
        ],
        leading: new Container(),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: appConfigblockSizeHeight * 100,
          color: Color.fromRGBO(255, 187, 204, 1),
          child: Center(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 50.0, left: 50.0, top: 20, bottom: 20),
                child: Container(
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                
                                SizedBox(
                                  height: appConfigblockSizeHeight * 6.5,
                                ),
                                FlatButton(
                                  onPressed: () {
                                    _changeSupplyType();
                                  },
                                  child: Container(
                                    child: Text(
                                      data[supplyID]["supply_type"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 25),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          child: FlatButton(
                            onPressed: () {
                              _changeSupplyLevel();
                            },
                            child: Container(
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text(
                                    (data[supplyID]["level"]).toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                        ),
                        FlatButton(
                          onPressed: () {
                            _addPhoto();
                          },
                          child: Container(
                            child:  previewImage == null ?
                            CircleAvatar(backgroundImage: AssetImage(data[supplyID]['picture']), backgroundColor: Colors.transparent, radius: appConfigblockSizeWidth * 20,) :
                            CircleAvatar(backgroundImage: FileImage(previewImage), backgroundColor: Colors.transparent, radius: appConfigblockSizeWidth * 20,
                            ),
                          ),
                          ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "This stuff is made by...",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 1,
                        ),
                        FlatButton(
                          onPressed: () {
                            _changeBrandName();
                          },
                          child: Container(
                            child: Text(
                              data[supplyID]["brand_name"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
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
      ),
    );
  }

  isThereAType() {
    String dogNameValue;
    if (addSupplyType.text == null) {
      dogNameValue = 'No Type';
    } else if (addSupplyType.text == "") {
      dogNameValue = 'No Type';
    }
    else {
      dogNameValue = addSupplyType.text;
    }
    return dogNameValue;
  }

  isThereABrand() {
    String nameValue;
    if (addSupplyName.text == null) {
      nameValue = 'No Name Brand';
    } else if (addSupplyName.text == ''){nameValue = 'No Name Brand';}  else {
      nameValue = addSupplyName.text;
    }
    return nameValue;
  }

  isThereALevel() {

    String ageValue;
    if (addSupplyLevel.text == null) {
      ageValue = 'Level Unknown';
    } else if (addSupplyLevel.text == "") {
      ageValue = 'Level Unknown';
    }
    else {
      ageValue = addSupplyLevel.text;
    }

    return ageValue;
  }

  isThereAPic() {
    String picturePath;
    if (newImagePath == null) {
      picturePath = 'images/supply.png';
    } else {
      picturePath = newImagePath;
    }
    return picturePath;
  }

  void _changeSupplyLevel() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(255, 217, 235, 1),
          title: new Text("Level Change!"),
          content: Column(
            children: <Widget>[
              Text("What is the current level?"),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(245, 66, 145, 1),
                decoration: InputDecoration(
                  hintText: 'Supply Level',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(245, 66, 145, 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(245, 66, 145, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(245, 66, 145, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.solidHourglass,
                    color: Color.fromRGBO(245, 66, 145, 1),
                  ),
                ),
                textAlign: TextAlign.center,
                controller: addSupplyLevel,
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
              onPressed: () {_updateSupplyLevel();
              Navigator.of(context).pushReplacementNamed(SupplyInfo.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _changeSupplyType() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(255, 217, 235, 1),
          title: new Text("Supply Type Change!"),
          content: Column(
            children: <Widget>[
              Text("What is the supplies real type?"),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(245, 66, 145, 1),
                decoration: InputDecoration(
                  hintText: 'Supply Type',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(245, 66, 145, 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(245, 66, 145, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(245, 66, 145, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.solidHourglass,
                    color: Color.fromRGBO(245, 66, 145, 1),
                  ),
                ),
                textAlign: TextAlign.center,
                controller: addSupplyType,
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
              onPressed: () {_updateSupplyType();
              Navigator.of(context).pushReplacementNamed(SupplyInfo.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _changeBrandName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(255, 217, 235, 1),
          title: new Text("Brand Name Change!"),
          content: Column(
            children: <Widget>[
              Text("What is the brands real name?"),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromRGBO(245, 66, 145, 1),
                decoration: InputDecoration(
                  hintText: 'Brand\'s Name',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(245, 66, 145, 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(245, 66, 145, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(245, 66, 145, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.solidHourglass,
                    color: Color.fromRGBO(245, 66, 145, 1),
                  ),
                ),
                textAlign: TextAlign.center,
                controller: addSupplyName,
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
              onPressed: () {_updateSupplyBrand();
              Navigator.of(context).pushReplacementNamed(SupplyInfo.id);
              },
            ),
          ],
        );
      },
    );
  }

  void _addPhoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Color.fromRGBO(255, 217, 235, 1),
          title: new Text("Add a photo!"),
          content: Container(child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FloatingActionButton(
                    backgroundColor: Color.fromRGBO(245, 66, 145, 1),
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
                    backgroundColor: Color.fromRGBO(245, 66, 145, 1),
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
              textColor: Colors.black45,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }



  void _updatePicture() async {


    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (supplyID + 1),
      DatabaseHelper.columnPicture: savedImagePath
    };
    final rowsAffected = await dbHelper.updateSupplies(row);
  }

  void _updateSupplyLevel() async {


    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (supplyID + 1),
      DatabaseHelper.columnLevel: addSupplyLevel.text,
    };
    final rowsAffected = await dbHelper.updateSupplies(row);
  }

  void _updateSupplyType() async {


    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (supplyID + 1),
      DatabaseHelper.columnType: addSupplyType.text,
    };
    final rowsAffected = await dbHelper.updateSupplies(row);
  }

  void _updateSupplyBrand() async {


    Map<String, dynamic> row = {
      DatabaseHelper.columnId: (supplyID + 1),
      DatabaseHelper.columnBrand: addSupplyName.text,
    };
    final rowsAffected = await dbHelper.updateSupplies(row);
  }











}


