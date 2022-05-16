import 'package:flutter/material.dart';
class userData extends StatelessWidget {
  final Future<String>? future;
  const userData({Key? key, required this.future}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                snapshot.data.toString() == ""
                    ? "Set Up"
                    : snapshot.data.toString(),
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
          );
        }
        return const CircularProgressIndicator(
          color: Colors.blue,
        );
      },
    );
  }
}