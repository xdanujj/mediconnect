import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

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
          'Privacy Policy',
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
              const SizedBox(height: 20),
              const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B355A),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your privacy is important to us. At MediConnect, we are committed to safeguarding your personal data and ensuring that your privacy is protected when you use our app. This privacy policy outlines how we collect, use, and protect your information.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'Information We Collect',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B355A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'We collect personal information that you provide to us directly, such as your name, email address, and phone number. We also collect data related to your use of the app, including usage statistics and device information.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'How We Use Your Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B355A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'We use the information we collect to provide and improve our services, including personalizing your experience, sending notifications, and offering customer support.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'Data Protection',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B355A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'We implement a variety of security measures to maintain the safety of your personal information when you use our services. However, please note that no method of transmission over the internet is 100% secure.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'Sharing Your Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B355A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'We do not sell, trade, or rent your personal information to third parties. We may share your information with trusted third-party service providers who assist us in operating our app and providing services to you, subject to strict confidentiality agreements.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Rights',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B355A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'You have the right to access, update, or delete your personal information at any time. If you wish to exercise these rights or have any concerns about your privacy, please contact us.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'Changes to This Privacy Policy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B355A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'We may update this privacy policy from time to time. Any changes will be posted on this page, and the updated policy will be effective as soon as it is published.',
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