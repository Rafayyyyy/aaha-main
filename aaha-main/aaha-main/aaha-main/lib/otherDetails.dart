import 'package:flutter/material.dart';
import 'addPackage.dart';

class otherDetails extends StatefulWidget {
  const otherDetails({Key? key}) : super(key: key);

  @override
  State<otherDetails> createState() => _otherDetailsState();
}
bool isSaved=false;
List<String> otherDetailsList = [];
 var textFields = <TextField>[];

class _otherDetailsState extends State<otherDetails> {
  @override
  var textEditingControllers = <TextEditingController>[];


  // stringListReturnedFromApiCall.forEach((str) {
  //   var textEditingController = new TextEditingController(text: str);
  //   textEditingControllers.add(textEditingController);
  //   return textFields.add(new TextField(controller: textEditingController));
  // });
  initState() {
    int j = (int.parse(daysController.text));
    for (int i = 0; i < j; i++) {
      print((int.parse(daysController.text)));
      var textEditingController = new TextEditingController();
      textEditingControllers.add(textEditingController);
      textFields.add(new TextField(controller: textEditingController));
    }
  }
  // This list of controllers can be used to set and get the text from/to the TextFields

  @override
  Widget build(BuildContext context) {
    var stringListReturnedFromApiCall = [
      "first",
      "second",
      "third",
      "fourth",
      "..."
    ];

    return Scaffold(
        body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: new Column(
                children: [
                  // textFields,
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: textFields.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text('Day ' + (index + 1).toString()),
                          ),
                          textFields[index],
                        ],
                      );
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: RaisedButton(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: Colors.indigo.shade500,
                      onPressed: () {
                        for (int i = 0; i < textFields.length; i++) {
                          if (textFields[i].controller!.text.length > 0) {
                            otherDetailsList
                                .add(textFields[i].controller!.text);
                          } else {
                            otherDetailsList.add('no detail added');
                          }
                        }
                        isSaved=true;
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
