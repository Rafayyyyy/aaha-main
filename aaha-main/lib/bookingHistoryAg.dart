import 'package:flutter/material.dart';
import './bookingHistoryHistory.dart';
import './bookingHistoryScheduled.dart';
import 'bookingHistoryAgHistory.dart';
import 'bookingHistoryAgScheduled.dart';

class bookingHistoryAg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent.withOpacity(0.5),
              title: Text(
                'Bookings',
                textAlign: TextAlign.center,
              ),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.history), text: "History"),
                  Tab(icon: Icon(Icons.watch_later_outlined), text: "Scheduled")
                ],
              ),
            ),
            body: TabBarView(
              children: [
                HistoryAg(),
                ScheduledAg(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
