import 'package:flutter/material.dart';
import 'package:mediconnect/signup.dart';
import 'package:mediconnect/userchoice.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Dark Blue Header with Curved Bottom-Right
            Expanded(
              flex: 3, // Takes 3 parts of available space
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1C2B4B), // Dark Blue
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100), // Curved corner
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Medi-Connect",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Login Form Section
            Expanded(
              flex: 5, // Takes 5 parts of available space
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C2B4B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildTextField("NAME", "Enter Your Name"),
                    buildTextField("PASSWORD", "******", isPassword: true),

                    const SizedBox(height: 20),

                    // Log In Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C2B4B),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserChoicePage()),
                        );
                      },
                      child: const Text("Log In", style: TextStyle(color: Colors.white)),
                    ),

                    const SizedBox(height: 10),

                    // Signup Link
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: const Text("Don't have an account? Signup here"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Text Field Widget
  Widget buildTextField(String label, String hint, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
