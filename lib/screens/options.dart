import 'dart:async';
import 'package:chatapp/screens/Additem.dart';
import 'package:chatapp/screens/updateitems.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'search.dart';
import 'login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/Components/roundbuttonforOption.dart';

class options extends StatefulWidget {
  static String id = 'option_screen';
  @override
  _optState createState() => _optState();
}

class _optState extends State<options> {
  final dbb = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser!;
  late final String UID;
  late String UemailID;
  late String UserName = "Name";

  @override
  void initState() {
    disableCapture();
    super.initState();

    UID = user.uid;
    UemailID = user.email!;
    getCredentials();

    FirebaseMessaging messg = FirebaseMessaging.instance;
    messg.getToken().then((value) => print("token" + '${value}'));

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: "comment"),
                ),
                TextButton(
                  child: Text("Got it"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    //getCredentials();
  }

  Future<void> getCredentials() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(UemailID)
          .get();
      setState(() {
        UserName = doc['Name'];
      });
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 243, 245, 1.0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  DelayedDisplay(
                    delay: Duration(seconds: 1),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Hi,",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'FiraSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 35.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  DelayedDisplay(
                    delay: Duration(microseconds: 1500000),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${UserName}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'FiraSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 35.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  //Delayed
                ],
              ),
            ),
            RoundbuttonOP(
              textColor: Colors.white,
              colour: Color.fromRGBO(51, 61, 121, 1),
              title: 'View Items',
              onPrsd: () {
                Navigator.pushNamed(context, searching.id);
              },
            ),
            RoundbuttonOP(
              textColor: Colors.white,
              colour: Color.fromRGBO(51, 61, 121, 1),
              title: 'Add Item',
              onPrsd: () {
                if (UID == 'gxAVfFwMOiUmBB2yrC8eMH9TPcR2' ||
                    UemailID == "ajantasilaimachine@gmail.com" ||
                    UemailID == "ravipushpak8266@gmail.com") {
                  Navigator.pushNamed(context, additem.id);
                } else {
                  _showMyDialog();
                }
              },
            ),
            RoundbuttonOP(
                textColor: Colors.white,
                colour: Color.fromRGBO(51, 61, 121, 1),
                title: 'Update Items',
                onPrsd: () {
                  if (UID == 'gxAVfFwMOiUmBB2yrC8eMH9TPcR2' ||
                      UemailID == "ajantasilaimachine@gmail.com" ||
                      UemailID == "ravipushpak8266@gmail.com") {
                    Navigator.pushNamed(context, updateitems.id);
                  } else {
                    _showMyDialog();
                  }
                }),
            RoundbuttonOP(
              textColor: Colors.white,
              colour: Colors.red.shade700,
              title: 'Log out',
              onPrsd: () {
                if (UemailID == "ajantasilaimachine@gmail.com") {
                  _signOutforadmin();
                } else {
                  _signOut();
                }
              },
            ),
            SizedBox(
              height: 90.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.copyright_outlined,
                  color: Colors.grey,
                  size: 20.0,
                ),
                Text(
                  " | Ajanta Silai Machine",
                  style: TextStyle(color: Colors.grey, fontFamily: 'FiraSans'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  //SignOut Page
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    final storage = FlutterSecureStorage();
    storage.delete(key: "uid");
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  Future<void> _signOutforadmin() async {
    await FirebaseAuth.instance.signOut();
    final storage = FlutterSecureStorage();
    storage.deleteAll();
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  //Alert Box
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Permission'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You cannot Add/Update Items!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
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
