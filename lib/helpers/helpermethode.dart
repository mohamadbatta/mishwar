import 'dart:async';
import 'package:intl/intl_browser.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mishwar_driver/helpers/requesthelper.dart';
import 'package:provider/provider.dart';
import '../datamodels/directiondetaiels.dart';
import '../datamodels/history.dart';
import '../dataprovider.dart';
import '../globalvariable.dart';
import '../widgets/ProgressDialog.dart';

String placeAddress = '';
late final fullName;
late final email;
late final phone;
late String id = '';

class HelperMethods {
  static Future<DirectionDetails?> getDirectionDetails(LatLng? startPosition,
      LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition
        ?.latitude},${startPosition?.longitude}&destination=${endPosition
        .latitude},${endPosition.longitude}&key=$mapKey';
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

//to calculate the fares
  static int estimateFares(DirectionDetails details, int durationValue) {
    //per km 1 ils
    //per minute 0.5 ils
    //base fare  2 ils

    double basefare = 2;
    double distanceFare = (details.distanceValue! / 1000) * 1; //convert to klm
    double timeFare = (durationValue / 60) * 0.5;

    double totalFare = basefare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);
    return randInt.toDouble();
  }

//to disable the  driver forom avalibe
  static void disableHomeTabLocationUpdate() {
    homeTabPostionStream?.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

//to disable the  driver forom avalibe
  static void enableHomeTabLocationUpdate() {
    homeTabPostionStream?.resume();
    Geofire.setLocation(currentFirebaseUser!.uid, currentPosition.latitude,
        currentPosition.longitude);
  }

  //progress diaolg for waiting
  static void showProgressDialog(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(),
    );
  }

  //return earnings
  static void getHistoryInfo(context) {
    DatabaseReference earningRef = FirebaseDatabase.instance.ref().child(
        'drivers/${currentFirebaseUser!.uid}/earnings');

    earningRef.once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        String earnings = snapshot.snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });


    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child(
        'drivers/${currentFirebaseUser!.uid}/history');
    historyRef.once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.snapshot.value as Map;
        int tripCount = values.length;

        // update trip count to data provider
        Provider.of<AppData>(context, listen: false).updateTripCount(tripCount);

        List<String> tripHistoryKeys = [];
        values.forEach((key, value) {tripHistoryKeys.add(key);});

        // update trip keys to data provider
        Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);

        getHistoryData(context);

      }
    });
  }


  static void getHistoryData(context){

    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for(String key in keys){
      DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('rideRequest/$key');

      historyRef.once().then((DatabaseEvent snapshot) {
        if(snapshot.snapshot.value != null){

          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateTripHistory(history);

          print(history.destination);
        }
      });
    }

  }





}
