import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mishwar_driver/brand_colors.dart';
import 'package:mishwar_driver/helpers/mapkitfhelper.dart';
import 'package:mishwar_driver/widgets/collectpaymentdialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../datamodels/tripdetails.dart';
import '../../globalvariable.dart';
import '../../helpers/helpermethode.dart';
import '../../widgets/ProgressDialog.dart';

class NewTripPage extends StatefulWidget {
  late final TripDetails tripDetails;

  NewTripPage({required this.tripDetails});

  @override
  State<NewTripPage> createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  late GoogleMapController ridemapControler;
  Completer<GoogleMapController> _controler = Completer();
  double mapPadingBottom = 0;
  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polylines = Set<Polyline>();
  Set<Marker> _markers1 = {};
  late BitmapDescriptor mapMarker;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  var geoLocater = Geolocator();
  late BitmapDescriptor movingMarkerIcon;
  late Position myPosition;
  String status = 'accepted';
  String durationtring = '';
  late bool isRequstingDirection = false;
  String buttonTitle='          ARRIVED          ';
  Color buttonColor=BrandColors.colorGreen;
  late Timer timer;
  int durationCounter=0;
  final LocationSettings LocationOptions =
      LocationSettings(accuracy: LocationAccuracy.bestForNavigation);

//to create marker for map
  void createMarker() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: Size(2, 2));
    BitmapDescriptor.fromAssetImage(imageConfiguration,
            (Platform.isIOS) ? 'images/car_ios.png' : 'images/car_android.png')
        .then((icon) {
      movingMarkerIcon = icon;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    acceptTrip();
    setCustomMarker();
  }

  //make a custom marker icon in map
  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'images/des.png');
  }

  //get the location for the pikup and destianation and the current position of driver
  Future<void> getDirection(
      LatLng? pikuplLatLng, LatLng? destinationLatLng) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(),
    );

    var thisDetails = await HelperMethods.getDirectionDetails(
        pikuplLatLng!, destinationLatLng!);

    Navigator.pop(context);

    if (kDebugMode) {
      print(thisDetails?.encodedPoints);
    }

    PolylinePoints polylinePoints = PolylinePoints();

    String s = thisDetails!.encodedPoints;

    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);

    polylineCoordinates.clear();

    if (results.isNotEmpty) {
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    _polylines.clear();

    setState(() {
      Polyline polyLine = Polyline(
        polylineId: const PolylineId('polyid'),
        color: Colors.blue,
        points: polylineCoordinates,
        jointType: JointType.round,
        endCap: Cap.roundCap,
        startCap: Cap.roundCap,
        geodesic: true,
        width: 5,
      );

      _polylines.add(polyLine);
    });

//make poly line to fit in map
    LatLngBounds bounds;
    if (pikuplLatLng.latitude > destinationLatLng.latitude &&
        pikuplLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pikuplLatLng);
    } else if (pikuplLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pikuplLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, pikuplLatLng.longitude),
      );
    } else if (pikuplLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pikuplLatLng.longitude),
        northeast: LatLng(pikuplLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds =
          LatLngBounds(southwest: pikuplLatLng, northeast: destinationLatLng);
    }

    ridemapControler.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: const MarkerId('pickup'),
      position: pikuplLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker distinctionsMarker = Marker(
      markerId: const MarkerId('distinction'),
      position: destinationLatLng,
      icon: mapMarker,
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(distinctionsMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pikuplLatLng,
      fillColor: BrandColors.colorGreen,
    );

    Circle distinationCircle = Circle(
      circleId: const CircleId('distinction'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: BrandColors.colorAccentPurple,
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(distinationCircle);
    });
  }

  //elevated button
  Widget loginButton(String title, var color, {required Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 16),
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

  //to accept the trip and change the status
  void acceptTrip() {
    String rideID = widget.tripDetails.rideID;
    rideRef = FirebaseDatabase.instance.ref().child('rideRequest/$rideID');

    rideRef?.child('status').set('accepted');
    rideRef?.child('driver_name').set(currentDriveriInfo?.fullName);
    rideRef?.child('car_details').set(
        '${currentDriveriInfo?.carColor} - ${currentDriveriInfo?.carModel}');
    rideRef?.child('driver_phone').set(currentDriveriInfo?.phone);
    rideRef?.child('driver_id').set(currentDriveriInfo?.id);

    Map locationMap = {
      'latitude': currentPosition.latitude.toString(),
      'longitude': currentPosition.longitude.toString(),
    };

    rideRef?.child('driver_location').set(locationMap);

    DatabaseReference historyRef=FirebaseDatabase.instance.ref().child('drivers/${currentFirebaseUser!.uid}/history/$rideID');
    historyRef.set(true);
  }

  //to make the location updatebale all the time
  void getLocationUpdate() {
    LatLng oldPosition = LatLng(0, 0);

    ridePositionStream =
        Geolocator.getPositionStream(locationSettings: LocationOptions)
            .listen((Position position) {
      myPosition = position;
      currentPosition = position;
      LatLng pos = LatLng(position.latitude, position.longitude);

      var rotation = MapKitHelper.getMarkerRotation(oldPosition.latitude,
          oldPosition.longitude, pos.latitude, pos.longitude);

      Marker movingMarker = Marker(
        markerId: MarkerId('moving'),
        position: pos,
        icon: movingMarkerIcon,
        rotation: rotation,
        infoWindow: InfoWindow(title: 'Current Location'),
      );

      setState(() {
        CameraPosition cp = new CameraPosition(target: pos, zoom: 17);
        ridemapControler.animateCamera(CameraUpdate.newCameraPosition(cp));
        _markers.removeWhere((marker) => marker.mapsId.value == 'moving');
        _markers.add(movingMarker);
      });
      oldPosition = pos;
      updateTripDetails();

      Map locationMap = {
        'latitude': myPosition.latitude.toString(),
        'longitude': myPosition.longitude.toString(),
      };

      rideRef?.child('driver_location').set(locationMap);
    });
  }

  //to update the trip information
  Future<void> updateTripDetails() async {
    if (!isRequstingDirection) {
      isRequstingDirection = true;

      if (myPosition == null) {
        return;
      }

      var positionLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng? destinationLatLng;
      if (status == 'accepted') {
        destinationLatLng = widget.tripDetails.pickup;
      } else {
        destinationLatLng = widget.tripDetails.destination;
      }

      var directionDetails = await HelperMethods.getDirectionDetails(
          positionLatLng, destinationLatLng!);

      if (directionDetails != null) {
        print(directionDetails?.durationText);
        setState(() {
          durationtring = directionDetails!.durationText;
        });
      }
      isRequstingDirection = false;
    }
  }

  //timer counter in second for the trip
  void startTimer() {
  const interval=Duration(seconds: 1);
timer=Timer.periodic(interval, (timer) {
  durationCounter++;


});

  }

  //to finish the trip and show th fares
  void endTrip() async {
    timer.cancel();
    HelperMethods.showProgressDialog(context);
    var currentLatLng=LatLng(myPosition.latitude, myPosition.longitude);
     var directionDetails=await HelperMethods.getDirectionDetails(widget.tripDetails.pickup, currentLatLng);

     Navigator.pop(context);
     int fares=HelperMethods.estimateFares(directionDetails!, durationCounter);
     
     rideRef?.child('fares').set(fares.toString());
     rideRef?.child('status').set('ended');
     ridePositionStream?.cancel();

     showDialog(context: context,
     barrierDismissible: false,
       builder: (BuildContext context)=>CollectPayment(paymentMethode: widget.tripDetails.paymentMethode, fares: fares),

     );
    topUpEarnings(fares);



  }

  //total earnings
  void topUpEarnings(int fares) {
    DatabaseReference earningsRef=FirebaseDatabase.instance.ref().child('drivers/${currentFirebaseUser!.uid}/earnings');
    earningsRef.once().then((DatabaseEvent snapshot)
    {
      if(snapshot.snapshot.value!=null)
        {
          double oldEarnings=double.parse( snapshot.snapshot.value.toString());

          double adjusetEarning=(fares.toDouble())+oldEarnings;
          earningsRef.set(adjusetEarning.toStringAsFixed(2));

        }
      else
        {
          double adjusetEarning=(fares.toDouble());
          earningsRef.set(adjusetEarning.toStringAsFixed(2));
        }



    });

  }


  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadingBottom),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            circles: _circles,
            markers: _markers,
            polylines: _polylines,
            initialCameraPosition: GooglePlex,
            onMapCreated: (GoogleMapController controler) async {
              _controler.complete(controler);
              ridemapControler = controler;

              setState(() {
                mapPadingBottom = (Platform.isIOS) ? 255 : 260;
              });

              var cuurentLatLng =
                  LatLng(currentPosition.latitude, currentPosition.longitude);
              var pikupLatLng = widget.tripDetails.pickup;
              await getDirection(cuurentLatLng, pikupLatLng!);
              getLocationUpdate();
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15.0,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ))
                  ]),
              height: Platform.isIOS ? 280 : 280,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      durationtring,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Brand-Bold',
                        color: BrandColors.colorAccentPurple,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.tripDetails.riderName,
                            style: TextStyle(
                                fontSize: 22, fontFamily: 'Bran-Bold'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: GestureDetector(
                                onTap: ()
                                {
                                  _makePhoneCall("0598165709");



                                },



                                child: Icon(Icons.call)



                            ),


                          ),
                        ]),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'images/pickicon.png',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                            child: Container(
                          child: Text(
                           widget.tripDetails.pickupAddress,
                            style: TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'images/desticon.png',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                            child: Container(
                          child: Text(
                            widget.tripDetails.destinationAddress,
                            style: TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),

                    loginButton(buttonTitle, buttonColor,
                        onPressed: ()async {
                            if(status=='accepted')
                              {
                                status='arrived';
                                rideRef?.child('status').set('arrived');

                                setState(() {
                                  buttonTitle='          START TRIP          ';
                                  buttonColor=BrandColors.colorAccentPurple;
                                });
                                HelperMethods.showProgressDialog(context);
                                await getDirection(widget.tripDetails.pickup, widget.tripDetails.destination);
                                Navigator.pop(context);
                              }
                            else if(status=='arrived')
                              {
                                status='ontrip';
                                rideRef?.child('status').set('ontrip');
                                setState(() {
                                  buttonTitle='          END TRIP          ';
                                  buttonColor=Colors.red[900]!;
                                });
                                startTimer();
                              }
                            else if(status=='ontrip')
                              {
                                endTrip();
                              }


                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
