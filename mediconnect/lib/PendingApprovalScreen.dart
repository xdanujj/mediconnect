import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'doctordashboard.dart';
import 'doctorprofile.dart';
import 'doctorprofile.dart'; // <-- Import your DoctorProfileScreen too

class PendingApprovalScreen extends StatefulWidget {
  @override
  _PendingApprovalScreenState createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends State<PendingApprovalScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCheckingApproval();
  }

  void _startCheckingApproval() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final response = await Supabase.instance.client
          .from('doctors')
          .select('certificate_status')
          .eq('id', user.id)
          .maybeSingle();  // safer in case no row exists

      if (response == null) return; // if no record found, skip

      final status = response['certificate_status'];

      if (status == 'approved') {
        _timer?.cancel();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DoctorDashboardScreen()),
          );
        }
      } else if (status == 'rejected') {
        _timer?.cancel();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Certificate rejected! Please upload a valid certificate."),
              backgroundColor: Colors.red,
            ),
          );
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DoctorProfileScreen()),
            );
          });
        }
      }
      // else if still 'pending', do nothing and keep waiting
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2B4B),
        title: const Text("Pending Approval", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.hourglass_top, size: 100, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                "Your profile is under review.\nWe are checking for approval...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFF1C2B4B)),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(color: Color(0xFF1C2B4B)),
            ],
          ),
        ),
      ),
    );
  }
}
