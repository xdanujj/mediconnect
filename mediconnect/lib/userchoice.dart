import 'package:flutter/material.dart';
import 'package:mediconnect/appointment.dart';
import 'package:mediconnect/appointment.dart'; // Create this page
//import 'package:mediconnect/           .dart'; // Create this page

class UserChoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'Medi-Connect',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionButton(
              context,
              imagePath: 'assets/doctor.jpg',
              title: 'Are You a Doctor?',
              nextPage: AppointmentPage(),
            ),
            const SizedBox(height: 20),
            _buildOptionButton(
              context,
              imagePath: 'assets/user.jpg',
              title: 'Are You a Patient?',
              nextPage: AppointmentPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, {required String imagePath, required String title, required Widget nextPage}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[900], // Button color
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => nextPage),
                  );
                },
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
