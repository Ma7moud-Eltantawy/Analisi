import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rilevamento/Screens/Object_Detection/detect_offline.dart';
import 'package:rilevamento/styles/Local_Styles.dart';

import '../../Providers/Change_data_prov.dart';
import '../../main.dart';
import '../../styles/icons.dart';
enum ScreenMode { liveFeed, gallery }
class Camera_view extends StatefulWidget {
  const Camera_view({Key? key, required this.title,
    required this.customPaint,
    this.text,
    required this.onImage,
    this.onScreenModeChanged,
    this.initialDirection = CameraLensDirection.back}) : super(key: key);
  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final Function(ScreenMode mode)? onScreenModeChanged;
  final CameraLensDirection initialDirection;

  @override
  State<Camera_view> createState() => _Camera_viewState();
}

class _Camera_viewState extends State<Camera_view> {
  ScreenMode _mode = ScreenMode.liveFeed;
  CameraController? _controller;
  int _cameraIndex = 0;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  final bool _allowPicker = true;
  bool _changingCameraLens = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startLiveFeed();

    if(cameras.any((element) => element.lensDirection==widget.initialDirection && element.sensorOrientation==90))
      {
        _cameraIndex=cameras.indexOf(cameras.firstWhere((element) =>  element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),);

      }
    else {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
              (element) => element.lensDirection == widget.initialDirection,
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light
        ),

        title: Text(widget.title),
        leadingWidth: 0,
        backgroundColor: local_blue,
        leading: Text(widget.title),
        actions: [
          if (_allowPicker)
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).pushNamed(detect_offline.scid);
                },
                child: Consumer<Change_data_prov>(
                  builder:(context,pr,ch)=> IconButton(
                    onPressed: ()
                    {
                      pr.change_flash_mod(pr.flashmod);
                      pr.flashmod==false? _controller?.setFlashMode(FlashMode.off): _controller?.setFlashMode(FlashMode.torch);
                    },
                    icon: Icon(
                       pr.flashmod==false?Icons.flash_off_outlined:Icons.flash_on_outlined,
                    ),
                  ),
                ),
              ),
            ),
          if (_allowPicker)
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: _switchLiveCamera,
                child: Icon(
                   (Platform.isIOS
                      ? IconBroken.Swap
                      : IconBroken.Swap),
                ),
              ),
            ),
        ],

      ),
      body: _body(),

    );
  }

  Widget _body() {
    Widget body;
      body = _liveFeedBody();
    return body;
  }
  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * _controller!.value.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Transform.scale(
            scale: scale,
            child: Center(
              child: _changingCameraLens
                  ? Center(
                child: const Text('Changing camera lens'),
              )
                  : CameraPreview(_controller!),
            ),
          ),
          if (widget.customPaint != null) widget.customPaint!,
          Positioned(
            bottom: size.height/8,
            top: size.height/8,
            left: size.width/size.width,

            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(

                value: zoomLevel,
                min: minZoomLevel,
                max: maxZoomLevel,
                onChanged: (newSliderValue) {
                  setState(() {
                    zoomLevel = newSliderValue;
                    _controller!.setZoomLevel(zoomLevel);
                  });
                },
                divisions: (maxZoomLevel - 1).toInt() < 1
                    ? null
                    : (maxZoomLevel - 1).toInt(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }
  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }
  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
    Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final imageRotation =
    InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
    InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
          (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
    InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }
}
