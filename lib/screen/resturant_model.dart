import 'package:flutter/material.dart';

class ResturantModel {
  final String RName;
  final String RLocation;
  final String RNumber;
  final String RImagae;

  ResturantModel({this.RName, this.RLocation, this.RNumber, this.RImagae});

  Map<String, dynamic> toMap() {
    return {
      "name": this.RName,
      "location": this.RLocation,
      "number": this.RNumber,
      "image": this.RImagae,
    };
  }
}
