import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../brand_colors.dart';
import '../dataprovider.dart';
import '../screens/historypage/historypage.dart';
import '../widgets/BrandDivider.dart';

class EarningsTab extends StatefulWidget {
  const EarningsTab({Key? key}) : super(key: key);

  @override
  State<EarningsTab> createState() => _EarningsTabState();
}

class _EarningsTabState extends State<EarningsTab> {
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Container(
          color: BrandColors.colorPrimary,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Text(
                  'Total Earnings',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '\₪${Provider.of<AppData>(context).earnings}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Brand-Bold'),
                )
              ],
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryPage()));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              children: [
                Image.asset(
                  'images/taxi.png',
                  width: 70,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Trips',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Expanded(
                    child: Container(
                        child: Text(
                          Provider.of<AppData>(context).tripCount.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ))),
              ],
            ),
          ),
        ),
        BrandDivider(),
      ],
    );
  }
}
