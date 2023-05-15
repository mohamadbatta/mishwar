

import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mishwar_driver/datamodels/tripdetails.dart';
import 'package:mishwar_driver/globalvariable.dart';
import 'package:mishwar_driver/widgets/NotificationDialog.dart';

import '../widgets/ProgressDialog.dart';

class PushNotificationService {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //initalize and connect to the firebase for clud message
  Future iniltaize(context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      fetchRideInfo(getRideID(message),context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      fetchRideInfo(getRideID(message),context);
    });

    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return;
  }


  //return the token for cloud message
  Future<String> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('token:$token');

    DatabaseReference tokenRef = FirebaseDatabase.instance.ref().child(
        'drivers/${currentFirebaseUser!.uid}/token');
    tokenRef.set(token);

    _firebaseMessaging.subscribeToTopic('alldrivers');
    _firebaseMessaging.subscribeToTopic('allusers');

    return token!;
  }

  //return the ride id in the notification message
  String getRideID(RemoteMessage message) {
    String ride_id = '';
    if (Platform.isAndroid) {
      ride_id = message.data['ride_id'];
    }
    return ride_id;
  }

  //return rider information from firebase
  void fetchRideInfo(String rideID,context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(),
    );

    DatabaseReference rideRef = FirebaseDatabase.instance.ref().child(
        'rideRequest/$rideID');
    print("ride id$rideID");
    rideRef.once().then((DatabaseEvent databaseEvent) {
      Navigator.pop(context);


      if (databaseEvent.snapshot.value != null) {

        assetsAudioPlayer.open(Audio('sounds/alert.mp3'));
        double pickupLat = double.parse(
            (databaseEvent.snapshot.value as Map)['location']['latitude']
                .toString());
        double pickupLng = double.parse(
            (databaseEvent.snapshot.value as Map)['location']['longitude']
                .toString());
        String pickupAddress = (databaseEvent.snapshot
            .value as Map)['pickup_address'].toString();

        double destinationLat = double.parse(
            (databaseEvent.snapshot.value as Map)['destination']['latitude']
                .toString());
        double destinationLng = double.parse(
            (databaseEvent.snapshot.value as Map)['destination']['longitude']
                .toString());
        String destinationAddress = (databaseEvent.snapshot
            .value as Map)['destination_address'].toString();
        String paymentMethode = (databaseEvent.snapshot
            .value as Map)['payment_methode'].toString();
        String riderName=(databaseEvent.snapshot
            .value as Map)['rider_name'].toString();
        String riderPhoneNumber=(databaseEvent.snapshot
            .value as Map)['rider_phone'].toString();



        TripDetails tripDetails = TripDetails(
            rideID: rideID,
            destination: LatLng(destinationLat,destinationLng),
            pickup: LatLng(pickupLat,pickupLng),
            destinationAddress: destinationAddress,
            pickupAddress: pickupAddress,
            paymentMethode: paymentMethode,
          riderName: riderName,
          riderPhone: riderPhoneNumber,


           );

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context)=>NotificationDialog(tripDetails: tripDetails));


      }
    });
  }


}