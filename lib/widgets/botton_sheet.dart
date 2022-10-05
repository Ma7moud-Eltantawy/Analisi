import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:provider/provider.dart';
import 'package:rilevamento/styles/Local_Styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Providers/Change_data_prov.dart';
import '../styles/icons.dart';
import 'material_button.dart';

void bottom_sheet(@required BuildContext context,@required double height,@required double width,@required Function func1,@required Function func2)
{
  showBarModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),

        ),
      ), builder: (BuildContext context) =>
      Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Consumer<Change_data_prov>(
              builder:(context,prov,ch)=> Column(
                children: [
                  Text(
                    'Update Data',
                    style: TextStyle(
                      color: local_blue,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25,
                      bottom: 35,
                    ),
                    child: Column(
                      children: [
                        Mbutton(width: width, height: height, colors: [ Color.fromRGBO(147, 212, 255, 1.0),
                          local_cyan,
                          local_cyan,
                          local_blue,
                          local_blue], txt: "Take a picture", wid: Icon(IconBroken.Camera,color: Colors.white,), func: ()=>()async{
                          func1();
                        }
                        ),
                        SizedBox(height: height/30,),

                        Mbutton(width: width, height: height, colors: [ Color.fromRGBO(147, 212, 255, 1.0),
                          local_cyan,
                          local_cyan,
                          local_blue,
                          local_blue], txt: "From Gallery", wid: Icon(IconBroken.Image,color: Colors.white,), func: ()=>()async{
                          func2();
                        }
                        )

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      context: context
  );
}