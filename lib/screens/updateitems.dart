import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Components/roundedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class updateitems extends StatefulWidget {
  static String id = 'updateitems';
  @override
  _updateitemsState createState() => _updateitemsState();
}

class _updateitemsState extends State<updateitems> {
  String? searchitem;
  TextEditingController txteditingcontroller = new TextEditingController();
  final db = FirebaseFirestore.instance;
  FirebaseStorage dbst = FirebaseStorage.instance;
  User user = FirebaseAuth.instance.currentUser!;
  late final String UID;

  late String Rprice, Wprice;

  AlertDialog delete = AlertDialog();
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
                                                            height: 10.0,
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
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 90.0,
                                                                child:
                                                                    TextField(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  onChanged:
                                                                      (value) {
                                                                    Rprice =
                                                                        value;
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                          hintText:
                                                                              "Retail Price"),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 120.0,
                                                                child:
                                                                    TextField(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  onChanged:
                                                                      (value) {
                                                                    Wprice =
                                                                        value;
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                          hintText:
                                                                              "WholeSale Price"),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              RoundedButton(
                                                                  title:
                                                                      'Delete',
                                                                  onPrsd: () =>
                                                                      showDialog<
                                                                          String>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                AlertDialog(
                                                                          title:
                                                                              const Text('Delete'),
                                                                          content:
                                                                              const Text('Do you want to Delete this item?'),
                                                                          actions: <
                                                                              Widget>[
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                              child: const Text('Cancel'),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                db.collection('Items').doc(ds.id).delete();
                                                                                int count = 0;
                                                                                Navigator.of(context).popUntil((_) => count++ == 2);
                                                                              },
                                                                              child: const Text('Yes'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                  // onPrsd: () {
                                                                  //   return;

                                                                  // },
                                                                  colour: Colors
                                                                      .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white),
                                                              RoundedButton(
                                                                  title:
                                                                      'Update',
                                                                  onPrsd: () {
                                                                    db
                                                                        .collection(
                                                                            'Items')
                                                                        .doc(ds
                                                                            .id)
                                                                        .update({
                                                                      'Rprice':
                                                                          Rprice,
                                                                      'Wprice':
                                                                          Wprice
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  colour: Colors
                                                                      .green,
                                                                  textColor:
                                                                      Colors
                                                                          .white),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });

//                                           showMaterialModalBottomSheet(
//                                             context: context,
//                                             builder: (context) => Container(
//                                               height: MediaQuery.of(context)
//                                                       .size
//                                                       .height *
//                                                   0.90,
//                                               child: Padding(
//                                                 padding:
//                                                     EdgeInsets.only(top: 30),
//                                                 child: SafeArea(
//                                                   child: Column(
//                                                     children: [
//                                                       CircleAvatar(
//                                                         radius: 120.0,
//                                                         backgroundColor:
//                                                             Colors.transparent,
//                                                         child:
//                                                             CachedNetworkImage(
//                                                           imageUrl:
//                                                               ds['imageURL'],
//                                                           placeholder: (context,
//                                                                   url) =>
//                                                               CircularProgressIndicator(),
//                                                           errorWidget: (context,
//                                                                   url, error) =>
//                                                               Icon(Icons.error),
//                                                         ),
//                                                       ),
//                                                       Center(
//                                                         child: Text(
//                                                           ds['Name'],
//                                                           style: TextStyle(
//                                                             fontSize: 35.0,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 10.0,
//                                                       ),
//                                                       Padding(
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 top: 20),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceEvenly,
//                                                           children: [
//                                                             Text(
//                                                               "R: " +
//                                                                   ds['Rprice'],
//                                                               style: TextStyle(
//                                                                 color: Colors
//                                                                     .redAccent,
//                                                                 fontSize: 20.0,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               ),
//                                                             ),
// // SizedBox(
// //   width: 50.0,
// // ),
//                                                             Text(
//                                                               "W: " +
//                                                                   ds['Wprice'],
//                                                               style: TextStyle(
//                                                                 color: Colors
//                                                                     .green,
//                                                                 fontSize: 20.0,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 20.0,
//                                                       ),
//                                                       Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceEvenly,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           SizedBox(
//                                                             width: 150.0,
//                                                             child: TextField(
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                               onChanged:
//                                                                   (value) {
//                                                                 Rprice = value;
//                                                               },
//                                                               decoration:
//                                                                   InputDecoration(
//                                                                       hintText:
//                                                                           "Retail Price"),
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             width: 150.0,
//                                                             child: TextField(
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                               onChanged:
//                                                                   (value) {
//                                                                 Wprice = value;
//                                                               },
//                                                               decoration:
//                                                                   InputDecoration(
//                                                                       hintText:
//                                                                           "WholeSale Price"),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceEvenly,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           RoundedButton(
//                                                               title: 'Delete',
//                                                               onPrsd: () {
//                                                                 db
//                                                                     .collection(
//                                                                         'Items')
//                                                                     .doc(ds.id)
//                                                                     .delete();
//                                                                 Navigator.pop(
//                                                                     context);
//                                                               },
//                                                               colour:
//                                                                   Colors.red,
//                                                               textColor:
//                                                                   Colors.white),
//                                                           RoundedButton(
//                                                               title: 'Update',
//                                                               onPrsd: () {
//                                                                 db
//                                                                     .collection(
//                                                                         'Items')
//                                                                     .doc(ds.id)
//                                                                     .update({
//                                                                   'Rprice':
//                                                                       Rprice,
//                                                                   'Wprice':
//                                                                       Wprice
//                                                                 });
//                                                                 Navigator.pop(
//                                                                     context);
//                                                               },
//                                                               colour:
//                                                                   Colors.green,
//                                                               textColor:
//                                                                   Colors.white),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           );
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

  //For disable screenshot in app
  Future<void> disableCapture() async {
    //disable screenshots and record screen in current screen
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
