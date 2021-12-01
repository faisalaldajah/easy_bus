// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter/material.dart';

var paragraphText = const TextStyle(fontFamily: 'bolt', fontSize: 14);

var bodyText = const TextStyle(fontFamily: 'bolt', fontSize: 16);

var smallText = const TextStyle(fontFamily: 'bolt', fontSize: 12);

var textInput = const TextStyle(fontFamily: 'bolt', fontSize: 16);

var pageTitle = const TextStyle(fontSize: 20, fontFamily: 'bolt');

var headerTitle = const TextStyle(fontSize: 30, fontFamily: 'bolt');

Color brandColor = const Color(0xff6C63FF);

Color backGroundColor = const Color(0xFFFBFAFF);

Color colorBtn = const Color(0xFF12CBC4);

Color colorBtn1 = const Color(0xFF1dd1a1);

User currentFirebaseUser;
String serverKey =
    "AAAA4djqNz4:APA91bH4E26K_JW3jNrF7DqqGLE6p6cBJaeU5qHFb529bKdF3xOwgrR_XVOanAPmsMXBIhaunC2iYW104KzLttUI_MJU3qCe8Jlz5uTNe-YdCcMKXOyK45t8_DXvCTRaLwY1l7azczN4 ";

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(31.954066, 35.931066),
  zoom: 14.4746,
);
bool youHaveData = false;

bool userLoggedin = false;

var currentUserInfo;

String mapKey = 'AIzaSyASM6GHRPd8Itw1GDN6OGLlsYWTe03qLrU';
