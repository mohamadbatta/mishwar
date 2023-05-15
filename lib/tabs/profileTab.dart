import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mishwar_driver/globalvariable.dart';
import 'package:mishwar_driver/widgets/BrandDivider.dart';

import '../screens/login_screen/login_screen.dart';
import '../widgets/ProgressDialog.dart';

class ProfileTab extends StatefulWidget {


  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late DatabaseReference _databaseReference;
  Map<dynamic, dynamic>? _userData;


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

  Signout() async {
    setState(() {
      FirebaseAuth.instance.signOut();
      //ChangeScreenAnimation.dispose();

      Navigator.popUntil(context, ModalRoute.withName(LoginScreen.id));
    });
  }



  @override
  void initState()  {
     Firebase.initializeApp();
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    super.initState();
    _databaseReference =
        FirebaseDatabase.instance.ref().child('drivers/${currentFirebaseUser!.uid}');
    _databaseReference.onValue.listen((event) {
      setState(() {
        _userData = event.snapshot.value as Map?;
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _userData == null
          ? CircularProgressIndicator()
          : Column(
        children: [

          SizedBox(height: 60),
          CircleAvatar(
            backgroundColor: Colors.grey[400],
            radius: 50,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 50,
            ),
          ),
          SizedBox(height: 20),

          Text(
            _userData?['name'] ?? '',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Driver',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'personal information',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          BrandDivider(),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(_userData?['email'] ?? ''),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(_userData?['phone'] ?? ''),
          ),
          Text(
            'vehicle details',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          BrandDivider(),
          ListTile(
            leading: Icon(Icons.car_rental_outlined),
            title: Text(_userData?['vehicle_details'] ["car_model"]?? ''),
          ),
          ListTile(
            leading: Icon(Icons.color_lens_outlined),
            title: Text(_userData?['vehicle_details'] ["car_color"]?? ''),
          ),
          ListTile(
            leading: Icon(Icons.numbers),
            title: Text(_userData?['vehicle_details'] ["vehicle_number"]?? ''),
          ),

          loginButton(
            "     logout     ",
            Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProgressDialog()),
              );

              Signout();
            },
          ),





        ],
      ),
    );
  }
}























/*
  @override
  Widget build(BuildContext context) {
    print("profile");
    return Scaffold(
      body: Column(
        children: <Widget>[

          SizedBox(height: 60),
          CircleAvatar(
            backgroundColor: Colors.grey[400],
            radius: 50,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 50,
            ),
          ),
          SizedBox(height: 20),

          Text(

            name ?? "null",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Driver',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(email??"null"),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(phoneNum??"null"),
          ),
          ListTile(
            leading: Icon(Icons.car_rental_outlined),
            title: Text(carModal??"null"),
          ),
          ListTile(
            leading: Icon(Icons.color_lens_outlined),
            title: Text(carColor??"null"),
          ),
          ListTile(
            leading: Icon(Icons.numbers),
            title: Text(carNum??"null"),
          ),
          loginButton(
            "     logout     ",
            Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProgressDialog()),
              );

              Signout();
            },
          ),
        ],
      ),
    );
  }
}*/








