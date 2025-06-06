import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mediconnect/supabaseservices.dart';
import 'package:mediconnect/loginpage.dart';
import 'package:mediconnect/signup.dart';
import 'package:mediconnect/userchoice.dart';
import 'package:mediconnect/appointmentpagewithdrawer.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mediconnect/ChatProvider.dart';

// WelcomeScreen file (we'll create it next)
import 'package:mediconnect/welcomescreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uuevolmdxgnnaofgjiqd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV1ZXZvbG1keGdubmFvZmdqaXFkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzMTEwMjYsImV4cCI6MjA1Nzg4NzAyNn0.VBQvFIeeQjknfQmPDgkjesMf-2Jx8ulzGqLn7qnsUFs',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const MediConnectApp(),
    ),
  );
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
      home: WelcomeScreen(), // <-- Starting with WelcomeScreen now
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/userchoice': (context) => UserChoicePage(),
        '/appointment': (context) => AppointmentPageWithDrawer(),
      },
    );
  }
}

// This will handle checking if user is logged in or not
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final session = snapshot.data!.session;
          if (session != null) {
            return UserChoicePage();
          } else {
            return LoginScreen();
          }
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
