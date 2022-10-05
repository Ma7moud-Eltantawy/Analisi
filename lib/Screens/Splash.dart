import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:provider/provider.dart';
import 'package:rilevamento/Screens/Login_Screen.dart';
import 'package:rilevamento/Screens/tourorial.dart';
import 'package:rilevamento/styles/Local_Styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash_Screen extends StatefulWidget  {
  static const scid="Splash";
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> with TickerProviderStateMixin {
 
  AnimationController? _topcontroller,progresscontrol,_topandbottomright,_fulllampcontroller,_fullcontroller,_margincont,
      _textcontroller,_rot1con,_rot2con,_rot3con;
  Animation<double> ? _topimg,progress_animate,_topandbottomrightimg,_fulllampimg,_fullimg,_margin,
      _txtanimation,_rot1animation,_rot2animation,_rot3animation;
  double ? mariginheight;

  var usertype;
  var teacher_user;
  var student_user;
  bool ? seen;
  check_seen() async
  {
    final prefs = await SharedPreferences.getInstance();
    seen=await prefs.getBool('status');
    print(seen);
  }
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    check_seen();

    _topcontroller=AnimationController(vsync: this,duration: const Duration(milliseconds: 1000));
    _topimg=Tween<double>(begin: 0,end: 1).animate(CurvedAnimation(parent: _topcontroller!, curve: Curves.fastOutSlowIn));
    _topimg!.addListener(()=> setState(() {}));
    _margincont=AnimationController(vsync: this,duration: const Duration(milliseconds: 1000));
    _margin=Tween<double>(begin: 50,end: 0).animate(CurvedAnimation(parent: _margincont!, curve: Curves.fastOutSlowIn));
    _margin!.addListener(()=>setState(() {}));
    _textcontroller=AnimationController(vsync: this,duration: const Duration(milliseconds: 1000));
    _txtanimation=Tween<double>(begin: 0,end: 1).animate(CurvedAnimation(parent: _textcontroller!, curve: Curves.fastOutSlowIn));
    _txtanimation!.addListener(()=> setState(() {}));
    progresscontrol=AnimationController(vsync: this,duration: Duration(seconds: 2));
    progress_animate=Tween<double>(begin: 0,end: 1).animate(CurvedAnimation(parent: progresscontrol!, curve: Curves.easeInOutCubicEmphasized));
    progress_animate!.addListener(()=>setState(() {}));

      _textcontroller!.forward().then((value) {
        _topcontroller!.forward().then((value) {

          _margincont!.forward().then((value) {
            progresscontrol!.forward().then((value) async {

              Future.delayed(const Duration(milliseconds: 500),(){
                seen!=true?Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                              (Route<dynamic> route) => false,
                        ):Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login_screen()),
                      (Route<dynamic> route) => false,
                );


                //Navigator.of(context).pushNamed(Intro_Screen.scid);
              }

              );
            });



          });

        });
      });






  }
  @override
  Widget build(BuildContext context) {

    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;
    void Setheigtwidth()
    {
      setState(() {
        mariginheight=height/4;
      });

    }
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Expanded(
            flex: 3,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [

                      Opacity(
                          opacity:_topimg!.value.toDouble(),
                          child: Container(
                            height: height/6,
                            width: width/2.5,
                            decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage('assets/img/logo.png'),
                                fit: BoxFit.cover
                              ),
                            ),
                          )),


                    ],

                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: _margin!.value.toDouble()),
                    child: Opacity(
                      opacity: _txtanimation!.value,
                      child: Text("ANALISI",style: TextStyle(
                        fontSize: width/18,
                        fontWeight: FontWeight.w900,
                        color: local_blue.withOpacity(1)
                      ),),
                    ),
                  ),
                  SizedBox(height: height/10,),


                  ShaderMask(


                    shaderCallback: (bounds) {
                      return RadialGradient(
                        center: Alignment.topLeft,
                        radius: 1,
                        colors: [local_cyan,local_blue, local_cyan,local_blue],
                        tileMode: TileMode.repeated,
                      ).createShader(bounds);
                    },
                    child:   Container(
                      margin: EdgeInsets.all(width/20),
                      padding: EdgeInsets.all(width/20),

                      child: Opacity(
                          opacity:1 ,
                          child: Container(
                            height: height/8,
                            width: width/4,
                            child: Opacity(
                              opacity: progress_animate!.value,
                              child: LoadingIndicator(
                                  indicatorType: Indicator.ballPulseRise, /// Required, The loading type of the widget
                                  colors: const [Colors.white],       /// Optional, The color collections
                                  strokeWidth: 1,

                                  backgroundColor: Colors.transparent,      /// Optional, Background of the widget
                                  pathBackgroundColor: Colors.transparent   /// Optional, the stroke backgroundColor
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              )


            ),
          ),


        ],
      ),
    );
  }
}
