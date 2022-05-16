import 'package:aaha/Agency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:aaha/MyBottomBarDemo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'packageManagement.dart';
import 'package:aaha/Agency.dart';

import '../Agency.dart';

class agencyManagement {
  static List<Agency1> AgenciesList = [];
  final String uid;
  agencyManagement({required this.uid});
  CollectionReference Agency =
      FirebaseFirestore.instance.collection('Agencies');
  storeNewAgency(user, name, phoneNum, context) {
    Agency.doc(uid).set({
      'email': user.email,
      'uid': user.uid,
      'name': name,
      'phoneNum': phoneNum,
      'location': const GeoPoint(0.0, 0.0),
      'about': 'About you',
      'photoUrl': 'https://cdn-icons-png.flaticon.com/512/32/32441.png',
      'sales': 0
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MyBottomBarDemo(),
      ));
    });
  }

  static Agency1 fromJson(Map<String, dynamic> json) {
    Agency1 agency = Agency1(
      json['name'],
      json['phoneNum'],
      json['about'],
      json['email'],
      json['location'],
      json['photoUrl'],
      json['uid'],
    );
    return agency;
  }

  static getAgencies() async {
    await FirebaseFirestore.instance
        .collection('Agencies')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        agencyManagement.AgenciesList.add(
            agencyManagement.fromJson(doc.data() as Map<String, dynamic>));
      });
    });
  }

  updateAgencyName(name) async {
    await Agency.doc(uid).update({'name': name});
  }

  updateAgencyPhoneNum(phoneNum) {
    Agency.doc(uid).update({'phoneNum': phoneNum});
  }

  updateAgencyAbout(about) {
    Agency.doc(uid).update({'about': about});
  }
  updateAgencyLocation(GeoPoint location) {
    Agency.doc(uid).update({'location': location});
  }

  updateAgencyPhotoUrl(photoUrl) {
    Agency.doc(uid).update({'photoUrl': photoUrl});
  }

  updateAgencySales(){
    Agency.doc(uid).update({'sales': FieldValue.increment(1)});
  }

  Future<bool> isAgency() async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('Agencies');

      var doc = await collectionRef.doc(uid).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }
}

class agencyProvider extends ChangeNotifier {
  String name = 'DummyName';
  String email = 'DummyEmail@DummyEmail.com';
  String phoneNum = '00000000000';
  GeoPoint location = GeoPoint(0, 0);
  String about = 'About you';
  String photoUrl = 'https://flyclipart.com/thumb2/person-icon-137546.png';
  void setAgencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await agencyManagement.getAgencies();
    });

    notifyListeners();
  }

  List<Agency1> getAgencyList() {
    return agencyManagement.AgenciesList;
  }

  Future<String>? getName(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Agencies').doc(user.uid);
    await document.get().then((document) {
      print(document['name']);
      name = document['name'];
      notifyListeners();
    });
    return name;
  }

  Future<String>? getAgencyNameUsinguid(var uid) async {
    var document =
    await FirebaseFirestore.instance.collection('Agencies').doc(uid);
    await document.get().then((document) {
      print(document['name']);
      name = document['name'];
      notifyListeners();
    });
    return name;
  }

  Future<String>? getEmail(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Agencies').doc(user.uid);
    await document.get().then((document) {
      print(document['email']);
      email = document['email'];
      notifyListeners();
    });
    return email;
  }

  Future<String>? getPhoneNum(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Agencies').doc(user.uid);
    await document.get().then((document) {
      print(document['phoneNum']);
      phoneNum = document['phoneNum'];
      notifyListeners();
    });
    return phoneNum;
  }

  Future<String>? getPhoneNumber(var userid) async {
    var document =
        await FirebaseFirestore.instance.collection('Agencies').doc(userid);
    await document.get().then((document) {
      print(document['phoneNum']);
      phoneNum = document['phoneNum'];
      notifyListeners();
    });
    return phoneNum;
  }

  Future<String>? getAbout(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Agencies').doc(user.uid);
    await document.get().then((document) {
      print(document['about']);
      about = document['about'];
      notifyListeners();
    });
    return about;
  }
  Future<GeoPoint> getLocation(var user) async {
    var document =
    FirebaseFirestore.instance.collection('Agencies').doc(user.uid);
    await document.get().then((document) {
      print(document['location']);
      location = document['location'];
      notifyListeners();
    });
    return location;
  }
  Future<GeoPoint> getLocationUsinguid(var uid) async {
    var document =
    FirebaseFirestore.instance.collection('Agencies').doc(uid);
    await document.get().then((document) {
      print(document['location']);
      location = document['location'];
      notifyListeners();
    });
    return location;
  }

  Future<String>? getPhotoUrl(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Agencies').doc(user.uid);
    await document.get().then((document) {
      print(document['photoUrl']);
      photoUrl = document['photoUrl'];
      notifyListeners();
    });
    return photoUrl;
  }

  Future<String>? getPhotoUrlUsinguid(var uid) async {
    var document =
    await FirebaseFirestore.instance.collection('Agencies').doc(uid);
    await document.get().then((document) {
      print(document['photoUrl']);
      photoUrl = document['photoUrl'];
      notifyListeners();
    });
    return photoUrl;
  }

}
