import 'package:aaha/Agency.dart';
import 'package:aaha/services/packageManagement.dart';
import 'package:flutter/material.dart';
import 'AgHomeAgView.dart';
import 'ProfileAgency.dart';
import 'bookingHistory.dart';
import 'bookingHistoryAg.dart';
import 'mainScreen.dart';
import 'travellerProfile.dart';
import 'travellerhome.dart';

class MyBottomBarDemo1 extends StatefulWidget {
  const MyBottomBarDemo1({Key? key }) : super(key: key);
  @override
  _MyBottomBarDemoState1 createState() => new _MyBottomBarDemoState1();
}

class _MyBottomBarDemoState1 extends State<MyBottomBarDemo1> {
  int _pageIndex = 0;
  late PageController _pageController;

  List<Widget> tabPages = [
    TravellerHome(),
    bookingHistory(),
    travellerProfile(),
  ];



  @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem( icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],

      ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
    );
  }
  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
    packageManagement.p1=[];
    PackageList=[];
  }
}