import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'services/travellerManagement.dart';
import 'Widgets/userInput.dart';
import 'Widgets/signUpErrorDialog.dart';


class SignupTraveller extends StatefulWidget {
  const SignupTraveller({Key? key}) : super(key: key);

  @override
  State<SignupTraveller> createState() => _SignupTravellerState();
}

class _SignupTravellerState extends State<SignupTraveller> {
  final _name = TextEditingController();
  final _phoneNum = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.blueAccent, size: 80))
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
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          iconSize: 40,
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.pop(context, false),
                        )),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 600,
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
                                child: Text('Sign Up',
                                    style: TextStyle(
                                      fontSize: 50,
                                    )),
                              ),
                              userInput('Full Name', TextInputType.text, _name,
                                  false, 30),
                              userInput('Phone Number', TextInputType.phone,
                                  _phoneNum, false, 11),
                              userInput('Email', TextInputType.name, _email,
                                  false, 40),
                              userInput(
                                  'Password',
                                  TextInputType.visiblePassword,
                                  _password,
                                  true,
                                  20),
                              userInput(
                                  'Confirm Password',
                                  TextInputType.visiblePassword,
                                  _confirmPassword,
                                  true,
                                  20),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Container(
                                    child: SizedBox(
                                  width: 200,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.indigo.shade800),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                side: BorderSide(
                                                    color: Colors.blueGrey)))),
                                    onPressed: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (_password.text ==
                                          _confirmPassword.text) {
                                        FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: _email.text,
                                                password: _password.text)
                                            .then((signedInUser) {
                                          travellerManagement(
                                                  uid: FirebaseAuth.instance
                                                      .currentUser!.uid)
                                              .storeNewTraveller(
                                                  signedInUser.user,
                                                  _name.text,
                                                  _phoneNum.text,
                                                  context);
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }).catchError((e) {
                                          print(e);
                                          signupErrorDialog(e.code, context);
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      } else {
                                        signupErrorDialog(
                                            'Passwords do not match ', context);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    },
                                    child: Text('Sign Up ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}


