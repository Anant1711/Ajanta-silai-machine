import 'dart:ui';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'login_screen.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Color.fromRGBO(250, 235, 239, 1.0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'images/logo.png',
                    height: 250.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 82.0, right: 82.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                  print("Doing everything");
                }, //This prop for beautiful expressions
                child: Text(
                    "Login"), // This child can be everything. I want to choose a beautiful Text Widget
                style: ElevatedButton.styleFrom(
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  minimumSize:
                      Size(10, 50), //change size of this beautiful button
                  // We can change style of this beautiful elevated button thanks to style prop
                  primary: Color.fromRGBO(
                      51, 61, 121, 1), // we can set primary color
                  onPrimary: Colors.white, // change color of child prop
                  onSurface: Colors.blue, // surface color
                  shadowColor: Colors
                      .grey, //shadow prop is a very nice prop for every button or card widgets.
                  elevation: 5, // we can set elevation of this beautiful button
                  side: BorderSide(
                      color:
                          Color.fromRGBO(51, 61, 121, 1), //change border color
                      width: 2, //change border width
                      style: BorderStyle
                          .solid), // change border side of this beautiful button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30), //change border radius of this beautiful button thanks to BorderRadius.circular function
                  ),
                  tapTargetSize: MaterialTapTargetSize.padded,
                ),
              ),
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
