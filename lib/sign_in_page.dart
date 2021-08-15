import 'package:flutter/material.dart';
import 'Auth/auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    var Height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xff2E505B),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: Height,
          child: Column(
            children: [
              Container(
                height: Height * 2 / 5,
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  'assets/movie.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50))),
                padding: EdgeInsets.only(top: 20),
                height: Height * 3 / 5,
                child: GestureDetector(
                  onTap: () async {
                    await signInWithGoogle();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 60,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: Colors.pink[400],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Sign In With Google',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
