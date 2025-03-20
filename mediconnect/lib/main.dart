import 'package:flutter/material.dart';
import 'package:mediconnect/supabaseservices.dart';
import 'package:mediconnect/loginpage.dart';
import 'package:mediconnect/signup.dart';
import 'package:mediconnect/userchoice.dart';
import 'package:mediconnect/appointmentpagewithdrawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uuevolmdxgnnaofgjiqd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV1ZXZvbG1keGdubmFvZmdqaXFkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzMTEwMjYsImV4cCI6MjA1Nzg4NzAyNn0.VBQvFIeeQjknfQmPDgkjesMf-2Jx8ulzGqLn7qnsUFs',
  );

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/userchoice': (context) => UserChoicePage(),
        '/appointment': (context) => AppointmentPageWithDrawer(),
      },
    );
  }
}


 /*
import 'package:flutter/material.dart';

import 'AppointmentScreen.dart';

void main() {
  runApp(MaterialApp(home: AppointmentScreen()));
}

  */