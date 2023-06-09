
import 'package:flutter/material.dart';

import '../brand_colors.dart';
import '../datamodels/history.dart';
import '../helpers/helpermethode.dart';


class HistoryTile extends StatelessWidget {

  final History history;
  HistoryTile({required this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: <Widget>[

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(
                child: Row(
                  children: <Widget>[

                    Image.asset('images/pickicon.png', height: 16, width: 16,),
                    SizedBox(width: 18,),
                    Expanded(child: Container(child: Text(history.pickup, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18),))),
                    SizedBox(width: 5,),

                    Text('\$${history.fares}', style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 16, color: BrandColors.colorPrimary),),
                  ],
                ),
              ),

              SizedBox(height: 8,),

              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset('images/desticon.png', height: 16, width: 16,),
                  SizedBox(width: 18,),

                  Text(history.destination, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18),),


                ],
              ),

              SizedBox(height: 15,),
                  Text(history.createdAt, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18)),


            ],
          ),


        ],
      ),
    );
  }
}