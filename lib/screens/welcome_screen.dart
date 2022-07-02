import 'dart:ui';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/Components/roundedButton.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  //custom animation

  @override
  void initState() {
    disableCapture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(182, 145, 102, 1),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Column(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'images/logo.png',
                      height: 250.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              textColor: Colors.black,
              title: 'LogIn',
              onPrsd: () {
                //Go to registration screen.
                Navigator.pushNamed(context, LoginScreen.id);
              },
              colour: Color.fromRGBO(246, 244, 235, 1),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> disableCapture() async {
    //disable screenshots and record screen in current screen
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
