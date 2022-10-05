import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:path/path.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../Screens/Object_Detection/object_detector_painter.dart';


class Change_data_prov with ChangeNotifier{
  bool flashmod=false;
  File? imgfile;
  String ?text_;
  Map<String,double> objects_={};
  List<String>  objects_keys=[];
  void change_flash_mod(bool val)
  {
    flashmod= !val;
    notifyListeners();
  }
  Pickimagefromsource(ImageSource source) async
  {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: source);
    imgfile=File(pickedFile!.path);
    print(imgfile!.path);

    notifyListeners();

  }
  Future<void> processImage(InputImage inputImage) async {
   text_="";
   final path = 'assets/ml/object_labeler.tflite';
   final modelPath = await _getModel(path);
   final options = LocalObjectDetectorOptions(
     mode: DetectionMode.single,
     modelPath: modelPath,
     classifyObjects: true,
     multipleObjects: true,
   );
   ObjectDetector _objectDetector = ObjectDetector(options: options);
    final objects = await _objectDetector.processImage(inputImage);
   String text = 'Objects found: ${objects.length}\n\n';
   try
   {
     objects_keys.clear();
     objects_.clear();
   }
   catch(e)
    {}



   for (final object in objects) {

     text +=
     'Object:  trackingId: ${object.labels.map((e) => e.text) } - ${object.labels.map((e) => e.confidence)} \n\n';
     for(var x in object.labels)
       {
         print(x.text);
         objects_keys.add(x.text);
         objects_.putIfAbsent(x.text, () => x.confidence);

       }


   }
   text_ = text;
   print(objects_keys.length.toString());





  }

  Future<String> _getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
  int Start=30;
  void startTimer() {

    const oneSec = const Duration(seconds: 1);
    Timer _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (Start == 0) {

            timer.cancel();
        } else {
          Start--;

        }
      },
    );
    notifyListeners();
  }



}