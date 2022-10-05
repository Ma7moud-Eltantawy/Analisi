// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rilevamento/Screens/Home_Screen.dart';
class Login_screen extends StatefulWidget {
  const Login_screen({Key? key}) : super(key: key);

  @override
  State<Login_screen> createState() => _Login_screen();
}

class _Login_screen extends State<Login_screen> {
  int _start = 30;
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;


  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,

        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {



      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - The operation was canceled because the API is locked out due to too many attempts. This occurs after 5 failed attempts, and lasts for ${_start} seconds.}';
        print(e.message);
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      _authorized=='Authorized'?Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home_page()),
            (Route<dynamic> route) => false,
      ):null;

    });

  }



  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }
  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
          ? _SupportState.supported
          : _SupportState.unsupported),
    );
    _checkBiometrics;
    _getAvailableBiometrics;
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,

        body: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("FingerPrint Auth",style: TextStyle(fontSize: size.width/15),),
              Container(
                  height: size.height/6,
                  child: Image.asset('assets/img/fingerprint.png')),



              //Text('Current State: $_authorized\n'),
              Text('Authenticate using your finger print instead of your password.',textAlign:TextAlign.center,style: TextStyle(

              ),),
                SizedBox(height: 50,),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(


                      style: ButtonStyle(

                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(size.width/15)
                        )),
                        minimumSize: MaterialStateProperty.all(Size(size.height/2.5, size.height/16)),


                        backgroundColor:  MaterialStateProperty.all(Color.fromRGBO(2, 134, 219, 1)),
                      ),
                      onPressed: _authenticate,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Text('Authenticate'),
                          Icon(Icons.fingerprint),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height/50,),

                  ],
                ),
            ],
          ),
        ),

    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}