import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importing the Clipboard package
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B355A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(Icons.medical_services, size: 80, color: Color(0xFF1B355A)),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'MediConnect',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B355A),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'MediConnect is your trusted healthcare companion. '
                    'Our app simplifies the way patients and doctors manage prescriptions, appointments, and medical records. '
                    'Designed for easy access and a seamless experience, MediConnect ensures your health information is always available at your fingertips.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B355A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'To bridge the gap between patients and healthcare providers by offering a simple, secure, and efficient platform.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B355A),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final emailUrl = Uri.parse('mailto:akshatshahd@gmail.com');
                  if (await canLaunch(emailUrl.toString())) {
                    await launch(emailUrl.toString());
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.email, color: Color(0xFF1B355A)),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: 'akshatshahd@gmail.com'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email copied to clipboard!')),
                        );
                      },
                      child: Text(
                        'akshatshahd@gmail.com',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                          decoration: TextDecoration.underline, // Underline added
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final phoneUrl = Uri.parse('tel:+917666526447');
                  if (await canLaunch(phoneUrl.toString())) {
                    await launch(phoneUrl.toString());
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.phone, color: Color(0xFF1B355A)),
                    const SizedBox(width: 8),
                    Text(
                      '+91 7666526447',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                        decoration: TextDecoration.underline, // Underline added
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}