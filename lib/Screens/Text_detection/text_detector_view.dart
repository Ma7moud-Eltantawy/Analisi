import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rilevamento/Providers/Text_detection_prov.dart';
import 'package:rilevamento/Screens/Text_detection/textdtection_result.dart';
import 'package:rilevamento/styles/icons.dart';

import '../../styles/Local_Styles.dart';
import '../../widgets/botton_sheet.dart';
import '../Object_Detection/Camera_view.dart';


class TextRecognizerView extends StatefulWidget {
  @override
  _TextRecognizerViewState createState() => _TextRecognizerViewState();
}

class _TextRecognizerViewState extends State<TextRecognizerView> {
  final TextRecognizer _textRecognizer = TextRecognizer();
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;


  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(

          'Text Recognition',
          style: TextStyle(
              color: local_blue
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body:  Consumer<Textdetection_prov>(
        builder:(context,prov,ch)=> Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [ prov.imgfile != null
              ?  Hero(
            tag: prov.imgfile!.path,
            child: Container(
              height: height/2.5,
              width: width,
              decoration: BoxDecoration(
                  image:DecorationImage(
                    image:FileImage(prov.imgfile!),
                    fit: BoxFit.contain,
                  )
              ),
            ),
          )
              : Padding(
            padding: EdgeInsets.symmetric(vertical: height/20),
            child: Icon(
              IconBroken.Image_2,
              color: Colors.black26,
              size: 150,
            ),
          ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(local_blue),
                ),
                child: Text('Add Picture'),
                onPressed: () => bottom_sheet(context, height, width,()=>prov.Pickimagefromsource(ImageSource.camera),()=>prov.Pickimagefromsource(ImageSource.gallery)),
              ),
            ),

            Padding(

              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(prov.imgfile!=null?local_blue:Colors.black12.withOpacity(.00001)),
                ),

                child: Text('Show analysis results'),
                onPressed: () =>prov.imgfile!=null?Navigator.of(context).pushNamed(Textdetection_resuts.scid): null,
              ),
            ),],
        ),
      ),

    );
  }


}
