import 'package:aaha/Pkg_details_Ag.dart';
import 'package:provider/provider.dart';
import 'editPackage.dart';
import 'Agency.dart';
import 'package:flutter/material.dart';
import 'services/packageManagement.dart';
import 'Widgets/agencyPackagesTopView.dart';

class AgHomeAgView extends StatefulWidget {
  final agencyID;
  const AgHomeAgView({Key? key, required this.agencyID}) : super(key: key);

  @override
  _AgHomeAgViewState createState() => _AgHomeAgViewState();
}

class _AgHomeAgViewState extends State<AgHomeAgView> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                topView(agencyID: widget.agencyID, agencyView: true),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          context.read<packageProvider>().getList().length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (Context) =>
                                  PkgDetailAgency(pack: PackageList[index]),
                            ));
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Card(
                                  elevation: 40,
                                  child: Container(
                                    width: 345,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              context
                                                      .read<packageProvider>()
                                                      .getList()[index]
                                                      .PName +
                                                  '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Days:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('\b' +
                                                context
                                                    .read<packageProvider>()
                                                    .getList()[index]
                                                    .Days +
                                                ''),
                                            Text(
                                              'Price:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('\$' +
                                                context
                                                    .read<packageProvider>()
                                                    .getList()[index]
                                                    .Price +
                                                ''),
                                            Text(
                                              'Description:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(context
                                                        .read<packageProvider>()
                                                        .getList()[index]
                                                        .Desc +
                                                    '')),
                                          ],
                                        ),
                                        Column(children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                      builder: (Context) => editPackage(
                                                          package: context
                                                              .read<
                                                                  packageProvider>()
                                                              .getList()[index]),
                                                    ))
                                                    .then((value) =>
                                                        setState(() {}));
                                              },
                                              child: Icon(Icons.edit)),
                                          TextButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext ctx) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Please Confirm'),
                                                        content: const Text(
                                                            'Are you sure to remove the package?'),
                                                        actions: [
                                                          // The "Yes" button
                                                          TextButton(
                                                              onPressed: () {
                                                                setState(() {});
                                                                context
                                                                    .read<
                                                                        packageProvider>()
                                                                    .RemovePackage(
                                                                        PackageList[
                                                                            index]);

                                                                // Close the dialog

                                                                Navigator.of(
                                                                        ctx)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'Yes')),
                                                          TextButton(
                                                              onPressed: () {
                                                                // Close the dialog
                                                                Navigator.of(
                                                                        ctx)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'No'))
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              )),
                                        ])
                                      ]),
                                    ),
                                  ),
                                ),
                              ]),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
