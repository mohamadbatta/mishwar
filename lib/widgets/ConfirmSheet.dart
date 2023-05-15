
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../brand_colors.dart';


Widget loginButton(String title, var color,{required Function() onPressed} ) {

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
          fontFamily: 'Brand-Bold',
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: BrandColors.colorText,
        ),
      ),
    ),
  );
}

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final  dynamic   onPressed;

  const ConfirmSheet({Key? key, required this.title, required this.subtitle, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            spreadRadius: 0.5,
            offset: Offset(
              0.7,
              0.7,

            )
          ),

        ]
      ),
      height: 279,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24,vertical: 18),
        child: Column(
          children: <Widget>[
            SizedBox(height: 25,),

            Text(
               title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22,fontFamily: 'Brand-Bold',color: BrandColors.colorText),
            ),
            SizedBox(height: 30,),

            Text(
             subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: BrandColors.colorTextLight),
            ),

            Row(
              children: <Widget>[

                  Expanded(
                    child: Container(
                      child: loginButton(
                          'BACK',
                          BrandColors.colorLightGrayFair,
                          onPressed: (){


                            Navigator.pop(context);

                          }),
                    ),
                  ),

                SizedBox(width: 20,),


                Expanded(
                  child: Container(
                    child:  loginButton(
                        'CONFIRM',
                      (title=='GO ONLINE') ?BrandColors.colorGreen:Colors.red,
                        onPressed: onPressed,

                  ),
                ),




                ),
              ],


            )


          ],

        ),
      ),






    );
  }
}
