import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rating_dialog/rating_dialog.dart';
class Scheduled extends StatelessWidget {
  const Scheduled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      showRatingDialog() {
      // actual store listing review & rating

      final _dialog = RatingDialog(
        initialRating: 1.0,
        // your app's name?
        title: Text(
          'Rate Your Trip',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        // encourage your user to leave a high rating?
        message: Text(
          'How was your experience with XYZ Traavels',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
        // your app's logo?
        image: const FlutterLogo(size: 100),
        submitButtonText: 'Submit',
        commentHint: 'Tap a star to set your rating.',
        onCancelled: () => print('cancelled'),
        onSubmitted: (response) {
          print('rating: ${response.rating}, comment: ${response.comment}');

        },
      );

      // show the dialog
      showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) => _dialog,
      );
    }
    return Scaffold(
      body: bookingScheduledListTraveller(),
    );
  }



}
class bookingScheduledListTraveller extends StatelessWidget {
  final CollectionReference Packages =
  FirebaseFirestore.instance.collection('Bookings');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Packages.where('travellerID',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('travelEndDate', isGreaterThan: DateTime.now())
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading . .. ");
        }

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (BuildContext context, int index) {
            var packageEntry = snapshot.data.docs[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Stack(
                children: [
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snapshot.data.docs[index]['packageName'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),


                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              snapshot.data.docs[index]['packageNumOfDays'] + ' Days'),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Desciption:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              snapshot.data.docs[index]['packageDescription'].length <120 ?
                              snapshot.data.docs[index]['packageDescription'] :
                              snapshot.data.docs[index]['packageDescription'].substring(0,120)
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Ended On:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              DateFormat('EEE, MMM d, ''yy').format((snapshot.data.docs[index]['travelEndDate'] as Timestamp).toDate())),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data.docs[index]['agencyName'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18),
                            ),
                            Text(
                              '\$ ' + snapshot.data.docs[index]['packagePrice'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}