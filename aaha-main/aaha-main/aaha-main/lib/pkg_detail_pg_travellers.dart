import 'dart:math';

import 'package:aaha/services/agencyManagement.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'otherDetails.dart';
import 'otherDetails.dart';
import 'paymentInvoice.dart';
import 'Agency.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Widgets/allButton.dart';

class PkgDetailTraveller extends StatefulWidget {
  final Package1 package;
  const PkgDetailTraveller({Key? key, required this.package}) : super(key: key);

  @override
  State<PkgDetailTraveller> createState() => PkgDetailTravellerState();
}

class PkgDetailTravellerState extends State<PkgDetailTraveller> {
  double value = 0;

  @override
  Widget build(BuildContext context) {
    List<String> images = widget.package.ImgUrls;
    var agencyID = widget.package.agencyId;
    var agencyPhoneNumber =
        context.read<agencyProvider>().getPhoneNumber(agencyID);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white,
                Colors.blue,
              ],
            )),
          ),
          SafeArea(
            child: !widget.package.isSaved
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 300, horizontal: 100),
                    child: Column(
                      children: [
                        Text(
                          'Other Details Not ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' Added By The Agency',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : Container(
                    //margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(4),
                    width: 300,
                    //color: Colors.white,
                    child: Column(
                      children: [
                        const Text(
                          'Day Wise Detail: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: int.parse(widget.package.Days),
                                itemBuilder: (context, index) => ListTile(
                                      title: Text(
                                        'Day: ${index + 1}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        widget.package!.otherDetails[index],
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    )))
                      ],
                    ),
                  ),
          ),
          TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: value),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              builder: (_, double val, __) {
                return (Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..setEntry(0, 3, 300 * val)
                    ..rotateY((pi / 6) * val),
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(widget.package.PName,
                          style: TextStyle(color: Colors.black, fontSize: 25)),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                    ),
                    body: SingleChildScrollView(
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CarouselSlider(
                                options: CarouselOptions(
                                  height: 270,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 2),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  scrollDirection: Axis.horizontal,
                                ),
                                items: images
                                    .map((e) => Container(
                                          margin: const EdgeInsets.all(2),
                                          child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5.0)),
                                              child: Stack(
                                                children: <Widget>[
                                                  e.isNotEmpty
                                                      ? Image.network(
                                                          e,
                                                          fit: BoxFit.cover,
                                                          width: 450,
                                                          height: 300,
                                                        )
                                                      : Image.network(
                                                          'https://us.123rf.com/450wm/pavelstasevich/pavelstasevich1811/pavelstasevich181101028/112815904-no-image-available-icon-flat-vector-illustration.jpg?ver=6',
                                                          fit: BoxFit.cover,
                                                          width: 450,
                                                          height: 300,
                                                        ),
                                                ],
                                              )),
                                        ))
                                    .toList()),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: 'No. of Days: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: widget.package.Days,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Rating: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: widget.package.rating == 0
                                                    ? 'Unrated'
                                                    : widget.package.rating
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Location: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: widget.package.Location,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Cost: \$',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: widget.package.Price,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Agency Name: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: widget.package.Aname,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'Description: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Text(
                                              widget.package.Desc,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: allButton(
                                        buttonText: 'Other Details',
                                        onPressed: () {
                                          print(widget.package.isSaved);
                                          setState(() {
                                            value == 0 ? value = 1 : value = 0;
                                          });
                                        }),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: allButton(
                                            buttonText: 'Call',
                                            onPressed: () async {
                                              String phone =
                                                  await agencyPhoneNumber!;
                                              _makePhoneCall(phone);
                                            }),
                                      ),
                                      Expanded(
                                        child: allButton(
                                            buttonText: 'Book Now',
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          paymentInvoice(
                                                              package: widget
                                                                  .package)));
                                            }),
                                      ),

                                      // allButton(buttonText: 'Book Now', onPressed: (){}),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
              }),
          GestureDetector(
            onHorizontalDragUpdate: (e) {
              if (e.delta.dx < 0) {
                setState(() {
                  value = 0;
                });
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
