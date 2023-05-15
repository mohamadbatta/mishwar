import 'package:flutter/material.dart';





class AvailibilityButton extends StatelessWidget{

  String title;
  final Function() onPressed;
  final Color color;

  AvailibilityButton({required this.title,required this.onPressed,required this.color});



  Widget loginButton(String title,  Function() onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(


        backgroundColor: color,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(25)
        ),
        elevation: 8,
        shadowColor: Colors.black87,
      ),


      child: Container(
        height: 50,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Brand-Bold',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return loginButton(title,  onPressed,color);


  }






}