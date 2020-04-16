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
import 'package:daniellesdoggrooming/screens/doggos.dart';

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

  final addDoggoName = TextEditingController();
  final addOwnerName = TextEditingController();
  final addDoggoAge = TextEditingController();


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


    String labelgallery = '${random.Number()}${addDoggoName.text}gallery.jpg';

    myCompressedFile = new File(appDocPath + '$labelgallery')
      ..writeAsBytesSync(img.encodeJpg(thumbnail));
    print(appDocPath + '$labelgallery');
    newImagePath = myCompressedFile.path;
    print(newImagePath);

    final File copiedImage = await myCompressedFile.copy(
        '$appDocPath/$labelgallery');

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

    String labelcamera = '${random.Number()}${addDoggoName.text}camera.jpg';

    myCompressedFile = new File(appDocPath + '$labelcamera')
      ..writeAsBytesSync(img.encodeJpg(thumbnail));
    print(appDocPath + '$labelcamera');
    newImagePath = myCompressedFile.path;

    print(newImagePath);

    final File copiedImage = await myCompressedFile.copy(
        '$appDocPath/$labelcamera');

    print(copiedImage.path);
    savedImagePath = copiedImage.path;
    setState(() {
      previewImage = copiedImage;
    });

    return previewImage;
  }

  final dbHelper = DatabaseHelper.instance;

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 66, 145, 1),
        title: Text(
          'Add A Doggo', style: TextStyle(
            color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(height: appConfigblockSizeHeight * 100,
          color: Color.fromRGBO(255, 187, 204, 1),
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
                        TextField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Color.fromRGBO(245, 66, 145, 1),
                          decoration: InputDecoration(
                            hintText: 'Doggo\'s Name',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.white),
                            ),
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(245, 66, 145, 1),),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(245, 66, 145, 1),
                                  width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(245, 66, 145, 1),
                                  width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                            ),
                            icon: Icon(
                              FontAwesomeIcons.dog,
                              color: Color.fromRGBO(245, 66, 145, 1),
                            ),),
                          textAlign: TextAlign.center,
                          controller: addDoggoName,
                        ),
                        SizedBox(height: appConfigblockSizeHeight * 2,),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Color.fromRGBO(245, 66, 145, 1),
                          decoration: InputDecoration(
                            hintText: 'Owner\'s Name',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.white),
                            ),
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(245, 66, 145, 1),),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(245, 66, 145, 1),
                                  width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(245, 66, 145, 1),
                                  width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                            ),
                            icon: Icon(Icons.person,
                              color: Color.fromRGBO(245, 66, 145, 1),
                            ),),
                          textAlign: TextAlign.center,
                          controller: addOwnerName,
                        ),
                        SizedBox(height: appConfigblockSizeHeight * 2,),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Color.fromRGBO(245, 66, 145, 1),
                          decoration: InputDecoration(
                            hintText: 'Doggo\'s Age',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.white),
                            ),
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(245, 66, 145, 1),),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(245, 66, 145, 1),
                                  width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(245, 66, 145, 1),
                                  width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(35.0)),
                            ),
                            icon: Icon(
                              FontAwesomeIcons.solidHourglass,
                              color: Color.fromRGBO(245, 66, 145, 1),
                            ),),
                          textAlign: TextAlign.center,
                          controller: addDoggoAge,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: appConfigblockSizeWidth * 10,
                    ),
                    Container(height: appConfigblockSizeWidth * 40,
                      child: Container(
                        child: previewImage == null
                            ? Image(
                          image: AssetImage('images/doggo.png'),
                        )
                            : Image(
                          image: AssetImage(newImagePath),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: appConfigblockSizeWidth * 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: FloatingActionButton(
                            backgroundColor: Color.fromRGBO(245, 66, 145, 1),
                            onPressed: () {
                              _getImage();
                            },
                            heroTag: 'image1',
                            tooltip: 'Pick a photo',
                            child: const Icon(
                              Icons.photo_library,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: appConfigblockSizeWidth * 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: FloatingActionButton(
                            backgroundColor: Color.fromRGBO(245, 66, 145, 1),
                            onPressed: () {
                              _takeImage();
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
                        color: Color.fromRGBO(245, 66, 145, 1),
                        onPressed: () {
                          _insert();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Doggos()));
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


  isThereADogName() {
    String dogNameValue;
    if (addDoggoName.text == null) {
      dogNameValue = 'Nameless :(';
    } else if (addDoggoName.text == "") {
      dogNameValue = 'Nameless :(';
    }
    else {
      dogNameValue = addDoggoName.text;
    }
    return dogNameValue;
  }

  isThereAName() {
    String nameValue;
    if (addOwnerName.text == null) {
      nameValue = 'No Named Owner';
    } else if (addOwnerName.text == ''){nameValue = 'No Named Owner';}  else {
      nameValue = addOwnerName.text;
    }
    return nameValue;
  }

  isThereAnAge() {

    String ageValue;
    if (addDoggoAge.text == null) {
      ageValue = '?';
    } else if (addDoggoAge.text == "") {
      ageValue = '?';
    }
    else {
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

  void _insert() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('doggosFirstLaunch', false);
    prefs.setBool('isFirstLaunch', false);

    Map<String, dynamic> row = {
      DatabaseHelper.columnDogName: '${isThereADogName()}',
      DatabaseHelper.columnName: '${isThereAName()}',
      DatabaseHelper.columnAge: '${isThereAnAge()}',
      DatabaseHelper.columnPicture: '${isThereAPic()}',
    };
    final id = await dbHelper.insertDoggos(row);
    print('inserted row id: $id');
  }
}