import 'package:aaha/services/agencyManagement.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'services/packageManagement.dart';
import 'AgHomeTvView.dart';
import 'Agency.dart';
import 'loginUser.dart';
class topSellingAgencies extends StatelessWidget {
  const topSellingAgencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: const Text(
          "Top Selling Agencies",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: topAgencies(),
    );
  }
}

class topAgencies extends StatefulWidget {
  @override
  _topAgenciesState createState() => _topAgenciesState();
}

class _topAgenciesState extends State<topAgencies> {
  @override
  Widget build(BuildContext context) {
    CollectionReference Agencies =
    FirebaseFirestore.instance.collection('Agencies');
    return StreamBuilder(
      stream: Agencies.orderBy('sales',descending: true).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.docs.length > 0) {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var agency = snapshot.data.docs[index];
                return Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ListTile(
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
                          print(loginUser.agencyListLocal.length);
                          print(packageManagement.p1.length);
                          print(PackageList.length);

                          Navigator.of(context)
                              .push(MaterialPageRoute(
                              builder: (context) => AgHomeTvView(
                                agencyID: snapshot.data.docs[index]['uid'],
                              )
                          )).then((value) => PackageList=[]);
                        },
                        title: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.network(
                              snapshot.data.docs[index]['photoUrl']),
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Agency ' +
                                      snapshot.data.docs[index]['name'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                snapshot.data.docs[index]['sales'].toString() + ' Sales',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Give them a call : '+
                                  snapshot.data.docs[index]['phoneNum'],
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        } else {
          return (Center(
            child: Text(
              'Not Found',
              style: TextStyle(fontSize: 25),
            ),
          ));
        }
      },
    );
  }
}


