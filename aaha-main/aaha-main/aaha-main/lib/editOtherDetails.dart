import 'package:flutter/material.dart';
import 'Agency.dart';
import 'addPackage.dart';
class editotherDetails extends StatefulWidget {
  final Package1 p;
  const editotherDetails({Key? key, required this.p}) : super(key: key);

  @override
  State<editotherDetails> createState() => _editotherDetailsState();
}
List<String> otherDetailsList=[];
class _editotherDetailsState extends State<editotherDetails> {
  @override
  var textEditingControllers = <TextEditingController>[];

  var textFields = <TextField>[];
  initState(){

    int j=(int.parse(widget.p.Days));
    for(int i=0;i<j;i++){
      print(
          (int.parse(widget.p.Days)
          ));
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
              child: Column(
                children:[
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

                            title: Text('Day '+ (index+1).toString()),

                          ),
                          textFields[index],
                        ],
                      );

                    },
                  ),
                  Container(
                    width:MediaQuery.of(context).size.width * 0.9,
                    child: RaisedButton(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: Colors.indigo.shade500,
                      onPressed: () {
                        for(int i=0;i<textFields.length;i++){
                          if(textFields[i].controller!.text.length>0) {
                            otherDetailsList.add(
                                textFields[i].controller!.text);
                          }else{
                            otherDetailsList.add(
                                'no detail added');
                          }
                        }
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ] ,
              ),
            )));
  }
}