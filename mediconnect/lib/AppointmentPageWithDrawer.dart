import 'package:flutter/material.dart';
import 'appointment.dart';
import 'sidemenu.dart'; // Import the SideMenu

class AppointmentPageWithDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(), // Sidebar added here
      body: AppointmentPage(),
    );
  }
}
