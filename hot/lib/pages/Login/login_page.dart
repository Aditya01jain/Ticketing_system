import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_database/firebase_database.dart'; // Add this import
import 'package:flutter_login_signup/consts.dart';
import 'package:flutter_login_signup/pages/Login/qr_code_generator.dart';
import 'package:flutter_login_signup/pages/Login/sign_page.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final TextEditingController _emailController = TextEditingController();
  bool emailExists = false;
   late String registrationNumber; // Declare these variables here
  late String uniqueId;
  

Future<void> checkEmail() async {
  final String emailToCheck = _emailController.text.trim();
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  DataSnapshot? dataSnapshot;

  try {
    final event = await databaseReference.once();
    dataSnapshot = event.snapshot;
  } catch (error) {
    print("Error loading data: $error");
  }

  bool emailExistsInData = false;
  String? registrationNumber;
  String? uniqueId;

  if (dataSnapshot != null) {
    if (dataSnapshot.value is List) {
      final List<dynamic> dataList = dataSnapshot.value as List<dynamic>;

      for (var item in dataList) {
        if (item is Map<dynamic, dynamic> && item['Email Address'] == emailToCheck) {
          emailExistsInData = true;
          registrationNumber = item['Registration Number'];
          uniqueId = item['Unique id'];
          break;
        }
      }
    }
  }

  setState(() {
    emailExists = emailExistsInData;
  });

  if (emailExistsInData) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QRCodeGenerator(
          userEmail: emailToCheck,
          registrationNumber: registrationNumber ?? "", // Use a default value if null
          uniqueId: uniqueId ?? "", // Use a default value if null
        ),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Email Check Result"),
          content: Text("Email does not exist in the database."),
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [g1, g2],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.030),
            
            child: Column(
              children: [
                SizedBox(height: size.height * 0.024),
                 SizedBox(height: size.height * 0.024),
                  SizedBox(height: size.height * 0.024),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    image1,
                    // Other image properties like width, height, etc.
                  ),
                ),
                SizedBox(height: size.height * 0.024),
                Text(
                  "Welcome !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: kWhiteColor.withOpacity(0.7),
                  ),
                ),
                Text(
                  "Please, Log In",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    color: kWhiteColor,
                  ),
                ),
                SizedBox(height: size.height * 0.024),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: kInputColor),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 25.0),
                    filled: true,
                    hintText: "Email",
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(userIcon),
                    ),
                    fillColor: kWhiteColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(37),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.024),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: size.height * 0.080,
                    decoration: BoxDecoration(
                      color: kButtonColor,
                      borderRadius: BorderRadius.circular(37),
                    ),
                    child: Text(
                      "Get your QR",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onPressed: () {
                    checkEmail(); // Call the checkEmail function when the button is pressed.
                  },
                ),
                 SizedBox(height: size.height * 0.014),
                SvgPicture.asset("assets/icons/deisgn.svg"),
                SizedBox(height: size.height * 0.014),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: size.height * 0.080,
                    decoration:  BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 45,
                          spreadRadius: 0,
                          color: Color.fromRGBO(120, 37, 139, 0.25),
                          offset: Offset(0, 25),
                        )
                      ],
                      borderRadius: BorderRadius.circular(37),
                      color: const Color.fromRGBO(225, 225, 225, 0.28),
                    ),
                    child: const Text(
                      "Team",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignPage()),);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
