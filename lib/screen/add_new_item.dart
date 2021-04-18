import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testhema/screen/text_field.dart';
import 'welcome_page.dart';
import 'resturant_model.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  bool loading = false;
  final ResName = TextEditingController();
  final Location = TextEditingController();
  final Number = TextEditingController();
  final ResUrl = TextEditingController();
  File _image;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final picker = ImagePicker();
  String _error = 'No Error Dectected';
  List<Asset> imageRest = <Asset>[];

  List<String> imageUrls = <String>[];


  Future<String> picImage() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
 setState(() {
   _image=image.path as File;
 });
    return _image.toString();
  }

  var _url;
  /*Future uploadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
*/

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imageRest,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#D32F2F",
          actionBarTitle: "Upload image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imageRest = resultList;
      _error = error;
    });
  }
  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask =
    ref.putData((await imageFile.getByteData()).buffer.asUint8List());
    TaskSnapshot storageTaskSnapshot = await uploadTask;
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  void uploadImages() async {
    for (var imageFile in imageRest) {
      await postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
      }).catchError((err) {
        print(err);
      });
    }

    await _firebaseFirestore.collection('Restaurant').doc().set({
      'image': imageUrls[0].toString(),
      'name' :ResName.text,
      'number' :Number.text,
      'name' :Location.text,



    }).then((value) {
      ResName.clear();
      Location.clear();
      Number.clear();
      imageRest = [];
      imageUrls = [];
    });
  }




  Future<void> insertData(final Resturant) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('Resturant')
        .add(Resturant)
        .then((DocumentReference document) {})
        .catchError((e) {
      print(e);
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "add your resturant",
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
                          controller: ResName,
                          obscureText: false,
                          hintText: 'Resturant Name',
                        ),
                        MyTextField(
                          controller: Location,
                          obscureText: false,
                          hintText: 'Resturant Location',
                        ),
                        MyTextField(
                          controller: Number,
                          obscureText: false,
                          hintText: 'Contact Number',
                        ),
                        button(
                            buttonName: "upload image",
                            color: Colors.orange,
                            textColor: Colors.white,
                            ontap: () {
                              /*
                              String image = picImage().toString();
                              uploadImage(
                                context,
                                image,
                              );*/
                              loadAssets();

                            }),
                        FlatButton(
                            child:Text('send'
                            ,style: TextStyle(
                                color: Colors.white
                              ),),
                            onPressed: () {
                              setState(() {

                              });
                              uploadImages();
                            }
                        ),
                        button(
                            buttonName: "Add",
                            color: Colors.orange,
                            textColor: Colors.white,
                            ontap: () {
                              final String ResturantName = ResName.text;
                              final String ResturantLocation = Location.text;
                              final String ResturantNumber = Number.text;
                              final String ResturantImage = _url.toString();
                              print(ResturantImage);
                              final ResturantModel Resturant = ResturantModel(
                                  RName: ResturantName,
                                  RLocation: ResturantLocation,
                                  RNumber: ResturantNumber,
                                  RImagae: ResturantImage);
                              insertData(Resturant.toMap());
                            })
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
