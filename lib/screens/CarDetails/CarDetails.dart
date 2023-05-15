import 'dart:math' as math;
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../globalvariable.dart';
import '../../utils/constants.dart';
import '../../widgets/ProgressDialog.dart';

import '../MainPage/BotoomNavigroView.dart';
import '../login_screen/components/center_widget/center_widget.dart';


class CarDetailsPage extends StatefulWidget {
  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  var carModileControllerf = TextEditingController();
  var carColorControllerf = TextEditingController();
  var vehcilNumberControllerf = TextEditingController();

  Widget inputField(String hint, IconData iconData,
      {
        required bool obscureText,
        required TextInputType keyboardType, required TextEditingController Controller, required controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            controller: Controller,

            obscureText: obscureText,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }


  Widget loginButton(String title, {required Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          primary: kSecondaryColor,
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





  void showSnackBar(String title) {

    final snackBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget topWidget(double screenWidth) {
    return Transform.rotate(
      angle: -35 * math.pi / 180,
      child: Container(
        width: 1.2 * screenWidth,
        height: 1.2 * screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          gradient: const LinearGradient(
            begin: Alignment(-0.2, -0.8),
            end: Alignment.bottomCenter,
            colors: [
              Color(0x007CBFCF),
              Color(0xB316BFC4),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomWidget(double screenWidth) {
    return Container(
      width: 1.5 * screenWidth,
      height: 1.5 * screenWidth,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment(0.6, -1.1),
          end: Alignment(0.7, 0.8),
          colors: [
            Color(0xDB4BE8CC),
            Color(0x005CDBCF),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(

      body: Stack(
        children: [
          Positioned(
            top: -160,
            left: -30,
            child: topWidget(screenSize.width),
          ),
          Positioned(
            bottom: -180,
            left: -40,
            child: bottomWidget(screenSize.width),
          ),
          CenterWidget(size: screenSize),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [ Align(
                alignment: Alignment.topLeft,
                child: Text(
                    'Vehicle\nDetails',
                    style: TextStyle(fontSize: 40,
                      fontWeight: FontWeight.w600,))),


              inputField(
                controller: carModileControllerf,
                'Car model',
                Icons.car_rental_outlined,
                obscureText: false,
                keyboardType: TextInputType.text,
                Controller: carModileControllerf,
              ),
              inputField(
                'Car color',
                Icons.color_lens_outlined,
                obscureText: false,
                controller: carColorControllerf,
                keyboardType: TextInputType.text,
                Controller: carColorControllerf,
              ),
              inputField(
                'Vehicle number',
                Icons.numbers,
                obscureText: false,
                controller: vehcilNumberControllerf,
                keyboardType: TextInputType.number,
                Controller: vehcilNumberControllerf,
              ),


              loginButton("PROCEED", onPressed: () async {

                if(carModileControllerf.text.length<3)
                  {
                    showSnackBar('please provide a valid module');
                    return;
                  }

                if(carColorControllerf.text.length<3)
                {
                  showSnackBar('please provide a valid car color');
                  return;
                }

                if(vehcilNumberControllerf.text.length<3)
                {
                  showSnackBar('please provide a valid vehicle number');
                  return;
                }

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => ProgressDialog(),
                );


                updateProfile(context);


              },),

            ],
          ),
        ],
      ),
    );
  }



  void updateProfile(context)
  {
    String? id=currentFirebaseUser?.uid;
    DatabaseReference driverRef =
    FirebaseDatabase.instance.ref("drivers/${currentFirebaseUser?.uid}/vehicle_details");

    Map map={
      'car_color':carColorControllerf.text,
      'car_model':carModileControllerf.text,
      'vehicle_number':vehcilNumberControllerf.text,
    };

    driverRef.set(map);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  BottomNavBar()),
    );

  }

}


class SlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}



