import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'MyBottomBarDemo.dart';
import 'signupAgency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/agencyManagement.dart';
import 'services/packageManagement.dart';
import 'Widgets/userInput.dart';

class loginScreen extends StatefulWidget {
  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _email = TextEditingController();

  final _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
              child:
              LoadingAnimationWidget.threeArchedCircle(color: Colors.blueAccent, size: 80)
            )
          : Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    'https://i.ibb.co/bgXk4gp/pexels-mudassir-ali-2680270.jpg',
                  ),
                ),
              ),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * .3),
                      Container(
                        height: MediaQuery.of(context).size.height * .7,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Text(
                                    'Log In ',
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  )),
                              SizedBox(height: 25),
                              userInput('Email', TextInputType.emailAddress,
                                  _email, false, 40),
                              userInput(
                                  'Password',
                                  TextInputType.visiblePassword,
                                  _password,
                                  true,
                                  20),
                              Container(
                                height: 55,
                                padding: const EdgeInsets.only(
                                    top: 5, left: 70, right: 70),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  color: Colors.indigo.shade800,
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _email.text,
                                            password: _password.text)
                                        .then((signedInUser) async {
                                      if (await agencyManagement(
                                              uid: signedInUser.user!.uid)
                                          .isAgency()) {
                                        packageManagement.Agencyid =
                                            signedInUser.user!.uid;
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              MyBottomBarDemo(),
                                        ));
                                        _email.clear();
                                        _password.clear();
                                        setState(() {
                                          isLoading = false;
                                        });
                                      } else {
                                        loginErrorDialog(
                                            'You are registered as a traveller !',
                                            context);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }).catchError((e) {
                                      print(e);
                                      loginErrorDialog(e.code, context);
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  },
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              const Center(
                                child: Text('Forgot password ?'),
                              ),
                              SizedBox(height: 10),
                              Divider(thickness: 0, color: Colors.white),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Don\'t have an account yet ? ',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => signupAgency(),
                                      ));
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
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
                ],
              )),
    );
  }

  void loginErrorDialog(String e, context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('The following error has occurred : '),
            content: Text(e.toString()),
          );
        });
  }
}
