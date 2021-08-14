import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app_yellow/sign_in_page.dart';

import 'Auth/auth.dart';

class CustomCard extends StatefulWidget {
  String name, director;
  CustomCard({required this.director, required this.name});

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
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  edit() {
    print('edit');
  }

  Future<dynamic> deleteDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          'Do you want to delete this movie?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Yes'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  delete() async {
    bool isDelete = await deleteDialog();
    if (isDelete) {
      print('deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: size.width / 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                child: Image.network(
                  'https://images.pexels.com/photos/799443/pexels-photo-799443.jpeg?cs=srgb&dl=pexels-matheus-bertelli-799443.jpg&fm=jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
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
                          if (FirebaseAuth.instance.currentUser == null)
                            notLoggedInDialog('Delete');
                          else
                            delete();
                        },
                        child: const Icon(Icons.delete_forever),
                      ),
                    ],
                  ),
                  Container(
                    child: Text(
                      '${widget.name}',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Container(
                    child: Text('${widget.director}'),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
