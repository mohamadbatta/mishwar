import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mishwar_driver/brand_colors.dart';
import 'package:mishwar_driver/datamodels/driver.dart';
import 'package:mishwar_driver/helpers/helpermethode.dart';
import 'package:mishwar_driver/helpers/pushnotificationsrvice.dart';
import 'package:mishwar_driver/widgets/NotificationDialog.dart';
import 'package:mishwar_driver/widgets/TypeRideSheet.dart';

import '../globalvariable.dart';
import '../screens/MainPage/BotoomNavigroView.dart';
import '../widgets/ConfirmSheet.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('builder build1');
    return Stack(
      children: <Widget>[


        GoogleMap(

          padding: EdgeInsets.only(top: 50),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: GooglePlex,
          onMapCreated: (GoogleMapController controler) async {
            _controler.complete(controler);
            mapControler = controler;
            setState(() {
              mapBottomPadding = (Platform.isAndroid) ? 150 : 270;
            });
            if (await _getLocationPermission()) {
              getCurrentPosition();
            }
          },
        ),


        Positioned(
          bottom: 60,
          child: Container(
              height: 100,
              width: 400,
              child: loginButton(AvailbilityTitle, avalibilityColor,
                  onPressed: () {
                    (!isAvailabel)?


                    showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (BuildContext context) => TypeRideSheet(
                            title: (!isAvailabel) ? 'GO ONLINE' : 'GO OFFLINE',
                            subtitle: (!isAvailabel)
                                ? 'you are about to become available to receive trip requests'
                                : 'you will stop receiving new trip requests',
                            onPressed: () {
                              if (!isAvailabel) {

                                GoOnline();
                                getLocationUpdates();
                                Navigator.pop(context);
                                setState(() {

                                  avalibilityColor = BrandColors.colorGreen;
                                  AvailbilityTitle = 'GO OFLINE';
                                  isAvailabel = true;
                                });
                              } else {
                                GoOfline();
                                getLocationUpdates();
                                Navigator.pop(context);
                                setState(() {

                                  avalibilityColor = BrandColors.colorOrange;
                                  AvailbilityTitle = 'GO ONLINE';
                                  isAvailabel = false;
                                });
                              }}







                        ))
                        :


                    showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (BuildContext context) => ConfirmSheet(
                          title: (!isAvailabel) ? 'GO ONLINE' : 'GO OFFLINE',
                          subtitle: (!isAvailabel)
                              ? 'you are about to become available to receive trip requests'
                              : 'you will stop receiving new trip requests',
                          onPressed: () {
                            if (!isAvailabel) {
                              GoOnline();
                              getLocationUpdates();
                              Navigator.pop(context);
                              setState(() {
                                avalibilityColor = BrandColors.colorGreen;
                                AvailbilityTitle = 'GO OFLINE';
                                isAvailabel = true;
                              });
                            } else {
                              GoOfline();
                              getLocationUpdates();
                              Navigator.pop(context);
                              setState(() {
                                avalibilityColor = BrandColors.colorOrange;
                                AvailbilityTitle = 'GO ONLINE';
                                isAvailabel = false;
                              });
                            }
                          },
                        ));





                  })),
        )
      ],
    );
  }


  late GoogleMapController mapControler;
  Completer<GoogleMapController> _controler = Completer();
  double mapBottomPadding = 0;

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 4,
  );

  late String AvailbilityTitle = 'GO ONLINE';


  bool isAvailabel = false;

  //location permission
  Future<bool> _getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle the case where the user has not granted permission
        return false;
      }
    }
    // Permission has been granted
    return true;
  }

  void getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    mapControler.animateCamera(CameraUpdate.newLatLng(pos));
  }

  Widget loginButton(String title, var color, {required Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          primary: color,
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> getCurrentDriverInfo() async {
  currentFirebaseUser =await FirebaseAuth.instance.currentUser!;
  PushNotificationService pushNotificationService=PushNotificationService();
DatabaseReference driverRef=FirebaseDatabase.instance.ref().child('drivers/${currentFirebaseUser!.uid}');
driverRef.once().then((DatabaseEvent databaseEvent)
{
  if(databaseEvent.snapshot.value!=null)
    {
     currentDriveriInfo=Driver.fromSnapshot(databaseEvent);
    }
});

  pushNotificationService.iniltaize(context);
  pushNotificationService.getToken();

  HelperMethods.getHistoryInfo(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentDriverInfo();
  }





  void GoOnline() {

    Navigator.pop(context);
    Geofire.initialize('driversAvilabile');
    Geofire.setLocation(currentFirebaseUser!.uid, currentPosition.latitude,
        currentPosition.longitude);
    saveChildData();
    tripRequestRef.set('waiting');
    tripRequestRef.onValue.listen((event) {});

    //RideType='Share-Mishwar';
   // dropdownValue='Share-Mishwar';
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }


  void saveChildData() {
    late DatabaseReference rideTypRef;
    rideTypRef = FirebaseDatabase.instance.ref().child('driversAvilabile/${currentFirebaseUser!.uid}');
    rideTypRef.child('ride_type').set(RideType);
  }


  void GoOfline() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
  }

  void getLocationUpdates() {

    homeTabPostionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      currentPosition = position;

      if (isAvailabel) {

        Geofire.setLocation(
            currentFirebaseUser!.uid, position.latitude, position.longitude);
        saveChildData();
      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapControler.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }
}
