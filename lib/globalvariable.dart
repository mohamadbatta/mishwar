
import 'dart:async';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'brand_colors.dart';
import 'datamodels/driver.dart';
String mapKey="AIzaSyAs1tB3128cCMTDdsdHZh_Lf6DMKUUri6U";
bool flag=false;
User? currentFirebaseUser;
final  CameraPosition GooglePlex = CameraPosition(
  target: LatLng(32.222668, 35.262146),
  zoom: 14.4746,
);

StreamSubscription<Position>? homeTabPostionStream;
StreamSubscription<Position>? ridePositionStream;
double rating1 = 3.0;
DatabaseReference tripRequestRef=FirebaseDatabase.instance.ref().child('drivers/${currentFirebaseUser!.uid}/newtrip');
Driver? currentDriveriInfo;
final assetsAudioPlayer=AssetsAudioPlayer();
late Position currentPosition;
DatabaseReference? rideRef;
bool sheetRideVsConfirm=true;
String RideType='Share-Mishwar';
String dropdownValue = 'Share-Mishwar';
bool ifTopTextControlerInaitalized=true;
const int speedOfLoginScreenAnimation=50;
int speedOfBottomNavigationBarAnimation=300;
Color avalibilityColor = BrandColors.colorOrange;
