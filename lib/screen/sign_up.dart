import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:testhema/screen/text_field.dart';
import 'welcome_page.dart';

class SignUp extends StatefulWidget {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  UserCredential userCredential;
  RegExp regExp = RegExp(SignUp.pattern);
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  void validation() {
    if (firstName.text.trim().isEmpty || firstName.text.trim() == null) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "please enter your first name",
          ),
        ),
      );
      return;
    }

    if (lastName.text.trim().isEmpty || lastName.text.trim() == null) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "please enter your last name",
          ),
        ),
      );
      return;
    }

    if (email.text.trim().isEmpty || email.text.trim() == null) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "please enter your email",
          ),
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
          content: Text(
            "please enter your password",
          ),
        ),
      );
      return;
    } else {
      setState(() {
        loading = true;
      });
      sendData();
    }
  }

  Future sendData() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(userCredential.user.uid)
          .set({
        'FirstName': firstName.text.trim(),
        'LastName': lastName.text.trim(),
        'Email': email.text.trim(),
        'UserID': userCredential.user.uid,
        'password': password.text,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        globalKey.currentState.showSnackBar(
          SnackBar(
            content: Text('The password is too weak'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        globalKey.currentState.showSnackBar(
          SnackBar(
            content: Text('This email is already in use'),
          ),
        );
      }
    } catch (e) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Sign up",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              Container(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //textField(hintText: "Name",),
                    MyTextField(
                      controller: firstName,
                      obscureText: false,
                      hintText: 'firstName',
                    ),
                    MyTextField(
                      controller: lastName,
                      obscureText: false,
                      hintText: 'lastName',
                    ),
                    MyTextField(
                      controller: email,
                      obscureText: false,
                      hintText: 'Email',
                    ),
                    MyTextField(
                      controller: password,
                      obscureText: true,
                      hintText: 'Password',
                    )
                  ],
                ),
              ),
              loading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        button(
                            buttonName: "Canel",
                            color: Colors.grey,
                            textColor: Colors.black,
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => welcomepage()),
                              );
                            }),
                        SizedBox(
                          width: 10,
                        ),
                        button(
                            ontap: () {
                              validation();
                            },
                            buttonName: "Register",
                            color: Colors.deepOrange,
                            textColor: Colors.white),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
