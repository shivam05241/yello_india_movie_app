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
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.grey[400], //Colors.transparent,
            appBar: AppBar(
              title: const Center(
                child: Text(
                  'Home',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              backgroundColor: const Color(0xff00FF94), //Colors.transparent,
              leading: IconButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const Watched()));
                  },
                  icon: const Icon(
                    Icons.preview_sharp,
                    color: Colors.black,
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
                        color: Colors.black,
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
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: 35,
              width: size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
            ),
          ),
          Positioned(
            bottom: 5,
            left: size.width / 2 - 25,
            child: GestureDetector(
              onTap: () {
                openForm(context, setState);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff00FF94),
                ),
                child: const Icon(
                  Icons.add,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
