import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:testhema/screen/text_field.dart';
import 'welcome_page.dart';
import 'sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'resturant_list.dart';

class LoginPage extends StatefulWidget {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  @override
  _LoginPageState createState() => _LoginPageState();
}

//----------------------------------------------------------------------------------------------------------------------
Widget gotohome(BuildContext context) {
  print('in the goto home');
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ListPage()),
  );
}

Widget button(
    {@required String buttonName,
    @required Color color,
    @required Color textColor,
    @required Function ontap}) {
  return Container(
    width: 120,
    child: RaisedButton(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        buttonName,
        style: TextStyle(fontSize: 20, color: textColor),
      ),
      onPressed: ontap,
    ),
  );
}

/*
  Widget tField({Color iconcolor, String hinttext, IconData eyon, TextEditingController controller}) {
    return TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          eyon,
          color: iconcolor,
        ),
        hintText: hinttext,
        hintStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
*/ //------------a-----------------------------------------------------------------------------------------------------------
class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  RegExp regExp = RegExp(LoginPage.pattern);
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  UserCredential userCredential;
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  @override
  Future<String> loginAuth() async {
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
    } on FirebaseAuthException catch (e) {
      print("this is email");
      print(email.text);
      print("this is password");
      print(password.text);
      print('this is error code');
      print(e.code);
      if (e.code == 'user-not-found') {
        globalKey.currentState.showSnackBar(
          SnackBar(
            content: Text('No user found for that email.'),
          ),
        );
        print("false mail");
      } else if (e.code == 'wrong-password') {
        globalKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Wrong password provided for that user'),
          ),
        );
        print("false pass");
        setState(() {
          loading = false;
        });
      }
      print(e.code);
      setState(() {
        loading = false;
      });
    }
    if (loading == true) {
      gotohome(context);
    }
  }

  void validation() {
    if ((email.text.trim().isEmpty || email.text.trim() == null) &&
        (password.text.trim().isEmpty || password.text.trim() == null)) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('all field is empty'),
        ),
      );
    }
    if (email.text.trim().isEmpty || email.text.trim() == null) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Email is empty'),
        ),
      );
      return;
    } else if (!regExp.hasMatch(email.text)) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "please enter valid email",
          ),
        ),
      );
      return;
    }
    if (password.text.trim().isEmpty || password.text.trim() == null) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Password is empty'),
        ),
      );
      return;
    } else {
      setState(() {
        loading = true;
      });
    }
    loginAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          color: Colors.grey,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => welcomepage()),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: loading
          ? CircularProgressIndicator()
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 160,
                    ),
                    child: Text(
                      "login",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      MyTextField(
                        controller: email,
                        obscureText: false,
                        hintText: "UserName",
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      MyTextField(
                        controller: password,
                        obscureText: false,
                        hintText: "Password",
                      ),
                    ],
                  ),
                  Container(
                    height: 60,
                    width: 200,
                    child: RaisedButton(
                      color: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        validation();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New User?",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      button(
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
                          buttonName: "Register",
                          color: Colors.black,
                          textColor: Colors.deepOrange),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}

class MainAxisAllignment {}
