import 'package:aaha/Agency.dart';
import 'package:aaha/addPackage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AgHomeAgView.dart';
import 'Pkg_details_Ag.dart';
import 'services/agencyManagement.dart';
import 'services/packageManagement.dart';

class AgencyHome extends StatefulWidget {
  const AgencyHome({Key? key}) : super(key: key);

  @override
  State<AgencyHome> createState() => AgencyHomeState();
}

class AgencyHomeState extends State<AgencyHome> {
  void initState() {
    PackageList = [];
    packageManagement.p1 = [];
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context
          .read<packageProvider>()
          .setPackages(FirebaseAuth.instance.currentUser!.uid);
    });
  }

  static String Agencyname = '';

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
          leading: const Icon(
            Icons.account_circle,
            color: Colors.black,
          ),
          title: FutureBuilder<String>(
            future: context
                .read<agencyProvider>()
                .getName(FirebaseAuth.instance.currentUser),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Agencyname = snapshot.data!.toString();
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
                  FirebaseAuth.instance.signOut();

                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ))
          ],
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 250,
              width: 400,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  //color: Colors.blue,
                  image: DecorationImage(
                image: NetworkImage(
                  'https://wallpaperaccess.com/full/51364.jpg',
                ),
                fit: BoxFit.fill,
              )),
              child: const Text(
                'WELCOME ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  // fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
            ),
            Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(
                      'Your Top selling Packages',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: InkWell(
                      child: const Text(
                        'See All',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AgHomeAgView(
                                  agencyID:
                                      FirebaseAuth.instance.currentUser!.uid,
                                )));
                      },
                    )),
              ],
            ),
            topSellingPackages(),
            Row(
              children: [
                const Expanded(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Text(
                    'Recently Added Packages',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: InkWell(
                      child: const Text(
                        'See All',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AgHomeAgView(
                                agencyID:
                                    FirebaseAuth.instance.currentUser!.uid)));
                      },
                    )),
              ],
            ),
            recentlyAddedPackages(),
          ],
        ),
      ),
    );
  }
}

class recentlyAddedPackages extends StatelessWidget {
  final CollectionReference Packages =
      FirebaseFirestore.instance.collection('Packages');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Packages.where('Agency id',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('packageAddedDate')
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading . .. ");
          }
          if (snapshot.hasData && snapshot.data.size > 0) {
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
                                  size:
                                      const Size.fromRadius(50), // Image radius
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PkgDetailAgency(
                                                    pack: Package1(
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
          }

          return Column(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => addPackage()));
                  },
                  child: Text(
                    'Please add a package',
                    style: TextStyle(fontSize: 20),
                  )),
              SizedBox(
                height: 60,
              )
            ],
          );
        });
  }
}

class topSellingPackages extends StatelessWidget {
  final CollectionReference Packages =
      FirebaseFirestore.instance.collection('Packages');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Packages.where('Agency id',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('sales', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading . .. ");
          }
          if (snapshot.hasData && snapshot.data.size > 0) {
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
                                  size:
                                      const Size.fromRadius(50), // Image radius
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PkgDetailAgency(
                                                    pack: Package1(
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
          }

          return TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => addPackage()));
              },
              child: Text(
                'Please add a package',
                style: TextStyle(fontSize: 20),
              ));
        });
  }
}
