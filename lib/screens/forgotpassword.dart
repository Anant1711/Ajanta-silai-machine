import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../constants.dart';

class forgotpasswd extends StatefulWidget {
  @override
  _forgotpasswdState createState() => _forgotpasswdState();
}

class _forgotpasswdState extends State<forgotpasswd> {
  late String email;

  //reset password function
  Future resetpassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Password reset link sent! Please check your mail."),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    disableCapture();
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 244, 235, 1),
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your registered e-mail address, we will send you reset password link shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            SizedBox(
              height: 80,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration: kEnterField.copyWith(hintText: "Enter Your email"),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                resetpassword();
              },
              child: Text("Send reset link"),
              color: Color.fromRGBO(182, 145, 102, 1),
              textColor: Colors.white,
            )
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
