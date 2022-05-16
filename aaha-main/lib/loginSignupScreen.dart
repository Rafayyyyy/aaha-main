import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'signupAgency.dart';
import 'loginScreen.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class loginSignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
            image: NetworkImage(
              'https://i.ibb.co/YTk7nyk/login-Signup.png',
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 410,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Welcome!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                          child: MaterialButton(
                            minWidth: 300,
                            height: 60,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (Context) => loginScreen(),
                              ));
                            },
                            color: Colors.transparent.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.black38,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 26,
                                  color: Colors.white70),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: MaterialButton(
                            minWidth: 300,
                            height: 60,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (Context) => signupAgency(),
                              ));
                            },
                            color: Colors.amber.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 26,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
