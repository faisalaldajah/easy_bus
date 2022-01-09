import 'dart:convert';
import 'dart:math';
import 'package:easy_bus/globalvariable.dart';
import 'package:easy_bus/screens/mainpage.dart';
import 'package:easy_bus/widgets/PermissionLocation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_bus/datamodels/address.dart';
import 'package:easy_bus/datamodels/directiondetails.dart';
import 'package:easy_bus/datamodels/user.dart';
import 'package:easy_bus/dataprovider/appdata.dart';
import 'package:easy_bus/helpers/requesthelper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HelperMethods {
  static void getCurrentUserInfo(context) async {
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      currentFirebaseUser = FirebaseAuth.instance.currentUser;
      String userid = currentFirebaseUser.uid;

      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users/$userid');
      userRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          currentUserInfo = UserData.fromSnapshot(snapshot);
          Navigator.pushNamedAndRemoveUntil(
              context, MainPage.id, (route) => false);
        }
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => PermissionLocation(),
      );
    }
  }

  static Future<String> findCordinateAddress(
      LatLng position, context, String locationType) async {
    String placeAddress = '';
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    var response = await RequestHelper.getRequest(url);
    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];
      if (locationType == 'pickUp') {
        Address pickupAddress = Address();
        pickupAddress.longitude = position.longitude;
        pickupAddress.latitude = position.latitude;
        pickupAddress.placeName = placeAddress;
        Provider.of<AppData>(context, listen: false)
            .updatePickupAddress(pickupAddress);
      } else {
        Address destinationAddress = Address();
        destinationAddress.longitude = position.longitude;
        destinationAddress.latitude = position.latitude;
        destinationAddress.placeName = placeAddress;
        Provider.of<AppData>(context, listen: false)
            .updateDestinationAddress(destinationAddress);
      }
    }

    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

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

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

  static sendNotification(String token, context, String rideId) async {
    var destination =
        (Provider.of<AppData>(context, listen: false).destinationAddress !=
                null)
            ? Provider.of<AppData>(context, listen: false).destinationAddress
            : Provider.of<AppData>(context, listen: false).pickupAddress;

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverKey,
    };

    Map notificationMap = {
      'title': 'NEW TRIP REQUEST',
      'body': 'Destination, ${destination.placeName}'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_id': rideId,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token
    };

    // ignore: unused_local_variable
    var response = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: headerMap, body: jsonEncode(bodyMap));

    //print(response.body);
  }
}
