import 'package:flutter/material.dart';

updateDialog(context, valueToBeChanged) async {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        var controller = TextEditingController();
        return AlertDialog(
          title: Text('Enter new ' + valueToBeChanged),
          content: TextField(
            controller: controller,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  controller.text != ""
                      ? Navigator.of(context).pop(controller.text)
                      : Navigator.of(context).pop();
                },
                child: const Text('Update')),
          ],
        );
      });
}