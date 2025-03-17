import 'package:flutter/material.dart';
import 'package:mediconnect/loginpage.dart';
import 'package:mediconnect/signup.dart';
import 'package:mediconnect/userchoice.dart';
import 'package:mediconnect/appointment.dart';

void main() {
  runApp(const MediConnectApp());
}

class MediConnectApp extends StatelessWidget {
  const MediConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediConnect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/Login', // Define the initial route
      routes: {
        '/Login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/userchoice': (context) => UserChoicePage(),
        '/appointment': (context) => AppointmentPage(),
      },
    );
  }
}
