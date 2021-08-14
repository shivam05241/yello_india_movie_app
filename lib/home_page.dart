import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app_yellow/widgets.dart';

import 'Auth/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget movie(String name, String director, String asset, Size size) {
    return Container(
      width: double.infinity,
      height: size.height / 5,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 5,
      ),
      color: Colors.transparent,
      child: CustomCard(
        name: name,
        director: director,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Image.asset(
            'assets/background.jpg',
            height: size.height,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                actions: [
                  if (FirebaseAuth.instance.currentUser != null)
                    IconButton(
                        onPressed: () async {
                          await signOut();
                        },
                        icon: const Icon(Icons.logout))
                ],
              ),
              floatingActionButton: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: IconButton(
                    iconSize: 50,
                    color: Colors.pink,
                    onPressed: () async {},
                    icon: const Icon(Icons.add_comment)),
              ),
              body: Container(
                width: double.infinity,
                height: size.height - MediaQuery.of(context).padding.top,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return movie('name', 'director', 'asset',
                        MediaQuery.of(context).size);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
