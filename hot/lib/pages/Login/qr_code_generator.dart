import 'package:flutter/material.dart';
import 'package:flutter_login_signup/pages/Login/login_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_widget/ticket_widget.dart';

class QRCodeGenerator extends StatelessWidget {
  final String userEmail;
  final String registrationNumber;
  final String uniqueId;

  const QRCodeGenerator({
    Key? key,
    required this.userEmail,
    required this.registrationNumber,
    required this.uniqueId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 34, 109),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 33, 34, 109),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:50.0),
        child: SingleChildScrollView(
          child: Center(
            child: TicketWidget(
              width: 300,
              height: 500,
              isCornerRounded: true,
              padding: EdgeInsets.all(20),
              child: TicketData(
                userEmail: userEmail,
                registrationNumber: registrationNumber,
                uniqueId: uniqueId,
              ),
            ),
          ),
        ),
      ),
      );
  }
}

class TicketData extends StatelessWidget {
  final String userEmail;
  final String registrationNumber;
  final String uniqueId;

  const TicketData({
    Key? key,
    required this.userEmail,
    required this.registrationNumber,
    required this.uniqueId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120.0,
              height: 25.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: Colors.green),
              ),
              child: Center(
                child: Text(
                  'Health-O-Tech',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Event Ticket',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ticketDetailsWidget(
                  'Registration No', registrationNumber, 'Date', '10-10-2023'),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 53.0),
                child: ticketDetailsWidget('Unique_ID', uniqueId, '', ''),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 70.0, left: 40.0, right: 40.0),
          child: QrImageView(
            data:
                'Email : $userEmail\nRegistration Number : $registrationNumber\nUnique id : $uniqueId',
            version: QrVersions.auto,
            size: 180,
          ),
        ),
      ],
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}
