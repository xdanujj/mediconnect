import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String userName = 'User';
  String? selectedDoctor;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

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
        selectedDoctor = null;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _bookNow() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment booked with $selectedDoctor on ${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year} at ${selectedTime.format(context)}!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _getMonthName(int month) {
    List<String> months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }

  Widget buildDoctorCard(String name, String specialization, double rating, int reviews) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$specialization • ⭐ $rating ($reviews Reviews)'),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}',
                style: const TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 22),
            ],
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: ElevatedButton(
              onPressed: _selectTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C2B4B),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Select Time', style: TextStyle(fontSize: 18)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
}
