
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mishwar_driver/brand_colors.dart';
import 'package:mishwar_driver/datamodels/tripdetails.dart';
import 'package:mishwar_driver/globalvariable.dart';
import 'package:mishwar_driver/helpers/helpermethode.dart';
import 'package:mishwar_driver/screens/newtrip_screen/newtrippage.dart';
import 'package:mishwar_driver/widgets/BrandDivider.dart';
import 'package:toast/toast.dart';

import 'ProgressDialog.dart';

class NotificationDialog extends StatelessWidget {

 TripDetails tripDetails=TripDetails();


  NotificationDialog({ required this.tripDetails});


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin:EdgeInsets.all(4) ,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: <Widget>[

            SizedBox(height: 30.0,),

            Image.asset('images/taxi.png',width: 100,),
            
            SizedBox(height: 16.0,),
            
            Text("NEW TRIP REQUEST",style: TextStyle(fontFamily: 'Brand-bold',fontSize: 18),),
            
            SizedBox(height: 30.0,),
            
            Padding(padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset('images/pickicon.png',height: 16,width: 16,),
                    SizedBox(width: 18,),
                    
                    Expanded(child: Container(child: Text(tripDetails.pickupAddress,style: TextStyle(fontSize: 18),))),
                  ],
                ),
                
                SizedBox(height: 15,),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset('images/desticon.png',height: 16,width: 16,),
                    SizedBox(width: 18,),
                    
                    Expanded(child: Container(child: Text(tripDetails.destinationAddress,style: TextStyle(fontSize: 18),))),

                  ],
                )
              ],
            ),),

            BrandDivider(),

            SizedBox(height: 8,),

            Padding(
                padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Container(
                        child:loginButton(
                            'DECLINE',
                            BrandColors.colorPrimary,
                            onPressed: ()
                                   async{
                                          assetsAudioPlayer.stop();
                                          Navigator.pop(context);
                                   }

                        ) ,
                      )
                  ),

                  SizedBox(width: 10,),

                  Expanded(
                      child: Container(
                        child:loginButton(
                            'ACCEPT',
                            BrandColors.colorGreen,
                            onPressed: ()
                            async{
                              assetsAudioPlayer.stop();
                              checkAvailablity(context);

                            }

                        ) ,
                      )
                  ),

                ],



              ),


            ),

          ],
        ),
      ),
    );
  }


 void checkAvailablity(context) {
   showDialog(
     barrierDismissible: false,
     context: context,
     builder: (BuildContext context) => ProgressDialog(),
   );


   DatabaseReference newRideRef = FirebaseDatabase. instance.ref().child("drivers/${currentFirebaseUser!.uid}/newtrip");
   newRideRef.once().then((DatabaseEvent databaseEvent){
     Navigator.pop(context);
     Navigator.pop(context);
     String thisRideID="";
     if (databaseEvent.snapshot.value != null) {
       thisRideID=databaseEvent.snapshot.value.toString();
     }

     else{
       Toast.show("Ride has been ride not found", duration: Toast.lengthShort, gravity:  Toast.bottom);
       }

     if(thisRideID == tripDetails.rideID){
       newRideRef.set ("accepted");
       HelperMethods.disableHomeTabLocationUpdate();
       ToastContext t= ToastContext();
       t.init(context);
       Toast.show("Ride has been accepted", duration: Toast.lengthShort, gravity:  Toast.bottom);
       Navigator.push(context,
           MaterialPageRoute(builder: (context)=>NewTripPage(tripDetails: tripDetails,)));
     }

     else if(thisRideID == 'cancelled' ){
       Toast.show("Ride has been cancelled", duration: Toast.lengthShort, gravity:  Toast.bottom);

     }

     else if(thisRideID == 'timeout') {
       Toast.show("Ride has been timeout", duration: Toast.lengthShort, gravity:  Toast.bottom);

     }
     else {

      Toast.show("Ride has been ride not found", duration: Toast.lengthShort, gravity:  Toast.bottom);

     }


   }
   );}


  Widget loginButton(String title, var color, {required Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(16),
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






}
