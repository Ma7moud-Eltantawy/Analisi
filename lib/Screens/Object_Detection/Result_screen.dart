import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../Providers/Change_data_prov.dart';
import '../../styles/Local_Styles.dart';
class Objectdetection_resuts extends StatefulWidget {
  const Objectdetection_resuts({Key? key}) : super(key: key);
  static const scid="offline_object_results";

  @override
  State<Objectdetection_resuts> createState() => _Objectdetection_resutsState();
}

class _Objectdetection_resutsState extends State<Objectdetection_resuts> {
  var imgfile;


  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;

    Random random = new Random();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: local_blue,
        title: Text("Results"),
      ),
      body: FutureBuilder(
        future:  Provider.of<Change_data_prov>(context,listen: false).processImage(InputImage.fromFilePath(Provider.of<Change_data_prov>(context,listen: false).imgfile!.path)),
        builder:(context,snapshot)=>snapshot.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator(),): Provider.of<Change_data_prov>(context,listen: false).objects_keys.length==0?Center(child:Text( "objects not found"),):Consumer<Change_data_prov>(
          builder:(context,prov,ch)=> ListView(shrinkWrap: true, children: [
            prov.imgfile != null
                ? Hero(
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
                child: Text('Another analysis'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            if (prov.imgfile != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:prov.objects_keys.length,
                        itemBuilder: (context,index){
                          return Column(
                            children: [
                              Text("${prov.objects_keys[index]}"),
                              Container(
                                height: 20,
                                margin: EdgeInsets.symmetric(vertical: 2),
                                child: new LinearPercentIndicator(
                                  width: MediaQuery.of(context).size.width - 50,
                                  animation: true,
                                  lineHeight: 20.0,
                                  animationDuration: 2500,
                                  percent:
                                  prov.objects_['${prov.objects_keys[index].toString()}']!.toDouble(),
                                  center: Text("${(prov.objects_['${prov.objects_keys[index].toString()}']!*100).toInt()}%"),
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: Color.fromRGBO(random.nextInt(255), random.nextInt(255),random.nextInt(255), 1),
                                ),
                              ),
                            ],
                          );

                        }),
                  ],
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
