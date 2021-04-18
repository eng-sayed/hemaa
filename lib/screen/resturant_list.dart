import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:testhema/screen/add_new_item.dart';
import 'welcome_page.dart';
import 'sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListPage extends StatefulWidget {
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lime,
          elevation: 0.0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/image/profile.jpg'),
              ),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(color: Colors.lime),
                  child: Column(children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/image/profile.jpg'),
                    ),
                    Text('username goes here'),
                  ])),
              CustomListTile("Add Resturant", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddItem()),
                );
              }, null),
              CustomListTile("Log out", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              }, null),
            ],
          ),
        ),
        body: Container(
            child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("Restaurant").snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> querySnapshot) {
            if (querySnapshot.hasError) {
              return Text("Error");
            }
            if (querySnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              final list = querySnapshot.data.docs;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              title: Text(list[index]['name']),
                              subtitle: Text(list[index]['number']),
                              leading: Image.network(list[index]['image']),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => welcomepage()),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
              );
            }
          },
        )));
  }
}

class CustomListTile extends StatelessWidget {
  String txt;
  Function onTab;
  IconData icn;

  CustomListTile(this.txt, this.onTab, this.icn);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: InkWell(
        splashColor: Colors.lime,
        onTap: onTab,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  txt,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Icon(icn),
            ],
          ),
        ),
      ),
    );
  }
}
