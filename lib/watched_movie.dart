import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app_yellow/widgets.dart';

import 'Auth/auth.dart';

class Watched extends StatefulWidget {
  const Watched({Key? key}) : super(key: key);

  @override
  _WatchedState createState() => _WatchedState();
}

class _WatchedState extends State<Watched> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[400], //Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color(0xff00FF94), //Colors.transparent,
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
            child: ValueListenableBuilder(
                valueListenable: Hive.box(
                        '${FirebaseAuth.instance.currentUser!.uid}_watched')
                    .listenable(),
                builder: (context, box, _) {
                  Box tbox = box as Box;
                  var list = tbox.keys.toList();
                  list.sort((a, b) {
                    return box.get(a)['time'].compareTo(box.get(b)['time']);
                  });
                  list = list.reversed.toList();

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      print(box.get(list[index]));
                      return movie(
                          box, list[index], MediaQuery.of(context).size, true);
                    },
                  );
                })),
      ),
    );
  }
}
