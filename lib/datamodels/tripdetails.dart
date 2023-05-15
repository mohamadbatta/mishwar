import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetails{
  String destinationAddress;
  String pickupAddress;
  LatLng? pickup;
  LatLng? destination;
  String rideID;
  String paymentMethode;
  String riderName;
  String riderPhone;


  TripDetails({
     this.rideID='',
      this.destination,
      this.pickup,
     this.destinationAddress='',
     this.pickupAddress='',
     this.paymentMethode='',
     this.riderName='',
     this.riderPhone='',

          });





}