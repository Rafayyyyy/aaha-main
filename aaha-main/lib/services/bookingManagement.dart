import 'package:aaha/bookingHistoryHistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
List<String> urls=[];
class bookingManagement {
  CollectionReference Bookings =
      FirebaseFirestore.instance.collection('Bookings');

  storeNewBooking(travellerID, agencyID, packageID, travelEndDate, packageName,
      packageNumOfDays, packageDescription, travellerName, packagePrice,agencyName,hasRated,location,BookingImagesUrls) {
    Bookings.add({
      'travellerID': travellerID,
      'agencyID': agencyID,
      'packageID': packageID,
      'travelEndDate': travelEndDate,
      'packageName': packageName,
      'packageNumOfDays': packageNumOfDays,
      'packageDescription': packageDescription,
      'travellerName': travellerName,
      'packagePrice': packagePrice,
      'agencyName':agencyName,
      'hasRated':hasRated,
      'location' : location,
      'ImgUrls': [],
      'BookingImagesUrls':BookingImagesUrls
    });
  }

  storeReview(bookingID, review){
    Bookings.doc(bookingID).set({'ratingReview':review },SetOptions(merge: true));
  }
  getBookingsForAgency(agencyID) {
    Bookings.where('agencyID', isEqualTo: agencyID).get();
  }
  updateHasRated(bookingID) {
    Bookings.doc(bookingID).update({'hasRated': true});
  }
  updateBookingImages(bookingID,BookingImagesUrlsList){

    Bookings.doc(bookingID).update({'BookingImagesUrls':BookingImagesUrlsList});
  }
}
