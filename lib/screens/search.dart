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
                                            Color.fromRGBO(246, 244, 235, 1),
                                        trailing: InkWell(
                                          child: Icon(Icons.forward),
                                        ),
                                        title: Text(ds['Name']),
                                        onTap: () {
                                          showMaterialModalBottomSheet(
                                            context: context,
                                            builder: (context) => Container(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 50),
                                                child: SafeArea(
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 150.0,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              ds['imageURL'],
                                                          placeholder: (context,
                                                                  url) =>
                                                              CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                        ds['Name'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 35.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 20),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text(
                                                              "R: " +
                                                                  ds['Rprice'],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .redAccent,
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            // SizedBox(
                                                            //   width: 50.0,
                                                            // ),
                                                            Text(
                                                              "W: " +
                                                                  ds['Wprice'],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 150,
                                                      ),
                                                      Text(
                                                        "Drag Down",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .arrow_drop_down_rounded,
                                                        color: Colors.grey,
                                                        size: 50.0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
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
