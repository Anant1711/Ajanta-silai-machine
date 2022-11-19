import 'package:chatapp/constants.dart';
import 'package:chatapp/screens/options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'forgotpassword.dart';
import 'package:chatapp/Components/roundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _auth = FirebaseAuth.instance;
final storage = FlutterSecureStorage();
late String email;
late String password;

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    disableCapture();
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/login_pic.png"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 370.0,
                  ),
                  TextField(
                    scrollPadding: EdgeInsets.only(top: 10.0, bottom: 9.0),
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration:
                        kEnterField.copyWith(hintText: "Enter Your email"),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration:
                        kEnterField.copyWith(hintText: "Enter Your password"),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 82.0, right: 82.0),
                    child: RoundedButton(
                      title: 'LogIn',
                      onPrsd: () async {
                        try {
                          UserCredential usercreds =
                              await _auth.signInWithEmailAndPassword(
                                  email: email, password: password);

                          //for storing uids in uid key (for keep user logged in)
                          storage.write(key: 'uid', value: usercreds.user?.uid);

                          if (usercreds != null) {
                            Navigator.pushNamed(context, options.id);
                          }
                        } catch (e) {
                          String error = "$e";
                          _showMyDialog(error);
                        }
                      },
                      colour: Color.fromRGBO(51, 61, 121, 1),
                      textColor: Colors.white70,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return forgotpasswd();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Reset Password ?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(51, 61, 121, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                //Navigator.pushNamed(context, options.id);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> disableCapture() async {
    //disable screenshots and record screen in current screen
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
