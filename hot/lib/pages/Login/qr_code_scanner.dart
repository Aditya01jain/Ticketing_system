import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:firebase_database/firebase_database.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  String? uniqueId;
  bool emailExists = false;
  bool loading = false;
  final qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;
  bool flashStatus = false;
  bool cameraStatus = false;
  Barcode? barcode;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  String extractRegistrationNumber(String? text) {
    RegExp regExp = RegExp(r'Registration Number : (\w+)', caseSensitive: false);
    Match? match = regExp.firstMatch(text!);

    if (match != null) {
      String registrationNumber = match.group(1)!;
      return registrationNumber;
    } else {
      return "Registration number not found";
    }
  }

   Future<void> checkId() async {
    final DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference();

    DataSnapshot dataSnapshot;

    try {
      final event = await databaseReference.once();
      dataSnapshot = event.snapshot;
    } catch (error) {
      print("Error loading data: $error");
      return;
    }

    bool emailExistsInData = false;
    if (dataSnapshot.value is List) {
      final List<dynamic> dataList = dataSnapshot.value as List<dynamic>;

      for (var item in dataList) {
        if (item is Map<dynamic, dynamic> &&
            item['Registration Number'] == uniqueId) {
          emailExistsInData = true;
          item['Status'] = "Present";
          await databaseReference.set(dataSnapshot.value);
          break;
        }
      }
    }

    setState(() {
      emailExists = emailExistsInData;
      loading = false; // Set loading to false when done
    });

    if (emailExistsInData) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Ticket"),
            content: Text("$uniqueId Mark present"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Email Check Result"),
            content: Text("$uniqueId does not exist in the database."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(173, 69, 49, 255),
        title: Text('Scanner'),
        actions: [
          IconButton(
            onPressed: () async {
              await controller!.flipCamera();
              setState(() {
                cameraStatus = !cameraStatus;
              });
            },
            icon: Icon(Icons.flip_camera_ios_outlined),
          ),
          IconButton(
            onPressed: () async {
              await controller!.toggleFlash();
              setState(() {
                flashStatus = !flashStatus;
              });
            },
            icon: flashStatus ? Icon(Icons.flash_on) : Icon(Icons.flash_off),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: onQRViewCreated,
            overlay: QrScannerOverlayShape(
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
              borderRadius: 12,
              borderColor: Color.fromARGB(255, 98, 185, 255),
              borderLength: 22,
              borderWidth: 8,
            ),
          ),
          if (loading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(173, 69, 49, 255),
        onPressed: () {
          _showDetailsPopup(context);
        },
        child: Icon(Icons.camera_alt, size: 40,color: Colors.white,),
      ),
    );
  }

  void onQRViewCreated(QRViewController _controller) {
    setState(() {
      controller = _controller;
    });

    controller!.scannedDataStream.listen((_barcode) {
      setState(() {
        barcode = _barcode;
      });
    });
  }

  void _showDetailsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('QR Code Details'),
          content: Text(barcode != null ? barcode!.code ?? "" : ""),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (barcode != null) {
                  String data = extractRegistrationNumber(barcode!.code);
                  uniqueId = data;
                  loading = true;
                  checkId();
                }
                barcode = null;
                Navigator.of(context).pop();
              },
              child: Text("Verify"),
            ),
            TextButton(
              onPressed: () {
                barcode = null;
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
