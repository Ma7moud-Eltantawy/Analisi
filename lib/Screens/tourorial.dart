import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rilevamento/Screens/Home_Screen.dart';
import 'package:rilevamento/Screens/Login_Screen.dart';
import 'package:rilevamento/styles/Local_Styles.dart';
import 'package:rilevamento/styles/icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel(
      {required this.image, required this.title, required this.body});
}

List<BoardingModel> boarding = [
  BoardingModel(
      image: 'assets/img/t1.jpg',
      title: 'Welcome to ِAnalisi app',
      body:
      'This application provides you with some smart services that help you solve some of your problems.'),
  BoardingModel(
      image: 'assets/img/t2.jpg',
      title: 'Live object detection',
      body:
      "This application provides you with automatic identification of objects when using the camera"),
  BoardingModel(
      image: 'assets/img/t3.png',
      title: 'Offline object detection',
      body:
      'This application allows analyzing images and identifying all the things in these images.'),


  BoardingModel(
      image: 'assets/img/t4.png',
      title: 'Text recognition',
      body:
      'This application allows analyzing the images and identifying the text in these images and allows you to copy this text to deal with it.'),
  BoardingModel(
      image: 'assets/img/t5.png',

      title: 'ٌRemove background',
      body:
      'This application allows you to delete the background of images and save them on the phone in BNG format.'),

];

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController boardController = PageController();

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor:  MaterialStateProperty.all<Color>(Color.fromRGBO(9, 65, 102, .5).withOpacity(.2)),
                  ),
                    onPressed: submit,

                    child: Text(
                      'Skip',
                      style: TextStyle(

                        color: local_blue,
                        fontSize: 20,
                      ),
                    )),
              ),
              Expanded(
                child: PageView.builder(
                  onPageChanged: (int index) {
                    if (index == boarding.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      setState(() {
                        isLast = false;
                      });
                    }
                  },
                  controller: boardController,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildBoardingItem(boarding[index]);
                  },
                  itemCount: boarding.length,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: SmoothPageIndicator(
                    controller: boardController,
                    count: boarding.length,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      dotWidth: 10,
                      expansionFactor: 4,
                      spacing: 5,
                      activeDotColor: local_blue,
                    ),
                  ),
                ),
              ),
              !isLast
                  ? Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: TextButton(
                      onPressed: () {
                        boardController.nextPage(
                            duration: Duration(milliseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                                color: Colors.grey, fontSize: 22),
                          ),
                          Baseline(
                              baseline: 33,
                              baselineType: TextBaseline.alphabetic,
                              child: Icon(
                                IconBroken.Arrow___Right_2,
                                color: Colors.grey,
                                size: 30,
                              ))
                        ],
                      )),
                ),
              )
                  : Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor:  MaterialStateProperty.all<Color>(Color.fromRGBO(9, 65, 102, .5).withOpacity(.2)),
                    ),
                      onPressed: submit,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                                color: local_blue, fontSize: 22),
                          ),
                          Baseline(
                              baseline: 33,
                              baselineType: TextBaseline.alphabetic,
                              child: Icon(
                               IconBroken.Arrow___Right_3,
                                color: local_blue,
                                size: 30,
                              ))
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Image.asset(
                '${model.image}',
                width: 280,
                height: 280,
              )),
          SizedBox(
            height: 30,
          ),
          Text(
            '${model.title}',
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'CMSansSerif', fontSize: 22, color: local_blue.withOpacity(.5)),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${model.body}',
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void submit()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('status', true);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login_screen()),
            (Route<dynamic> route) => false);


  }
}
