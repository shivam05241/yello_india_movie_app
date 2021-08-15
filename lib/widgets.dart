import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app_yellow/sign_in_page.dart';
import 'package:movie_app_yellow/watched_movie.dart';

import 'movie_page.dart';

class CustomCard extends StatefulWidget {
  final dynamic boxKey;
  final Box box;
  final double Height;
  final bool isWatched;
  CustomCard(
      {required this.boxKey,
      required this.box,
      required this.Height,
      required this.isWatched});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  void notLoggedInDialog(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              'Login to $msg this movie',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  edit() {
    openForm(context, setState, isEdit: true, boxKey: widget.boxKey);
  }

  Future<dynamic> deleteDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: widget.isWatched == false
            ? const Text(
                'Do you want to delete this movie?',
                textAlign: TextAlign.center,
              )
            : const Text(
                'Do you want to delete this movie from watched list?',
                textAlign: TextAlign.center,
              ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  delete() async {
    bool isDelete = await deleteDialog();
    if (isDelete) {
      widget.box.delete(widget.boxKey);
      Hive.box('${FirebaseAuth.instance.currentUser!.uid}_watched')
          .delete(widget.boxKey);
    }
  }

  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                Map map = widget.box.get(widget.boxKey);
                if (widget.isWatched == false) {
                  map['time'] = DateTime.now().toString();
                  Hive.box('${uid}_watched').put(widget.boxKey, map);
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MoviePage(
                      movieName: map['name'],
                      movieDirector: map['director'],
                      moviePath: map['poster'],
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                height: widget.Height,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.file(
                    File(widget.box.get(widget.boxKey)['poster']),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: widget.Height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.isWatched == false)
                        GestureDetector(
                          onTap: () {
                            FirebaseAuth.instance.currentUser == null
                                ? notLoggedInDialog('Edit')
                                : edit();
                          },
                          child: const Icon(Icons.edit),
                        ),
                      GestureDetector(
                        onTap: () {
                          if (FirebaseAuth.instance.currentUser == null) {
                            notLoggedInDialog('Delete');
                          } else {
                            delete();
                          }
                        },
                        child: const Icon(Icons.delete_forever),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: widget.Height / 2,
                    child: Text(
                      '${widget.box.get(widget.boxKey)['name']}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    height: widget.Height / 4,
                    child: Text(
                      '${widget.box.get(widget.boxKey)['director']}',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void openForm(BuildContext context, StateSetter setState,
    {bool isEdit = false, dynamic boxKey}) {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController name = TextEditingController();
  TextEditingController director = TextEditingController();
  File? file;

  if (isEdit == true) {
    name.text = Hive.box(uid).get(boxKey)['name'];
    director.text = Hive.box(uid).get(boxKey)['director'];
    file = File(Hive.box(uid).get(boxKey)['poster']);
  }

  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (sheetcontext) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              final pickedFile = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);

                              if (pickedFile != null) {
                                setState(() {
                                  file = File(pickedFile.path);
                                });
                              }
                            },
                            child: Container(
                              width: 150,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromRGBO(255, 200, 87, 0.5),
                              ),
                              child: file == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.photo_library_outlined,
                                          size: 40,
                                        ),
                                        Text(
                                          "Gallery",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        file!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      height: 40,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: name,
                        decoration: const InputDecoration(
                          hintText: "Enter Movie Name",
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      height: 40,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: director,
                        decoration: const InputDecoration(
                          hintText: "Enter Director Name",
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (file != null) {
                          if (name.text.isEmpty || director.text.isEmpty) {
                          } else {
                            if (isEdit == false) {
                              Hive.box(uid).add({
                                'name': name.text,
                                'director': director.text,
                                'poster': file!.path,
                              }).then((value) => Navigator.of(context).pop());
                            } else {
                              Map map = Hive.box(uid).get(boxKey);
                              map['name'] = name.text;
                              map['director'] = director.text;
                              map['poster'] = file!.path;

                              Hive.box(uid).put(boxKey, map);
                              Hive.box('${uid}_watched').put(boxKey, map);
                              Navigator.of(context).pop();
                            }
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff00FF94),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        height: 40,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ),
              FloatingActionButton(
                backgroundColor: const Color(0xff00FF94),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ],
          );
        });
      });
}

Widget movie(Box box, dynamic boxKey, Size size, bool isWatched) {
  return Column(
    children: [
      SizedBox(
        height: 5,
      ),
      Container(
        width: double.infinity,
        height: size.height / 5,
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 5,
        ),
        color: Colors.transparent,
        child: CustomCard(
          box: box,
          boxKey: boxKey,
          Height: size.height / 5,
          isWatched: isWatched,
        ),
      ),
    ],
  );
}
