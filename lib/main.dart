import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mishwar_driver/dataprovider.dart';
import 'package:mishwar_driver/globalvariable.dart';
import 'package:mishwar_driver/screens/MainPage/BotoomNavigroView.dart';
import 'package:mishwar_driver/screens/login_screen/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'firebase_options.dart';

// Change to false to use live database instance.
const USE_DATABASE_EMULATOR = true;

// The port we've set the Firebase Database emulator to run on via the
// `firebase.json` configuration file.
const emulatorPort = 9000;
// Android device emulators consider localhost of the host machine as 10.0.2.2
final emulatorHost =
(!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
    ? '10.0.2.2'
    : 'localhost';

Future<void> main() async {




  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentFirebaseUser =await FirebaseAuth.instance.currentUser;

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  WidgetsFlutterBinding.ensureInitialized();






  runApp(MyApp());

  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (USE_DATABASE_EMULATOR) {
    FirebaseDatabase.instance.useDatabaseEmulator(emulatorHost, emulatorPort);
  }





}


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}




class MyApp extends StatelessWidget {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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



  Future<bool> requestPhoneCallPermission() async {
    var result = await [Permission.phone].request();
    if (result[Permission.phone] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    requestPhoneCallPermission();
    _getLocationPermission();
    return ChangeNotifierProvider(

      create: ( context) =>AppData(),
      child: MaterialApp(

        // title: 'Login App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: Theme
                .of(context)
                .textTheme
                .apply(
              fontFamily: 'Montserrat',
            ),
          ),

          initialRoute: (currentFirebaseUser == null)
              ? LoginScreen.id
              : BottomNavBar.id,
          // MainPage.id,
          routes: {
            BottomNavBar.id: (context) => BottomNavBar(),
            LoginScreen.id: (context) => const LoginScreen(),
          }
      ),
    );
  }



}
