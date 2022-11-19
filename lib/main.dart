import 'package:chatapp/screens/options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screens/welcome_screen.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/Additem.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/screens/updateitems.dart';
import 'screens/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  final storage = FlutterSecureStorage();

  Future<bool> checkifLoggedIn() async {
    String? check = await storage.read(key: 'uid');
    if (check == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: checkifLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == false) {
            return WelcomeScreen();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Color.fromRGBO(246, 244, 235, 1),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return options();
        },
      ),
      //initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        options.id: (context) => options(),
        additem.id: (context) => additem(),
        updateitems.id: (context) => updateitems(),
        searching.id: (context) => searching(),
      },
    );
  }
}
