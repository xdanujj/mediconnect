import 'package:flutter/material.dart';
import 'package:mediconnect/loginpage.dart';
import 'package:mediconnect/signup.dart';
import 'package:mediconnect/userchoice.dart';
import 'package:mediconnect/appointment.dart';
import 'package:mediconnect/sidemenu.dart';

import 'AppointmentPageWithDrawer.dart'; // Import the SideMenu

void main() {
  runApp(const MediConnectApp());
}

class MediConnectApp extends StatelessWidget {
  const MediConnectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediConnect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/Login', // Initial screen
      routes: {
        '/Login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/userchoice': (context) => UserChoicePage(),
        '/appointment': (context) => AppointmentPageWithDrawer() // Use the updated page
      },
    );
  }
}
