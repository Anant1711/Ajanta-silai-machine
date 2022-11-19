import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class searching extends StatefulWidget {
  static String id = 'searhitem';
  @override
  _searchingState createState() => _searchingState();
}

class _searchingState extends State<searching> {
  String? searchitem;
  final db = FirebaseFirestore.instance;

  TextEditingController txteditingcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    disableCapture();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: txteditingcontroller,
                      onChanged: (value) {
                        setState(() {
                          searchitem = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Items',
                        prefixIcon: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_sharp),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            txteditingcontroller.clear();
                          },
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: (searchitem == null || searchitem?.trim() == '')
                          ? FirebaseFirestore.instance
                              .collection('Items')
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('Items')
                              .where('searchIndex', arrayContains: searchitem)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds =
                                    snapshot.data!.docs[index];
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  child: Card(
                                    child: Container(
                                      child: ListTile(
                                        tileColor:
                                            Color.fromRGBO(51, 61, 121, 1),
                                        trailing: InkWell(
                                          child: Icon(
                                            Icons.forward,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(
                                          ds['Name'],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onTap: () {
                                          showDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (context) {
                                                return SingleChildScrollView(
                                                  child: AlertDialog(
                                                    title: Center(
                                                        child: Text(
                                                            "${ds['Name']}")),
                                                    content: Container(
                                                      child: Column(
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl:
                                                                ds['imageURL'],
                                                            placeholder: (context,
                                                                    url) =>
                                                                CircularProgressIndicator(),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                          SizedBox(
                                                            height: 20.0,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "R: " +
                                                                    ds['Rprice'],
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  fontSize:
                                                                      20.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 50.0,
                                                              ),
                                                              Text(
                                                                "W: " +
                                                                    ds['Wprice'],
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize:
                                                                      20.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
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
