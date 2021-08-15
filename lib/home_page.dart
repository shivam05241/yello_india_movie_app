import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app_yellow/watched_movie.dart';
import 'package:movie_app_yellow/widgets.dart';

import 'Auth/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBox();
  }

  bool isInitialised = false;
  initBox() async {
    await Hive.openBox('${FirebaseAuth.instance.currentUser!.uid}_watched')
        .then((value) async => {
              await Hive.openBox(FirebaseAuth.instance.currentUser!.uid)
                  .then((value) => {
                        setState(() {
                          isInitialised = true;
                        })
                      })
            });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          // Image.asset(
          //   'assets/background.jpg',
          //   height: size.height,
          //   width: double.infinity,
          //   fit: BoxFit.cover,
          // ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.grey[400], //Colors.transparent,
              appBar: AppBar(
                backgroundColor: Color(0xff00FF94), //Colors.transparent,
                leading: IconButton(
                    onPressed: () async {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => Watched()));
                    },
                    icon: const Icon(
                      Icons.preview_sharp,
                      // color: Colors.black87,
                    )),
                actions: [
                  if (FirebaseAuth.instance.currentUser != null)
                    IconButton(
                        onPressed: () async {
                          await signOut();
                        },
                        icon: const Icon(
                          Icons.logout,
                          // color: Colors.black87,
                        ))
                ],
              ),
              body: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: size.height - MediaQuery.of(context).padding.top,
                child: isInitialised == true
                    ? ValueListenableBuilder(
                        valueListenable:
                            Hive.box(FirebaseAuth.instance.currentUser!.uid)
                                .listenable(),
                        builder: (context, box, _) {
                          Box tbox = box as Box;
                          final list = tbox.keys.toList();

                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return movie(box, list[index],
                                  MediaQuery.of(context).size, false);
                            },
                          );
                        })
                    : Container(
                        color: Colors.transparent,
                      ),
              ),
            ),
          ),
          Positioned(
              bottom: 10,
              left: size.width / 2 - 20,
              child: GestureDetector(
                onTap: () {
                  openForm(context, setState);
                },
                child: const Icon(
                  Icons.add_circle,
                  size: 50,
                  color: Color(0xff00FF94),
                ),
              )),
        ],
      ),
    );
  }
}
