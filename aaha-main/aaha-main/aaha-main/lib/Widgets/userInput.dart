import 'package:flutter/material.dart';

Widget userInput(String hintTitle, TextInputType keyboardType, controller,
    obscureText, maxLength) {
  return Container(
    margin: EdgeInsets.only(bottom: 15),
    decoration: BoxDecoration(
        // color: Colors.blueGrey.shade200,
        borderRadius: BorderRadius.circular(30)),
    child: Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25),
      child: TextField(
        maxLength: maxLength,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          counterText: '',
          hintText: hintTitle,
          hintStyle: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
        ),
        keyboardType: keyboardType,
      ),
    ),
  );
}
