import 'package:flutter/material.dart';
import 'package:mediconnect/signup.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dark Blue Header with Curved Bottom-Right
            Stack(
              children: [
                Container(
                  height: 220, // Adjusted to match your image
                  decoration: BoxDecoration(
                    color: Color(0xFF1C2B4B), // Dark Blue
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(100), // Curved corner
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 20,
                  child: Text(
                    "Medi-Connect",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Login Form Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C2B4B), // Matching Dark Blue Color
                    ),
                  ),
                  SizedBox(height: 20),
                  buildTextField("NAME", "Enter Your Name"),
                  buildTextField("PASSWORD", "******", isPassword: true),

                  SizedBox(height: 20),

                  // Log In Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1C2B4B), // Dark Blue Button
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      // Handle Login Action
                    },
                    child: Text("Log In", style: TextStyle(color: Colors.white)),
                  ),

                  SizedBox(height: 10),

                  // Forgot Password & Signup Links
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen()), // Navigate to Signup page
                          );
                        },
                        child: Text("Don't have an account? Signup here"),
                      ),
                    ],
                  )

                ],
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
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
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
