// ignore_for_file: unused_local_variable
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:easy_bus/Helper/requesthelper.dart';
import 'package:easy_bus/dataprovider/appdata.dart';
import 'package:easy_bus/models/address.dart';
import 'package:easy_bus/models/directiondetails.dart';
import 'package:easy_bus/models/user.dart';
import 'package:easy_bus/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';



double baseFare = 7;

double comssion = 0.25;

class HelperMethods {
  static void getCurrentUserInfo(context) async {
    // ignore: await_only_futures
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    String userid = currentFirebaseUser.uid;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('users/$userid');
    userRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        currentUserInfo = UserDetails.fromSnapshot(snapshot);
      }
    });
  }

  static Future<String> findCordinateAddress(Position position, context) async {
    String placeAddress = '';

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }

    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';

    var response = await RequestHelper.getRequest(Uri.parse(url));
    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];
      Address pickupAddress = Address();
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;
      Provider.of<AppData>(context, listen: false)
          .updatePickupAddress(pickupAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey";

    var response = await RequestHelper.getRequest(Uri.parse(url));

    if (response == 'failed') {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  // ignore: non_constant_identifier_names
  static sendNotification(String token, context, String ride_id) async {
    var destination =
        Provider.of<AppData>(context, listen: false).pickupAddress;

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverKey,
    };

    Map notificationMap = {
      'title': 'other student',
      'body': 'Destination, ${destination.placeName}'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_id': ride_id,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token
    };
    String res ="https://fcm.googleapis.com/fcm/send";
    var response = await http.post(Uri.parse(res),
        headers: headerMap, body: jsonEncode(bodyMap));
  }
}
