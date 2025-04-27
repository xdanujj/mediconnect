import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B355A),
        title: const Text(
          'Help',
          style: TextStyle(fontSize: 24), // Increased font size here
        ),
        centerTitle: true,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white), // This changes the back arrow to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(Icons.help_outline, size: 80, color: Color(0xFF1B355A)),
              ),
              const SizedBox(height: 20),
              const Text(
                'How to Use MediConnect',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B355A),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '1.Create an Account: Start by signing up with your email or Google account to access personalized services.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              const Text(
                '2.Manage Prescriptions: View, create, and share prescriptions directly with your healthcare provider.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              const Text(
                '3.Book Appointments: Schedule medical appointments with ease and receive reminders for upcoming visits.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              const Text(
                '4.Access Health Articles: Stay informed with curated articles on various health topics available within the app.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'Frequently Asked Questions (FAQ)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B355A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Q: How do I reset my password?\n\nA: You can reset your password from the login page by clicking "Forgot Password." An email will be sent to you with instructions.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              const Text(
                'Q: How can I contact customer support?\n\nA: You can reach customer support via email at akshatshahd.com.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              const Text(
                'Q: What if I encounter a technical issue while using the app?\n\nA: You can report any technical issues directly through the "Contact Us" section in the app settings.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              const Text(
                'Q: Is my personal data secure in MediConnect?\n\nA: Yes, we prioritize user privacy and employ strict encryption and security protocols to protect your data.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}