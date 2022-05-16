import 'package:flutter/material.dart';
class allButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const allButton({Key? key, required this.buttonText, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 45,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.indigo.shade800,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: Colors.blueGrey)))),
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}