import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:rilevamento/Screens/Object_Detection/detect_offline.dart';
import 'package:rilevamento/Screens/Object_Detection/live_detect.dart';
import 'package:rilevamento/Screens/Remove_background/Remove_background.dart';
import 'package:rilevamento/Screens/Text_detection/text_detector_view.dart';
import 'package:rilevamento/styles/Local_Styles.dart';

import '../styles/icons.dart';
import 'Settings.dart';
class Home_page extends StatefulWidget {
  static const scid="home_page";

  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}


class _Home_pageState extends State<Home_page> {
  int act_index=0;
  List<Widget> wid=[
    Live_detect(),
    Remove_background_screen(),
    TextRecognizerView(),
    Settings(),
    Live_detect(),
  ];
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Platform.isIOS
              ? IconBroken.Image_2
              : IconBroken.Image_2,
          size: 35,
        ),
        onPressed: (){
          Navigator.of(context).pushNamed(detect_offline.scid);
        },
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: height/11,
        activeColor:local_cyan ,
        inactiveColor: Colors.white,
        icons: [IconBroken.Scan,IconBroken.Image,IconBroken.Edit_Square,IconBroken.Setting],

        backgroundColor: local_blue,
        activeIndex: act_index,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.sharpEdge,
        leftCornerRadius: width/30,
        rightCornerRadius: width/30,
        onTap: (index) => setState(() => act_index = index),
        //other params
      ),
      body: wid[act_index],
    );
  }

}
