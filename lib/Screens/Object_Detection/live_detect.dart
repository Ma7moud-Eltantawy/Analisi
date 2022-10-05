import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rilevamento/Screens/Object_Detection/Camera_view.dart';
import 'package:rilevamento/Screens/Object_Detection/object_detector_painter.dart';
import 'package:path/path.dart';

import 'dart:io' as io;

class Live_detect extends StatefulWidget {
  const Live_detect({Key? key}) : super(key: key);
  static const scid="Live_detect";


  @override
  State<Live_detect> createState() => _Live_detect();
}
enum ScreenMode { liveFeed, gallery }
class _Live_detect extends State<Live_detect> {
  late ObjectDetector _objectDetector;
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeDetector(DetectionMode.stream);
  }
  @override
  void dispose() {
    _canProcess = false;
    _objectDetector.close();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Camera_view(
      title: 'Object Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);
      },
      onScreenModeChanged: (mode)=>_onScreenModeChanged,
      initialDirection: CameraLensDirection.back,
    );
  }
  void _onScreenModeChanged(ScreenMode mode) {
    switch (mode) {
      case ScreenMode.gallery:
        _initializeDetector(DetectionMode.single);
        return;

      case ScreenMode.liveFeed:
        _initializeDetector(DetectionMode.stream);
        return;
    }
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    final objects = await _objectDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = ObjectDetectorPainter(
          objects,
          inputImage.inputImageData!.imageRotation,
          inputImage.inputImageData!.size);
      _customPaint = CustomPaint(painter: painter);
    } else {
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
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
  void _initializeDetector(DetectionMode mode) async {
    print('Set detector in mode: $mode');

    final path = 'assets/ml/object_labeler.tflite';
    final modelPath = await _getModel(path);
    final options = LocalObjectDetectorOptions(
      mode: mode,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
    _canProcess = true;
  }

}
