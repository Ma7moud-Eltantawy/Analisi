import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rilevamento/Providers/Change_data_prov.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rilevamento/Screens/Object_Detection/Result_screen.dart';
import 'package:rilevamento/styles/Local_Styles.dart';
import 'package:rilevamento/widgets/botton_sheet.dart';

import '../../styles/icons.dart';
class detect_offline extends StatefulWidget {
  const detect_offline({Key? key}) : super(key: key);
  static const scid="offline_object";

  @override
  State<detect_offline> createState() => _detect_offlineState();
}

class _detect_offlineState extends State<detect_offline> {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: local_blue,
        title: Text("Offline analysis"),
      ),
      body: Consumer<Change_data_prov>(
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
                  image: DecorationImage(
                    image: FileImage(prov.imgfile!),
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
                onPressed: () => prov.imgfile!=null?Navigator.of(context).pushNamed(Objectdetection_resuts.scid):null,
              ),
            ),],
        ),
      )
    );
  }

}
