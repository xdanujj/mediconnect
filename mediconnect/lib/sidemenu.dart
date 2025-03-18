import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
      ),
      child: Drawer(
        backgroundColor: Colors.white, // Set Sidebar Background to White
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header with User's Name
            UserAccountsDrawerHeader(
              accountName: const Text("Akshat Shah"),
              accountEmail: const Text("akshatshah@gmail.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF1C2B4B), size: 40),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF1C2B4B), // Keep Header Dark Blue
              ),
            ),

            // Menu Items
            buildMenuItem(Icons.calendar_today, 'Your Appointments', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigating to Appointments')),
              );
            }),
            buildMenuItem(Icons.article_outlined, 'Health Articles', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigating to Health Articles')),
              );
            }),
            buildMenuItem(Icons.receipt_long, 'Prescriptions', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigating to Prescriptions')),
              );
            }),
            buildMenuItem(Icons.help_outline, 'Help', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigating to Help')),
              );
            }),
            buildMenuItem(Icons.person_outline, 'Profile', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigating to Profile')),
              );
            }),
            buildMenuItem(Icons.info_outline, 'About Us', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigating to About Us')),
              );
            }),

            const Divider(),

            // Logout Option
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logging Out')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1C2B4B)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}
