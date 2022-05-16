import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  final Future<String>? future;
  const ProfilePictureWidget({Key? key, required this.future})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CircularProfileAvatar(snapshot.data.toString());
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
