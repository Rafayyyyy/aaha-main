import 'package:aaha/services/agencyManagement.dart';
import 'package:aaha/services/travellerManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'Widgets/userInput.dart';
import 'services/bookingManagement.dart';
import 'package:flutter/material.dart';
import 'Agency.dart';
import 'services/packageManagement.dart';
import 'Widgets/allButton.dart';
import 'Widgets/showAlertDialog.dart';
import 'package:cool_alert/cool_alert.dart';

class paymentInvoice extends StatefulWidget {
  final Package1 package;
  const paymentInvoice({Key? key, required this.package}) : super(key: key);

  @override
  State<paymentInvoice> createState() => _paymentInvoiceState();
}

DateTime date = DateTime.now();
DateTime travelEndDate = DateTime.now();
DateTime? travelStartDate = DateTime.now();
String startDate = '';
String endDate = '';
TextEditingController _nameOnCard = TextEditingController();
TextEditingController _cardNumber = TextEditingController();
TextEditingController _expiryDate = TextEditingController();
TextEditingController _securityCode = TextEditingController();
TextEditingController _zip = TextEditingController();

class _paymentInvoiceState extends State<paymentInvoice> {
  @override
  void initState() {
    startDate = 'Select Date';
    endDate = '';
    travelEndDate = DateTime.now();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Payment Invoice',
          style: (TextStyle(color: Colors.black, fontSize: 30)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Text(
                'Schedule:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            selectSchedule(package: widget.package),
            Center(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                              child: Image.network(
                                  'https://res.cloudinary.com/okay-rent-a-car/images/v1617474656/content/images/payment-method-no-credit-card-needed/payment-method-no-credit-card-needed.webp')),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: const Text(
                                  'Payment Amount ',
                                  style: TextStyle(fontSize: 24),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Text(
                                  '\$' + widget.package.Price,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    // fontWeight: FontWeight.bold,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 3.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              userInput('Name on card', TextInputType.text,
                                  _nameOnCard, false, 30),
                              userInput('Card Number', TextInputType.number,
                                  _cardNumber, false, 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: userInput(
                                        'Expiry Date',
                                        TextInputType.datetime,
                                        _expiryDate,
                                        false,
                                        5),
                                  ),
                                  Expanded(
                                    child: userInput(
                                        'Security Code',
                                        TextInputType.number,
                                        _securityCode,
                                        true,
                                        3),
                                  ),
                                ],
                              ),
                              userInput('ZIP / Postal code',
                                  TextInputType.number, _zip, false, 5),
                              allButton(
                                  buttonText: 'Pay Now',
                                  onPressed: () async {
                                    if (travelEndDate.day ==
                                        DateTime.now().day && travelEndDate.month == DateTime.now().month) {
                                      showAlertDialog(
                                        context: context,
                                        title: 'A problem has occurred',
                                        content:
                                            'You did not select a start date !',
                                      );
                                    } else {
                                      var currentUserUid = FirebaseAuth
                                          .instance.currentUser!.uid;
                                      var currentUserName = await context
                                          .read<travellerProvider>()
                                          .getName(FirebaseAuth
                                              .instance.currentUser);
                                      bookingManagement().storeNewBooking(
                                          currentUserUid,
                                          widget.package.agencyId,
                                          widget.package.pid,
                                          travelEndDate,
                                          widget.package.PName,
                                          widget.package.Days,
                                          widget.package.Desc,
                                          currentUserName,
                                          widget.package.Price,
                                          widget.package.Aname,
                                          false,
                                          widget.package.Location, []);
                                      packageManagement()
                                          .updateSales(widget.package.pid);
                                      agencyManagement(
                                              uid: widget.package.agencyId)
                                          .updateAgencySales();
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        autoCloseDuration: Duration(seconds: 5),
                                        text: "Your holiday has been booked successfully",
                                      );
                                    }
                                  })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class selectSchedule extends StatefulWidget {
  final Package1 package;
  const selectSchedule({Key? key, required this.package}) : super(key: key);

  @override
  State<selectSchedule> createState() => _selectScheduleState();
}

class _selectScheduleState extends State<selectSchedule> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: IconButton(
              icon: Icon(
                Icons.calendar_today_outlined,
                color: Colors.blueAccent,
              ),
              onPressed: () async {
                travelStartDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2025));
                travelEndDate = travelStartDate!
                    .add(Duration(days: int.parse(widget.package.Days)));
                setState(() {
                  startDate = (travelStartDate!.day.toString() +
                      "/" +
                      travelStartDate!.month.toString() +
                      "/" +
                      travelStartDate!.year.toString());
                  endDate = (travelEndDate!.day.toString() +
                      "/" +
                      travelEndDate!.month.toString() +
                      "/" +
                      travelEndDate!.year.toString());
                });
              },
            )),
        Text(startDate),
        Text(endDate == '' ? '' : ' till '),
        Text(endDate),
      ],
    );
  }
}

