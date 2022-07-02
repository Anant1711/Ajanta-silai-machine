import 'dart:async';
import 'dart:io';
import 'package:chatapp/Components/roundedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:path/path.dart';
import 'options.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class additem extends StatefulWidget {
  static String? imageURL;
  static void seturl(String s) {
    imageURL = s;
  }

  static String? geturl() {
    return imageURL;
  }

  static String id = 'additem';
  @override
  _additemState createState() => _additemState();
}

class _additemState extends State<additem> {
  late String name, rprice, wprice;
  final _db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  File? image;
  final ImagePicker _picker = ImagePicker();

  //alertBox after successfully upload data
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Your Item is added Successfully!'),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.popAndPushNamed(context, options.id);
              },
            ),
          ],
        );
      },
    );
  }

  //invoke camera to take picture
  Future imgFromCamera() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 20);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  //Upload images to firebase
  Future uploadFile() async {
    if (image == null) return;

    final fileName = basename(image!.path);
    final destination = 'itemimages/';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('$fileName');
      await ref.putFile(image!);

      String url = await ref.getDownloadURL();
      print(url);

      additem.seturl(url);
    } catch (e) {
      print("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    disableCapture();
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 244, 235, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 165.0, left: 20.0, right: 20.0),
          //padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add Items",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 24.0,
              ),
              Card(
                color: Color.fromRGBO(246, 244, 235, 1),
                elevation: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 55.0,
                      backgroundColor: Color.fromRGBO(182, 145, 102, 1),
                      child: image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                image!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                    //FlatButton for taking pictures and store in firebase
                    FlatButton(
                      onPressed: () {
                        imgFromCamera();
                      },
                      child: Text(
                        "Take Picture",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ),

                    TextField(
                      textAlign: TextAlign.center,
                      decoration: kEnterField.copyWith(
                          hintText: "Enter Name of Product"),
                      onChanged: (value) {
                        name = value;
                      },
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        rprice = value;
                      },
                      decoration:
                          kEnterField.copyWith(hintText: "Enter Retail Price"),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        wprice = value;
                      },
                      decoration: kEnterField.copyWith(
                          hintText: "Enter WholeSale Price"),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    RoundedButton(
                        textColor: Colors.black,
                        title: 'Submit',
                        onPrsd: () {
                          print("second: ${additem.geturl()}");
                          _db.collection('Items').add({
                            'Name': name,
                            'Rprice': rprice,
                            'Wprice': wprice,
                            'searchIndex': setSearchParam(name),
                            'imageURL': additem.geturl(),
                          });
                          _showMyDialog();
                        },
                        colour: Colors.lightGreen)
                  ],
                ),
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

  Future<void> disableCapture() async {
    //disable screenshots and record screen in current screen
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  //Add index list for searhing elements
  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";

    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }

    return caseSearchList;
  }
}
