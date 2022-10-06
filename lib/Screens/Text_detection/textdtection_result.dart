import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rilevamento/Providers/Text_detection_prov.dart';
import 'package:rilevamento/styles/icons.dart';
import 'package:rilevamento/widgets/material_button.dart';

import '../../Providers/Change_data_prov.dart';
import '../../Providers/Removebg_prov.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../styles/Local_Styles.dart';
class Textdetection_resuts extends StatefulWidget {
  const Textdetection_resuts({Key? key}) : super(key: key);
  static const scid="textdet_results";


  @override
  State<Textdetection_resuts> createState() => _Textdetection_resuts();
}

class _Textdetection_resuts extends State<Textdetection_resuts> {
  final ScrollController _scrollcontroller=new ScrollController();
  var imgfile;


  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: local_blue,
        title: Text("Results"),
      ),
      body: FutureBuilder(
        future:  Provider.of<Textdetection_prov>(context,listen: false).processImage(InputImage.fromFilePath(Provider.of<Textdetection_prov>(context,listen: false).imgfile!.path)),
        builder:(context,snapshot)=>snapshot.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator(),):Consumer<Textdetection_prov>(
          builder:(context,prov,ch)=> prov.text_==null?Center(child:Text("there is no text..")):Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              prov.text_!.toString()!=""
                  ? Container(
                    child: Scrollbar(
                      isAlwaysShown: true,controller: _scrollcontroller,

                      child: ListView(
                          controller:_scrollcontroller ,
                          children:[ Text(prov.text_!)]),
                    ),
                    margin: EdgeInsets.all(width/20),
                    padding: EdgeInsets.all(width/100),
                    height: height/1.5,
                    width: width,
                    decoration: BoxDecoration(
                        border: Border.all(width: width/100,color: local_blue)
                    ),
                  )
                  : Icon(
                Icons.image,
                size: 200,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(local_blue),
                  ),
                  child: Text('Another text detection'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(local_blue),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Copy Text'),
                      SizedBox(width: width/70,),
                      Icon(Icons.copy,size: width/20,),
                    ],
                  ),
                  onPressed: () async{
                   await Clipboard.setData(ClipboardData(text: prov.text_));
                    Fluttertoast.showToast(
                        msg: "Text Copied",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black26,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );


                  }
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

}

