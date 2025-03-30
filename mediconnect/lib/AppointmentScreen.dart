import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  String userName = 'User';
  String? selectedSlot;
  String? selectedDoctor;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  // ✅ Fetch User's Name from Supabase
  Future<void> fetchUserName() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('profiles')
            .select('name')
            .eq('id', user.id)
            .single();

        setState(() {
          userName = response['name'] ?? 'User';
        });
      }
    } catch (error) {
      print('Error fetching user name: $error');
    }
  }

  // ✅ Open Calendar and Select Date
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        selectedSlot = null;
        selectedDoctor = null; // Reset selection on date change
      });
    }
  }

  // ✅ Book Now Function
  void _bookNow() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment booked with $selectedDoctor on ${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year} at $selectedSlot!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: GestureDetector(
          onTap: _selectDate,
          child: Text(
            '${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}',
            style: const TextStyle(
              fontSize: 18,
              decoration: TextDecoration.underline,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1C2B4B),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Hello, $userName 👋',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1C2B4B)),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Available Doctors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1C2B4B)),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                buildDoctorCard('Olivia Wilson', 'Consultant - Physiotherapy', 4.9, 37),
                buildDoctorCard('Jonathan Patterson', 'Consultant - Physiotherapy', 4.8, 42),
              ],
            ),
          ),
          if (selectedSlot != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: ElevatedButton(
                onPressed: _bookNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C2B4B),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Book Now', style: TextStyle(fontSize: 18)),
              ),
            ),
        ],
      ),
    );
  }

  // ✅ Build Doctor Card
  Widget buildDoctorCard(String name, String title, double rating, int reviews) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF1C2B4B),
                  radius: 30,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: Color(0xFF1C2B4B), fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        Text(' $rating ($reviews Reviews)', style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                10,
                    (index) {
                  final time = '${9 + (index ~/ 2)}:${index % 2 == 0 ? '00' : '30'}';
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedSlot = time;
                        selectedDoctor = name; // Track the selected doctor
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (selectedSlot == time && selectedDoctor == name)
                          ? Colors.green
                          : const Color(0xFF1C2B4B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(time),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Helper to Get Month Name
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
