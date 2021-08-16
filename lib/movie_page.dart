import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
  final String movieName, movieDirector, moviePath;
  MoviePage(
      {required this.movieName,
      required this.movieDirector,
      required this.moviePath});

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: Center(
            child: Text(
              widget.movieName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: const Color(0xff00FF94),
          foregroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Image.file(
                File(widget.moviePath),
                fit: BoxFit.fill,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(30),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 3 / 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(widget.moviePath),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Text(
                      widget.movieName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            blurRadius: 8.0,
                            color: Colors.lightGreenAccent,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.movieDirector,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.lightGreenAccent,
                        shadows: [
                          Shadow(
                            blurRadius: 8.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
