import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../globalvariable.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/ProgressDialog.dart';
import '../../CarDetails/CarDetails.dart';
import '../../ForgotPasswrd_screen/forgot_password.dart';
import '../../MainPage/BotoomNavigroView.dart';
import '../animations/change_screen_animation.dart';
import 'bottom_text.dart';
import 'top_text.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;
  late final List<Widget> forgotPasswordContent;

  //the design of input field like text field
  Widget inputField(String hint, IconData iconData,
      {required bool obscureText,
        required TextEditingController controller,
        required TextInputType keyboardType}) {
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
            controller: controller,
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

  //the design of button login and signup
  Widget loginButton(String title, {required Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: kSecondaryColor,
          shape: const StadiumBorder(),
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

//this is devider and icon for google and facebook
  /*Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'or',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
*/
  /*Widget logos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image(image: AssetImage('images/facebook.png')),
          const SizedBox(width: 24),
       Image(image: AssetImage('images/google.png')),

        ],
      ),
    );
  }*/


  Widget? carDetails() {
Navigator.pop(context);
    Navigator.push(
      context,
      SlidePageRoute(page: CarDetailsPage()),
    );
    return null;
  }


  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            SlidePageRoute(page: ResetPasswordPage()),
          );
          /* final FirebaseAuth _auth = FirebaseAuth.instance;
          _auth
              .sendPasswordResetEmail(email: "mohamad.batta84@gmail.com");
*/
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  //create account content and login content
  @override
  void initState() {
    createAccountContent = [
      inputField(
        controller: nameController,
        'Name',
        Icons.person_outline,
        obscureText: false,
        keyboardType: TextInputType.name,
      ),
      inputField(
        'Email',
        Icons.mail_outline,
        obscureText: false,
        controller: emailControllerS,
        keyboardType: TextInputType.emailAddress,
      ),
      inputField(
        'Phone number',
        Icons.phone_android_outlined,
        obscureText: false,
        controller: phoneNumberController,
        keyboardType: TextInputType.phone,
      ),
      inputField(
        'Password',
        Icons.lock_outlined,
        obscureText: true,
        controller: passwordControllerS,
        keyboardType: TextInputType.visiblePassword,
      ),

      loginButton('Sign Up', onPressed: () async {
        if (!await checkInternetConnectivity()) {
          showSnackBar("no internet connection");
          return;
        }

        if (!isValidName(nameController.text.toString())) {
          showSnackBar("please provide a valid name");
          return;
        }

        if (!isValidEmail(emailControllerS.text.toString())) {
          showSnackBar("please provide a valid email address");
          return;
        }

        if (phoneNumberController.text.length < 10) {
          showSnackBar("please provide a valid phone number");
          return;
        }

        if (passwordControllerS.text.length < 8) {
          showSnackBar("password must be at least 8 character");
          return;
        }

        if (await isEmailRegistered(emailControllerS.text)) {
          showSnackBar("Email is already registered as rider");
          return;
        }

        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => ProgressDialog(),
        );

        registerUser();
      }),
      //orDivider(),
      //logos(),
    ];

    loginContent = [
      inputField('Email', Icons.mail_outline,
          obscureText: false,
          controller: emailControllerL,
          keyboardType: TextInputType.emailAddress),
      inputField('Password', Icons.lock_outlined,
          obscureText: true,
          controller: passwordControllerL,
          keyboardType: TextInputType.visiblePassword),
      loginButton('Log In', onPressed: () async {
        if (!await checkInternetConnectivity()) {
          showSnackBar("no internet connection");
          return;
        }

        if (!isValidEmail(emailControllerL.text.toString())) {
          showSnackBar("please provide a valid email address");
          return;
        }

        if (passwordControllerL.text.length < 8) {
          showSnackBar("password must be at least 8 character");
          return;
        }

        // show please wait dialog
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => ProgressDialog());

        loginUser();
      }),
      forgotPassword(),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    print('dispose login content');
    ChangeScreenAnimation.dispose();

    super.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var nameController = TextEditingController();
  var emailControllerS = TextEditingController();
  var phoneNumberController = TextEditingController();
  var passwordControllerS = TextEditingController();
  var passwordControllerL = TextEditingController();
  var emailControllerL = TextEditingController();

  //to check the email and password before login
  Future<void> loginUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

//to check if the email and password correct
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailControllerL.text,
        password: passwordControllerL.text,
      );

   //  Navigator.pop(context);
      //Navigator.pop(context);
      // The sign-in was successful, so you can navigate to the next screen

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );



    } on FirebaseAuthException catch (e) {
      //  Navigator.pop(context);
      if (e.code == 'user-not-found') {
        // The provided email address is not registered.
        Navigator.pop(context);
        showSnackBar("The provided email address is not registered");
      } else if (e.code == 'wrong-password') {
        // The provided password is incorrect.
        Navigator.pop(context);
        showSnackBar("The provided password is incorrect");
      }
    }
  }

//to send user email and password to firebase to be created
  Future<void> registerUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    UserCredential result = await _auth
        .createUserWithEmailAndPassword(
        email: emailControllerS.text, password: passwordControllerS.text)
        .catchError((ex) {
      //check error and display message
      // Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message.toString());
    });

    User? user = result.user;

    // Navigator.pop(context);
    //check if user registration is successful
    if (user != null) {
      currentFirebaseUser=user;
      //Prepare data to be saved  on user table
      DatabaseReference ref =
      FirebaseDatabase.instance.ref("drivers/${user.uid}");
      await ref.set({
        "name": nameController.text,
        "email": emailControllerS.text,
        "phone": phoneNumberController.text
      });


      carDetails();

    /*  //Take the user  to mainPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  MainPage()),
      );*/
    }
  }

//snack bar to notify the user if theres any error
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

//check the email if its valid or not
  bool isValidEmail(String email) {
    // Define a regular expression pattern for valid email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Check if the provided email matches the pattern
    return emailRegex.hasMatch(email);
  }

//check the name if its valid or not
  bool isValidName(String name) {
    final nameRegex = RegExp(r'^[a-zA-Z ]+$');
    return nameRegex.hasMatch(name);
  }

//function to check connectivity of wifi
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

//check if the email is Email Registered before or not
  Future<bool> isEmailRegistered(String email) async {
    try {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 136,
          left: 24,
          child: TopText(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createAccountContent,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loginContent,
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: BottomText(),
          ),
        ),
      ],
    );
  }
}
