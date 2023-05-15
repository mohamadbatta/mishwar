import 'dart:math' as math;

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../login_screen/components/center_widget/center_widget.dart';



class ResetPasswordPage extends StatefulWidget {
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  var emailControllerf = TextEditingController();

  Widget inputField(String hint, IconData iconData,
      {required bool obscureText,
        required TextInputType keyboardType, required TextEditingController Controller}) {
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



  bool isValidEmail(String email) {
    // Define a regular expression pattern for valid email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Check if the provided email matches the pattern
    return emailRegex.hasMatch(email);
  }



  Future<bool> isEmailRegistered(String email) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: 'password', // Dummy password
      );
      // If the email is registered, the above line will throw an exception
      // because the user is being created again with the same email.
      // We don't need the created user, so we immediately delete it.
      await userCredential.user?.delete();
      return false; // Email is not registered
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {

        return true; // Email is already registered
      }
      return false;

    }
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
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
               'Reset\nPassword',
               style: TextStyle(fontSize: 40,
                 fontWeight: FontWeight.w600,))),


           inputField(
             Controller:emailControllerf,
             'Email',
             Icons.mail_outline,
             obscureText: false,

             keyboardType: TextInputType.emailAddress,
           ),

             loginButton("Reset", onPressed: () async {

               if (!await checkInternetConnectivity()) {
               showSnackBar("no internet connection");
               return;
               }

               if (!isValidEmail(emailControllerf.text)) {

                 print(emailControllerf.text.toString());
               showSnackBar("please provide a valid email address");
               return;
               }

               if(!await isEmailRegistered(emailControllerf.text))
                 {
                   showSnackBar("this email not registered");
                   return;
                 }

               final FirebaseAuth _auth = FirebaseAuth.instance;
             _auth
                 .sendPasswordResetEmail(email: emailControllerf.text);
             showSnackBar("reset password link sent to your email");
               Navigator.pop(context);


             },),
    loginButton("back", onPressed:(){Navigator.pop(context);} )





    ],
        ),
        ],
      ),
    );
  }
}



