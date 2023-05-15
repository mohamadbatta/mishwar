import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mishwar_driver/brand_colors.dart';
import 'package:mishwar_driver/tabs/earningsTab.dart';
import 'package:mishwar_driver/tabs/homeTab.dart';
import 'package:mishwar_driver/tabs/profileTab.dart';
import 'package:mishwar_driver/tabs/ratingsTab.dart';

import '../../globalvariable.dart';

class BottomNavBar extends StatefulWidget {
  static const String id = 'Bottom';

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> screens = [
    HomeTab(
      key: PageStorageKey('HomeTab'),

    ),
    EarningsTab(
      key:PageStorageKey('EarningsTab'),
    ),
    RatingsTab(
      key:PageStorageKey('RatingsTab'),
    ),
    ProfileTab(
      key:PageStorageKey('ProfileTab'),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),

        child: CurvedNavigationBar(

          key: _bottomNavigationKey,
          index: 0,
          height: 65.0,
          items: <Widget>[
            Icon(
              Icons.home,
              size: 30,
                color: Colors.white

            ),
            Icon(

              Icons.credit_card,
              size: 30,
                color: Colors.white
            ),
            Icon(
              Icons.star,
              size: 30,
                color: Colors.white
            ),
            Icon(
              Icons.perm_identity,
              size: 30,
                color: Colors.white

            ),
          ],
          color: Colors.green,
          buttonBackgroundColor: Colors.green,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: speedOfBottomNavigationBarAnimation),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
      ),






      body:IndexedStack(
        index: _page,
        children: screens,

      ),
    );
  }
}
