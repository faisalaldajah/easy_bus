import 'package:easy_bus/datamodels/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String serverKey =
    'key=AAAA4djqNz4:APA91bH4E26K_JW3jNrF7DqqGLE6p6cBJaeU5qHFb529bKdF3xOwgrR_XVOanAPmsMXBIhaunC2iYW104KzLttUI_MJU3qCe8Jlz5uTNe-YdCcMKXOyK45t8_DXvCTRaLwY1l7azczN4';

String mapKey = 'AIzaSyASM6GHRPd8Itw1GDN6OGLlsYWTe03qLrU';

const CameraPosition googlePlex = CameraPosition(
  target: LatLng(31.954066, 35.931066),
  zoom: 14.4746,
);
User currentFirebaseUser;

UserData currentUserInfo;

String driverCarStyle;