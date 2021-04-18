import 'package:flutter/material.dart';
import 'login_page.dart';
import 'sign_up.dart';

class welcomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Container(
            child: Center(
              child: Image.asset('assets/image/foods.png'),
            ),
          ),
        ),
        Expanded(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "welcome to tastee",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange),
              ),
              Column(
                children: [
                  Text("order food from restaurant and"),
                  Text("Make reversationin real time")
                ],
              ),
              Container(
                height: 55,
                width: 300,
                child: RaisedButton(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ));
                  },
                  child: Text(
                    "LogIn",
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ),
              ),
              Container(
                height: 55,
                width: 300,
                child: RaisedButton(
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text(
                    "SignIn",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ))
      ],
    ));
  }
}
