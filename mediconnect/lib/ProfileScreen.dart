import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:flutter/services.dart'; // For Clipboard functionality
import 'terms_and_conditions_screen.dart'; // Import the Terms & Conditions screen
import 'privacy_policy_screen.dart'; // Import the Privacy Policy screen
import 'dart:io'; // For File handling

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;

  const ProfileScreen({Key? key, required this.name, required this.email}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage; // To store the selected profile image

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B3A57),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B3A57),
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
            GestureDetector(
              onTap: _pickImage, // Call the image picking function when the avatar is tapped
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!) // Display the selected image
                    : const NetworkImage('https://via.placeholder.com/150'), // Default placeholder image
              ),
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

            _buildSettingsItem(Icons.assignment, "Terms & Conditions", () {
              // Navigate to Terms & Conditions screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen()),
              );
            }),
            _buildSettingsItem(Icons.lock_outline, "Privacy Policy", () {
              // Navigate to Privacy Policy screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
              );
            }),
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
        const Divider(color: Colors.white30, height: 1),
      ],
    );
  }
}