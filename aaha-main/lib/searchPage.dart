import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'pkg_detail_pg_travellers.dart';
import 'Agency.dart';

class searchPage extends StatefulWidget {
  final searchTerm; //searchTerm is the value received by travellerhome
  const searchPage({Key? key, required this.searchTerm}) : super(key: key);

  @override
  State<searchPage> createState() => _searchPageState();
}

final TextEditingController searchbarController = TextEditingController();
String searchedTerm =
    ''; // searchedTerm is the value that is used and changed in this page

class _searchPageState extends State<searchPage> {
  @override
  void initState() {
    // TODO: implement initState
    searchedTerm = widget.searchTerm;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        leadingWidth: 0,
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: searchbarController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.filter_list_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Search for destinations",
                fillColor: Colors.white),
            onSubmitted: (value) {
              setState(() {
                searchedTerm = value;
              });
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: searchResults(
        searchTerm: searchedTerm,
      ),
    );
  }
}

class searchResults extends StatefulWidget {
  final String searchTerm;
  const searchResults({Key? key, required this.searchTerm}) : super(key: key);

  @override
  State<searchResults> createState() => _searchResultsState();
}

class _searchResultsState extends State<searchResults> {
  @override
  Widget build(BuildContext context) {
    CollectionReference Packages =
        FirebaseFirestore.instance.collection('Packages');
    return StreamBuilder(
      stream:
          Packages.where('Location', isEqualTo: widget.searchTerm.toLowerCase())
              .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.docs.length > 0) {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var package = snapshot.data.docs[index];
                return Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      // color: Colors.black,
                      elevation: 0,
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PkgDetailTraveller(
                                    package: Package1(
                                        package['Package id'],
                                        package['Package name'],
                                        package['Agency Name'],
                                        package['price'],
                                        package['days'],
                                        package['description'],
                                        package['Location'],
                                        double.parse(
                                            package['Rating'].toString()),
                                        package['Agency id'],
                                        package['photoUrl'],
                                        package['ImgUrls'].cast<String>(),
                                        package['otherDetails'].cast<String>(),
                                        package['isSaved']),
                                  )));
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
                                  'Package ' +
                                      snapshot.data.docs[index]['Package name'],
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
                                snapshot.data.docs[index]['days'] + ' Days',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data.docs[index]['Agency Name'],
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                  '\$ ' + snapshot.data.docs[index]['price'],
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
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
