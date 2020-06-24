import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:daniellesdoggrooming/database/database_logic.dart';
import 'package:uuid/uuid.dart';
import 'package:daniellesdoggrooming/screens/supplies.dart';


class random {
  static final Random _random = Random.secure();

  static String Number([int length = 6]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }
}


class AddSupply extends StatefulWidget {
  static const String id = 'addsupply';

  @override
  _AddSupplyState createState() => _AddSupplyState();
}

class _AddSupplyState extends State<AddSupply> with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final dbHelper = DatabaseHelper.instance;

  String tempPath;
  String previewPath;
  File previewImage;
  String newImagePath;
  String savedImagePath;

  final addSupplyType = TextEditingController();
  final addSupplyName = TextEditingController();
  final addSupplyLevel = TextEditingController();

  var uuid = Uuid();


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

    String labelgallery = '${random.Number()}${addSupplyName.text}gallery.jpg';

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

    String labelcamera = '${random.Number()}${addSupplyName.text}camera.jpg';

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

    return previewImage;
  }





  @override
  Widget build(BuildContext context) {
    double appConfigWidth = MediaQuery
        .of(context)
        .size
        .width;
    double appConfigHeight = MediaQuery
        .of(context)
        .size
        .height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;
    double fontSize = appConfigWidth * 0.005;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(34, 36, 86, 1),
        title: Text(
          'Add A Supply', style: TextStyle(
            color: Colors.white),
        ),leading: new Container(),
      ),
      body: SingleChildScrollView(
        child: Container(height: appConfigblockSizeHeight * 100,
          color: Color.fromRGBO( 171, 177, 177, 1),
          child: Center(child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 50.0, left: 50.0, top: 20, bottom: 20),
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: appConfigblockSizeWidth * 10,
                    ),
                    Column(
                      children: [
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Color.fromRGBO(34, 36, 86, 1),
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: appConfigblockSizeHeight * 2, horizontal: appConfigblockSizeWidth * 2),
                            hintText: 'Supply Type',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.white),
                            ),
                            hintStyle: TextStyle(
                              fontSize: fontSize * 8,
                              color: Color.fromRGBO(34, 36, 86, 1),),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                  width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                  width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                            ),
                            icon: Icon(
                              FontAwesomeIcons.dog,
                              color: Color.fromRGBO(34, 36, 86, 1),
                            ),),
                          textAlign: TextAlign.center,
                          controller: addSupplyType,
                        ),
                        SizedBox(height: appConfigblockSizeHeight * 2,),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Color.fromRGBO(34, 36, 86, 1),
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: appConfigblockSizeHeight * 2, horizontal: appConfigblockSizeWidth * 2),
                            hintText: 'Brand Name',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.white),
                            ),
                            hintStyle: TextStyle(
                              fontSize: fontSize * 8,
                              color: Color.fromRGBO(34, 36, 86, 1),),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                  width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                  width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                            ),
                            icon: Icon(Icons.person,
                              color: Color.fromRGBO(34, 36, 86, 1),
                            ),),
                          textAlign: TextAlign.center,
                          controller: addSupplyName,
                        ),
                        SizedBox(height: appConfigblockSizeHeight * 2,),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Color.fromRGBO(34, 36, 86, 1),
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: appConfigblockSizeHeight * 2, horizontal: appConfigblockSizeWidth * 2),
                            hintText: 'Supply Level',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.white),
                            ),
                            hintStyle: TextStyle(
                              fontSize: fontSize * 8,
                              color: Color.fromRGBO(34, 36, 86, 1),),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                  width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(34, 36, 86, 1),
                                  width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                            ),
                            icon: Icon(
                              FontAwesomeIcons.solidHourglass,
                              color: Color.fromRGBO(34, 36, 86, 1),
                            ),),
                          textAlign: TextAlign.center,
                          controller: addSupplyLevel,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: appConfigblockSizeWidth * 10,
                    ),
                    FlatButton(
                      onPressed: () {
                        _addPhoto();
                      },
                      child: Container(
                        child:  previewImage == null ?
                        CircleAvatar(backgroundImage: AssetImage('images/supply_add.png'), backgroundColor: Colors.transparent, radius: appConfigblockSizeWidth * 20,) :
                        CircleAvatar(backgroundImage: FileImage(previewImage), backgroundColor: Colors.transparent, radius: appConfigblockSizeWidth * 20,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: appConfigblockSizeWidth * 5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2, right: 2, top: 3),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        textColor: Colors.white,
                        color: Color.fromRGBO(34, 36, 86, 1),
                        onPressed: () {
                          _insert();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Supplies()));
                        },
                        child: Center(
                          child: Text('Add Now!',
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
      nameValue = 'No Named Brand';
    } else if (addSupplyName.text == ''){nameValue = 'No Named Brand';}  else {
      nameValue = addSupplyName.text;
    }
    return nameValue;
  }

  isThereALevel() {

    var supplyLevelValue;
    if (addSupplyLevel.text == null) {
      supplyLevelValue = 100;
    } else if (addSupplyLevel.text == "") {
      supplyLevelValue = 100;
    }
    else {
      supplyLevelValue = addSupplyLevel.text;
    }

    return supplyLevelValue;
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

  uniqueIDGenerated(){

    var uuiddog;

    uuiddog = uuid.v1();

    return uuiddog;

  }

  void _insert() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('suppliesFirstLaunch', false);
    prefs.setBool('isFirstLaunch', false);

    Map<String, dynamic> row = {
      DatabaseHelper.columnSupplyUniqueId: '${uniqueIDGenerated()}',
      DatabaseHelper.columnType: '${isThereAType()}',
      DatabaseHelper.columnBrand: '${isThereABrand()}',
      DatabaseHelper.columnLevel: '${isThereALevel()}',
      DatabaseHelper.columnPicture: '${isThereAPic()}',
    };
    final id = await dbHelper.insertSupplies(row);
    print('inserted row id: $id');
  }

}