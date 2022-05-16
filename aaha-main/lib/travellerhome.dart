import 'package:aaha/Agency.dart';
import 'package:aaha/loginUser.dart';
import 'package:aaha/services/agencyManagement.dart';
import 'package:aaha/services/packageManagement.dart';
import 'package:aaha/topRatedAgencies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pkg_detail_pg_travellers.dart';
import 'searchPage.dart';
import 'topTravelDestinations.dart';
import 'services/travellerManagement.dart';
import 'AgHomeTvView.dart';
import 'Agency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TravellerHome extends StatefulWidget {
  const TravellerHome({Key? key}) : super(key: key);

  @override
  State<TravellerHome> createState() => _TravellerHomeState();
}

class _TravellerHomeState extends State<TravellerHome> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read<packageProvider>().setPackagesTraveler();
    });

    super.initState();
  }

  final TextEditingController searchbarController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: FutureBuilder<String>(
            future: context
                .read<travellerProvider>()
                .getName(FirebaseAuth.instance.currentUser),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  'Hi, ' + snapshot.data!.toString(),
                  style: TextStyle(color: Colors.black),
                );
              }
              return CircularProgressIndicator(
                color: Colors.black,
              );
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  packageManagement.p1 = [];
                  PackageList = [];
                  loginUser.agencyListLocal = [];
                  agencyManagement.AgenciesList = [];
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ))
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 250,
                width: 400,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://wallpaperaccess.com/full/51364.jpg',
                      ),
                      fit: BoxFit.fill,
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Where do you wish to go?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                      padding: const EdgeInsets.all(1),
                      height: 40,
                      width: 350,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                      //alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                              child: TextField(
                                controller: searchbarController,
                                decoration: const InputDecoration(
                                  hintText: 'Search for Places',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                cursorColor: Colors.black,
                                cursorHeight: 20,
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: InkWell(
                                child: Icon(Icons.search,
                                    size: 30, color: Colors.grey.shade700),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => searchPage(
                                            searchTerm:
                                                searchbarController.text,
                                          )));
                                },
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          title: const Text(
                            'Top Travel Packages',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: InkWell(
                            // onTap: null,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      topTravelDestinations()));
                            },
                            child: Text('See All'),
                          ),
                        ),
                        topTravelPackages(),
                        ListTile(
                          title: Text(
                            'Top Rated Agencies',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => topSellingAgencies()));
                            },
                            child: Text('See All'),
                          ),
                        ),
                        topRatedAgencies(),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class topTravelPackages extends StatelessWidget {
  final CollectionReference Packages =
      FirebaseFirestore.instance.collection('Packages');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Packages.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading . .. ");
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8),
            child: SizedBox(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var package = snapshot.data.docs[index];
                          return Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(25), // Image border
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(50), // Image radius
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PkgDetailTraveller(
                                                  package: Package1(
                                                      package['Package id'],
                                                      package['Package name'],
                                                      package['Agency Name'],
                                                      package['price'],
                                                      package['days'],
                                                      package['description'],
                                                      package['Location'],
                                                      double.parse(
                                                          package['Rating']
                                                              .toString()),
                                                      package['Agency id'],
                                                      package['photoUrl'],
                                                      package['ImgUrls']
                                                          .cast<String>(),
                                                      package['otherDetails']
                                                          .cast<String>(),
                                                      package['isSaved']),
                                                )));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            snapshot.data.docs[index]
                                                ['photoUrl'],
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                    child: Center(
                                      child: Text(
                                        snapshot.data.docs[index]
                                            ['Package name'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class topRatedAgencies extends StatefulWidget {
  @override
  State<topRatedAgencies> createState() => _topRatedAgenciesState();
}

class _topRatedAgenciesState extends State<topRatedAgencies> {
  final CollectionReference Agencies =
      FirebaseFirestore.instance.collection('Agencies');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Agencies.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading . .. ");
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8),
            child: SizedBox(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var agency = snapshot.data.docs[index];
                          return Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(25), // Image border
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(50), // Image radius
                                child: InkWell(
                                  onTap: () {
                                    for (var i = 0;
                                        i < packageManagement.p1.length;
                                        i++) {
                                      setState(() {
                                        if (packageManagement.p1[i].agencyId ==
                                            context
                                                .read<agencyProvider>()
                                                .getAgencyList()[index]
                                                .uid) {
                                          PackageList.add(
                                              packageManagement.p1[i]);
                                        }
                                      });
                                    }

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => AgHomeTvView(
                                                  agencyID: snapshot
                                                      .data.docs[index]['uid'],
                                                )))
                                        .then((value) => PackageList = []);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            snapshot.data.docs[index]
                                                ['photoUrl'],
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                    child: Center(
                                      child: Text(
                                        snapshot.data.docs[index]['name'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
