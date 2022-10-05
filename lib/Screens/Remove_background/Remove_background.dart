import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rilevamento/Providers/Removebg_prov.dart';
import 'package:rilevamento/Screens/Remove_background/remove_bg_result.dart';
import 'package:rilevamento/styles/icons.dart';

import '../../Providers/Change_data_prov.dart';
import '../../styles/Local_Styles.dart';
import '../../widgets/botton_sheet.dart';
import '../Object_Detection/Result_screen.dart';
class Remove_background_screen extends StatefulWidget {
  const Remove_background_screen({Key? key}) : super(key: key);
  static const scid="removebackground";

  @override
  State<Remove_background_screen> createState() => _Remove_background_screenState();
}

class _Remove_background_screenState extends State<Remove_background_screen> {
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

          'Remove background',
          style: TextStyle(
              color: local_blue
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
        body:  Consumer<Change_data_prov>(
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
                    onPressed: () => bottom_sheet(context, height, width,()=>prov.Pickimagefromsource(ImageSource.gallery),()=>prov.Pickimagefromsource(ImageSource.gallery)),

                  ),
                ),

                Padding(

                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(prov.imgfile!=null?local_blue:Colors.black12.withOpacity(.00001)),
                    ),

                    child: Text('Show analysis results'),
                    onPressed: () => prov.imgfile!=null?Navigator.of(context).pushNamed(remove_bg_resuts.scid):null,
                  ),
                ),],
            ),
          ),

    );
  }
}
