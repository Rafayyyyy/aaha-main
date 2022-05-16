import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aaha/MyBottomBarDemo1.dart';
import 'package:intl/intl.dart';

class travellerManagement {
  final String uid;
  travellerManagement({required this.uid});
  CollectionReference Traveller =
      FirebaseFirestore.instance.collection('Travellers');
  storeNewTraveller(user, name, phoneNum, context) {
    String joinDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    Traveller.doc(uid).set({
      'email': user.email,
      'uid': user.uid,
      'name': name,
      'phoneNum': phoneNum,
      'about': 'About you',
      'photoUrl': 'https://flyclipart.com/thumb2/person-icon-137546.png',
      'coverPhotoUrl':
          'https://images.unsplash.com/photo-1488085061387-422e29b40080?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1331&q=80',
      'joinDate': joinDate,
      'city': 'Karachi'
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MyBottomBarDemo1(),
      ));
    });
  }

  updateTravellerName(name) async {
    await Traveller.doc(uid).update({'name': name});
  }

  updateTravellerPhoneNum(phoneNum) {
    Traveller.doc(uid).update({'phoneNum': phoneNum});
  }

  updateTravellerAbout(about) {
    Traveller.doc(uid).update({'about': about});
  }

  updateTravellerPhotoUrl(photoUrl) {
    Traveller.doc(uid).update({'photoUrl': photoUrl});
  }

  updateTravellerCity(city) {
    Traveller.doc(uid).update({'city': city});
  }

  updateTravellerCoverPhoto(coverPhotoUrl) {
    Traveller.doc(uid).update({'coverPhotoUrl': coverPhotoUrl});
  }

  Future<bool> isTraveller() async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('Travellers');
      var doc = await collectionRef.doc(uid).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }
}

class travellerProvider extends ChangeNotifier {
  String name = 'DummyName';
  String email = 'DummyEmail@DummyEmail.com';
  String phoneNum = '00000000000';
  String about = 'About you';
  String photoUrl = 'https://flyclipart.com/thumb2/person-icon-137546.png';
  String joinDate = '';
  String city = '';
  String coverPhotoUrl = '';

  Future<String>? getName(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Travellers').doc(user.uid);
    await document.get().then((document) {
      print(document['name']);
      name = document['name'];
      notifyListeners();
    });
    return name;
  }

  String getTravellerName(var user) {
    var document =
        FirebaseFirestore.instance.collection('Travellers').doc(user.uid);
    document.get().then((document) {
      print(document['name']);
      name = document['name'];
      notifyListeners();
    });
    return name;
  }

  Future<String>? getEmail(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Travellers').doc(user.uid);
    await document.get().then((document) {
      print(document['email']);
      email = document['email'];
      notifyListeners();
    });
    return email;
  }

  Future<String>? getPhoneNum(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Travellers').doc(user.uid);
    await document.get().then((document) {
      print(document['phoneNum']);
      phoneNum = document['phoneNum'];
      notifyListeners();
    });
    return phoneNum;
  }

  Future<String>? getAbout(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Travellers').doc(user.uid);
    await document.get().then((document) {
      print(document['about']);
      about = document['about'];
      notifyListeners();
    });
    return about;
  }

  Future<String>? getPhotoUrl(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Travellers').doc(user.uid);
    await document.get().then((document) {
      print(document['photoUrl']);
      photoUrl = document['photoUrl'];
      notifyListeners();
    });
    return photoUrl;
  }

  Future<String>? getjoinDate(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Travellers').doc(user.uid);
    await document.get().then((document) {
      print(document['joinDate']);
      joinDate = document['joinDate'];
      notifyListeners();
    });
    return joinDate;
  }

  Future<String>? getCity(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Travellers').doc(user.uid);
    await document.get().then((document) {
      print(document['city']);
      city = document['city'];
      notifyListeners();
    });
    return city;
  }

  Future<String>? getCoverPhotoUrl(var user) async {
    var document =
        await FirebaseFirestore.instance.collection('Travellers').doc(user.uid);
    await document.get().then((document) {
      print(document['coverPhotoUrl']);
      coverPhotoUrl = document['coverPhotoUrl'];
      notifyListeners();
    });
    return coverPhotoUrl;
  }
}
