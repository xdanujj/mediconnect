import 'package:flutter/material.dart';
import 'package:mediconnect/supabaseservices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final SupabaseService supabaseService = SupabaseService();
  String displayName = "Loading...";
  String email = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // ✅ Fetch User Data from Profiles Table
  Future<void> fetchUserData() async {
    final user = supabaseService.getCurrentUser();
    if (user != null) {
      try {
        // Fetch profile details from the 'profiles' table
        final userDetails = await Supabase.instance.client
            .from('profiles')
            .select('name, email')
            .eq('id', user.id)
            .maybeSingle();

        if (userDetails != null) {
          setState(() {
            displayName = userDetails['name'] ?? 'User';
            email = userDetails['email'] ?? 'No Email';
          });
        } else {
          setState(() {
            displayName = "Profile Not Found";
            email = "Not available";
          });
        }
      } catch (e) {
        setState(() {
          displayName = "Error loading profile";
          email = "Error: $e";
        });
      }
    } else {
      setState(() {
        displayName = "Guest";
        email = "Not available";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
      ),
      child: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(displayName),
              accountEmail: Text(email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF1C2B4B), size: 40),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF1C2B4B),
              ),
            ),
            buildMenuItem(Icons.calendar_today, 'Your Appointments', () {}),
            buildMenuItem(Icons.article_outlined, 'Health Articles', () {}),
            buildMenuItem(Icons.receipt_long, 'Prescriptions', () {}),
            buildMenuItem(Icons.help_outline, 'Help', () {}),
            buildMenuItem(Icons.person_outline, 'Profile', () {}),
            buildMenuItem(Icons.info_outline, 'About Us', () {}),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await supabaseService.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged Out Successfully')),
                );
                Navigator.pushReplacementNamed(context, '/login');
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
