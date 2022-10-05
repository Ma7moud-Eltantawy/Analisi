import 'dart:io';
import 'dart:io' as io;
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../Screens/Object_Detection/object_detector_painter.dart';


class Textdetection_prov with ChangeNotifier{
  File? imgfile;
  String ?text_;
  Map<String,double> objects_={};
  List<String>  objects_keys=[];
  Pickimagefromsource(ImageSource source) async
  {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: source);
    imgfile=File(pickedFile!.path);
    print(imgfile!.path);

    notifyListeners();

  }
  Future<void> processImage(InputImage inputImage) async {
    final TextRecognizer _textRecognizer = TextRecognizer();

      text_ = '';
    final recognizedText = await _textRecognizer.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {


    } else {
      text_ = 'Recognized text:\n\n${recognizedText.text}';
      // TODO: set _customPaint to draw boundingRect on top of image

    }

  }


}