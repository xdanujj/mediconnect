import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;

  const ProfileScreen({Key? key, required this.name, required this.email}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Color(0xFF1B3A57),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Color(0xFF1B3A57),
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 60, color: Colors.grey[400]),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                widget.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                widget.email,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 30),

            _buildSettingsItem(Icons.edit, "Edit Profile", () {}),
            _buildDarkModeToggle(),
            _buildSettingsItem(Icons.language, "Language", () {}),
            _buildSettingsItem(Icons.info_outline, "About", () {}),
            _buildSettingsItem(Icons.assignment, "Terms & Conditions", () {}),
            _buildSettingsItem(Icons.lock_outline, "Privacy Policy", () {}),
            _buildSettingsItem(Icons.star_border, "Rate This App", () {}),
            _buildSettingsItem(Icons.share, "Share This App", () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
          onTap: onTap,
        ),
        Divider(color: Colors.white30, height: 1),
      ],
    );
  }

  Widget _buildDarkModeToggle() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.dark_mode, color: Colors.white),
          title: const Text('Mode Dark & Light', style: TextStyle(color: Colors.white, fontSize: 16)),
          trailing: Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
            activeColor: Colors.yellow,
          ),
        ),
        Divider(color: Colors.white30, height: 1),
      ],
    );
  }
}