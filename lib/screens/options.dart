import 'package:chatapp/screens/Additem.dart';
import 'package:chatapp/screens/updateitems.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'search.dart';
import 'login_screen.dart';
import 'package:chatapp/Components/roundedButton.dart';

class options extends StatefulWidget {
  static String id = 'option_screen';
  @override
  _optState createState() => _optState();
}

class _optState extends State<options> {
  User user = FirebaseAuth.instance.currentUser!;
  late final String UID;
  final String ravi = "ezWoqqqmfyc5g0h5MvNEdV3661h1";
  final String admin = "nlFX5LKCcKWQnMnzNx3kbYwHeun1";

  // static final DateTime now = DateTime.now();
  // static final DateFormat formatter = DateFormat('MM-dd-yyyy');
  // final String formatted = formatter.format();

  @override
  void initState() {
    disableCapture();

    super.initState();
    UID = user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 244, 235, 1),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                textColor: Colors.black,
                colour: Colors.white,
                title: 'View Items',
                onPrsd: () {
                  Navigator.pushNamed(context, searching.id);
                },
              ),
              RoundedButton(
                textColor: Colors.black,
                colour: Colors.white,
                title: 'Add Item',
                onPrsd: () {
                  if (UID == 'gxAVfFwMOiUmBB2yrC8eMH9TPcR2' ||
                      UID == admin ||
                      UID == ravi) {
                    Navigator.pushNamed(context, additem.id);
                  } else {
                    _showMyDialog();
                  }
                },
              ),
              RoundedButton(
                  textColor: Colors.black,
                  colour: Colors.white,
                  title: 'Update Items',
                  onPrsd: () {
                    if (UID == 'gxAVfFwMOiUmBB2yrC8eMH9TPcR2' ||
                        UID == admin ||
                        UID == ravi) {
                      Navigator.pushNamed(context, updateitems.id);
                    } else {
                      _showMyDialog();
                    }
                  }),
              RoundedButton(
                textColor: Colors.white,
                colour: Colors.red.shade700,
                title: 'Log out',
                onPrsd: () {
                  if (UID == admin) {
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
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ],
          ),
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
                //Text('Would you like to approve of this message?'),
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
