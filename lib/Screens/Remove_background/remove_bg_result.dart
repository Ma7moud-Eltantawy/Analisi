import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rilevamento/styles/icons.dart';
import 'package:rilevamento/widgets/material_button.dart';

import '../../Providers/Change_data_prov.dart';
import '../../Providers/Removebg_prov.dart';
import '../../styles/Local_Styles.dart';
class remove_bg_resuts extends StatefulWidget {
  const remove_bg_resuts({Key? key}) : super(key: key);
  static const scid="remove_bg_results";

  @override
  State<remove_bg_resuts> createState() => _remove_bg_resutsState();
}

class _remove_bg_resutsState extends State<remove_bg_resuts> {
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
        future:  Provider.of<RemoveBG_prov>(context,listen: false).Remove_bg(File(Provider.of<Change_data_prov>(context,listen: false).imgfile!.path)),
        builder:(context,snapshot)=>snapshot.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator(),):Consumer<RemoveBG_prov>(
          builder:(context,prov,ch)=> prov.img==null?Center(child:Text("USER_CREDIT_ERROR")):Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              prov.img!.toString()!=""
                  ? Hero(
                tag:Provider.of<Change_data_prov>(context,listen: false).imgfile!.path,
                child: Stack(
                  children: [

                    Container(
                      height: height/2.5,
                      width: width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(prov.img!),
                            fit: BoxFit.contain,
                          )
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: width/50,
                        child: GestureDetector(
                          onTap: ()async{
                            var response = await Dio().get(
                                prov.img!,
                                options: Options(responseType: ResponseType.bytes));
                            final result = await ImageGallerySaver.saveImage(
                                Uint8List.fromList(response.data),
                                quality: 80,
                                name: prov.img!.split("/").first
                            );
                            Fluttertoast.showToast(
                                msg: "Image saved",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black26,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            print(result);

                          },
                          child: Column(
                            children: [
                              Icon(IconBroken.Download,color: local_blue,),
                              Container(child: Text("Download",style: TextStyle(color: local_blue),)),
                            ],
                          ),
                        )),
                  ],
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
                  child: Text('Another Removal Background'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

}

