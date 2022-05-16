import 'package:advance_notification/advance_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/travellerManagement.dart';
import 'Widgets/userData.dart';
import 'Widgets/ProfilePictureWidget.dart';
import 'Widgets/updateDialog.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({Key? key}) : super(key: key);

  @override
  _ProfileAgencyState1 createState() => _ProfileAgencyState1();
}

class _ProfileAgencyState1 extends State<EditUserProfile> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    ProfilePictureWidget(
                        future: context
                            .read<travellerProvider>()
                            .getPhotoUrl(currentUser)),
                    Column(
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: Text('View Profile Picture')),
                        TextButton(
                            onPressed: () async {
                              var newPhotoUrl =
                                  await updateDialog(context, 'photo url');
                              var travellerManagementObject =
                                  travellerManagement(uid: currentUser!.uid);
                              if (newPhotoUrl != null) {
                                setState(() {
                                  travellerManagementObject
                                      .updateTravellerPhotoUrl(newPhotoUrl);
                                });
                                AdvanceSnackBar(
                                  message: "Updated Successfully",
                                  mode: Mode.ADVANCE,
                                  duration: Duration(seconds: 5),).show(context);
                              }
                            },
                            child: Text('Change Profile Picture')),
                      ],
                    ),
                  ],
                ),
                Text('\n'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // - - - Name - - -
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.person_outline_outlined),
                          userData(
                              future: context
                                  .read<travellerProvider>()
                                  .getName(currentUser)),
                          InkWell(
                            child: Icon(Icons.edit),
                            onTap: () async {
                              var newName = await updateDialog(context, 'name');
                              var travellerManagementObject =
                                  travellerManagement(uid: currentUser!.uid);
                              if (newName != null) {
                                setState(() {
                                  travellerManagementObject
                                      .updateTravellerName(newName);
                                });
                                AdvanceSnackBar(
                                  message: "Updated Successfully",
                                  mode: Mode.ADVANCE,
                                  duration: Duration(seconds: 5),).show(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // - - - Email - - -
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.email_outlined),
                          userData(
                              future: context
                                  .read<travellerProvider>()
                                  .getEmail(currentUser)),
                          const Icon(Icons.key),
                        ],
                      ),
                    ),
                    // - - - Phone Number - - -
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.phone_outlined),
                          userData(
                              future: context
                                  .read<travellerProvider>()
                                  .getPhoneNum(currentUser)),
                          InkWell(
                            child: Icon(Icons.edit),
                            onTap: () async {
                              var newPhoneNum =
                                  await updateDialog(context, 'phone number');
                              var travellerManagementObject =
                                  travellerManagement(uid: currentUser!.uid);
                              if (newPhoneNum != null) {
                                setState(() {
                                  travellerManagementObject
                                      .updateTravellerPhoneNum(newPhoneNum);
                                });
                                AdvanceSnackBar(
                                  message: "Updated Successfully",
                                  mode: Mode.ADVANCE,
                                  duration: Duration(seconds: 5),).show(context);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    // - - - About - - -
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.account_circle_outlined),
                          Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.72,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: userData(
                                  future: context
                                      .read<travellerProvider>()
                                      .getAbout(currentUser)),
                            ),
                          ),
                          InkWell(
                            child: Icon(Icons.edit),
                            onTap: () async {
                              var newAbout =
                                  await updateDialog(context, 'about');
                              var travellerManagementObject =
                                  travellerManagement(uid: currentUser!.uid);
                              if (newAbout != null) {
                                setState(() {
                                  travellerManagementObject
                                      .updateTravellerAbout(newAbout);
                                });
                                AdvanceSnackBar(
                                  message: "Updated Successfully",
                                  mode: Mode.ADVANCE,
                                  duration: Duration(seconds: 5),).show(context);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: InkWell(
                          onTap: () async {
                            var newCity = await updateDialog(context, 'city');
                            travellerManagement(uid: currentUser!.uid)
                                .updateTravellerCity(newCity);
                            AdvanceSnackBar(
                              message: "Updated Successfully",
                              mode: Mode.ADVANCE,
                              duration: Duration(seconds: 5),).show(context);
                          },
                          child: Padding(padding: EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(Icons.location_on_outlined),
                              Text(
                                'Update your current city',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25),
                              ),
                            ],
                          ),)
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePictureScreen extends StatelessWidget {
  final String photoUrl;
  const ProfilePictureScreen({Key? key, required this.photoUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              photoUrl,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
