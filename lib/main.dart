import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rilevamento/Providers/Removebg_prov.dart';
import 'package:rilevamento/Providers/Settings.dart';
import 'package:rilevamento/Providers/Text_detection_prov.dart';
import 'package:rilevamento/Screens/Home_Screen.dart';
import 'package:rilevamento/Screens/Login_Screen.dart';
import 'package:rilevamento/Screens/Object_Detection/Result_screen.dart';
import 'package:rilevamento/Screens/Object_Detection/live_detect.dart';
import 'package:rilevamento/Screens/Remove_background/remove_bg_result.dart';
import 'package:rilevamento/Screens/Splash.dart';
import 'package:rilevamento/Screens/tourorial.dart';

import 'Providers/Change_data_prov.dart';
import 'Screens/Object_Detection/detect_offline.dart';
import 'Screens/Remove_background/Remove_background.dart';
import 'Screens/Text_detection/text_detector_view.dart';
import 'Screens/Text_detection/textdtection_result.dart';
List<CameraDescription> cameras = [];

void main() async{
  WidgetsFlutterBinding.ensureInitialized();



  cameras = await availableCameras();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value:Change_data_prov() ),
      ChangeNotifierProvider.value(value:RemoveBG_prov() ),
      ChangeNotifierProvider.value(value:Textdetection_prov() ),
      ChangeNotifierProvider.value(value:Settings_prov() ),



    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ANALISI",
      theme: ThemeData(
        fontFamily: 'varela',
      ),
      home: Splash_Screen(),
      //initialRoute:Home_page.scid ,
      routes: {
        Live_detect.scid:(context)=>Live_detect(),
        Home_page.scid:(context)=>Home_page(),
        detect_offline.scid:(context)=>detect_offline(),
        Objectdetection_resuts.scid:(context)=>Objectdetection_resuts(),
        remove_bg_resuts.scid:(context)=>remove_bg_resuts(),
        Textdetection_resuts.scid:(context)=>Textdetection_resuts(),


      },
    ),
  ));
}
