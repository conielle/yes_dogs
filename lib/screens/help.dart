import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:daniellesdoggrooming/screens/home.dart';
import 'package:daniellesdoggrooming/screens/doggos.dart';
import 'package:daniellesdoggrooming/screens/appointments.dart';
import 'package:daniellesdoggrooming/screens/supplies.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';


class Help extends StatefulWidget {
  static const String id = 'help';

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> with TickerProviderStateMixin {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'images/yes_dogs_help.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }


  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    double appConfigWidth = MediaQuery.of(context).size.width;
    double appConfigHeight = MediaQuery.of(context).size.height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;
    double fontSize = appConfigWidth * 0.005;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(34, 36, 86, 1),
        title: Text(
          'Help With Backup & Restore',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(34, 36, 86, 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('You can scroll up and down', style: TextStyle(color: Colors.white),),
              SizedBox(height: appConfigblockSizeHeight * 0.5,),
              Center(
                child: _controller.value.initialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : Container(),
              ),
              RawMaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'home');
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.home, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
