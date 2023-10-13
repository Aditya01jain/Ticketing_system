import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MyData {
  String registrationNumber;
  String status;
  String name;

  MyData(this.registrationNumber, this.status, this.name);
}

class FirebaseDataScreen extends StatefulWidget {
  @override
  _FirebaseDataScreenState createState() => _FirebaseDataScreenState();
}

class _FirebaseDataScreenState extends State<FirebaseDataScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();

  List<MyData> dataList = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  void fetchDataFromFirebase() {
  databaseReference.once().then((DatabaseEvent event) {
    final values = event.snapshot.value;
    dataList.clear();
    if (values is Map<String, dynamic>) { // Check if values is a map
      values.forEach((key, value) {
        if (value['Status'] == 'present') {
          MyData data = MyData(
              value['Registration Number'], value['Status'], value['Name']);
          dataList.add(data);
        }
      });

      setState(() {}); // Refresh the UI
    }
  }).catchError((error) {
    print("Error fetching data from Firebase: $error");
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Data List'),
      ),
      body: dataList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Name: ${dataList[index].name}'),
                  subtitle:
                      Text('Registration Number: ${dataList[index].registrationNumber}'),
                );
              },
            ),
    );
  }
}
