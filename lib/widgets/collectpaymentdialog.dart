import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mishwar_driver/brand_colors.dart';
import 'package:mishwar_driver/helpers/helpermethode.dart';
import 'package:mishwar_driver/widgets/BrandDivider.dart';
import 'package:mishwar_driver/widgets/ConfirmSheet.dart';

class CollectPayment extends StatelessWidget {


  final String paymentMethode;
  final int fares;
  CollectPayment({required this.paymentMethode,required this.fares});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:<Widget> [
            SizedBox(height: 20,),
            
            Text('${paymentMethode.toUpperCase()} PAYMENT'),

            SizedBox(height: 20,),

            BrandDivider(),

            SizedBox(height: 16,),

            Text('\₪$fares',style: TextStyle(fontFamily: 'Brand-Bold',fontSize: 50),),

            SizedBox(height: 16,),

            Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Amount above is the total fares to be charged to the rider',textAlign: TextAlign.center,),

            ),

            SizedBox(height:30 ,),

            Container(
              width: 230,
              child: loginButton((paymentMethode=='cash')?'COLLECT CASH':'CONFIRM', BrandColors.colorGreen,
                  onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);

                HelperMethods.enableHomeTabLocationUpdate();

              }),
            ),

            SizedBox(height: 40,),






          ],
        ),
      ),
    );
  }
}
