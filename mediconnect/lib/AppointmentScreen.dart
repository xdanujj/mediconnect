import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  String userName = 'User';
  TimeOfDay? selectedSlot;
  String? selectedDoctor;
  List<Map<String, dynamic>> doctors = [];
  String? confirmationMessage;
  TimeOfDay? doctorStartTime;
  TimeOfDay? doctorEndTime;

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchDoctors();
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

  Future<void> fetchDoctors() async {
    try {
      final response = await Supabase.instance.client
          .from('doctors')
          .select('id, speciality, profile_image, profiles(name)');
      setState(() {
        doctors = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      print('Error fetching doctors: $error');
    }
  }

  Future<void> fetchDoctorAvailability(String doctorId) async {
    try {
      final response = await Supabase.instance.client
          .from('doctor_availability')
          .select('start_time, end_time')
          .eq('doctor_id', doctorId)
          .single();
      setState(() {
        doctorStartTime = _convertToTimeOfDay(response['start_time']);
        doctorEndTime = _convertToTimeOfDay(response['end_time']);
      });
    } catch (error) {
      print('Error fetching doctor availability: $error');
    }
  }

  TimeOfDay _convertToTimeOfDay(String time) {
    return TimeOfDay(
      hour: int.parse(time.split(":")[0]),
      minute: int.parse(time.split(":")[1]),
    );
  }

  void selectDoctor(String doctorId, String doctorName) {
    setState(() {
      selectedDoctor = doctorName;
      selectedSlot = null;
      confirmationMessage = null;
    });
    fetchDoctorAvailability(doctorId);
  }

  void _selectTime() async {
    if (doctorStartTime == null || doctorEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a doctor to view availability.")),
      );
      return;
    }

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedSlot ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      if (_isTimeWithinRange(pickedTime)) {
        setState(() {
          selectedSlot = pickedTime;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Selected time is outside the doctor's available hours."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  bool _isTimeWithinRange(TimeOfDay time) {
    return (time.hour > doctorStartTime!.hour ||
        (time.hour == doctorStartTime!.hour && time.minute >= doctorStartTime!.minute)) &&
        (time.hour < doctorEndTime!.hour ||
            (time.hour == doctorEndTime!.hour && time.minute <= doctorEndTime!.minute));
  }

  void _confirmBooking() {
    if (selectedDoctor != null && selectedSlot != null) {
      setState(() {
        confirmationMessage =
        '✅ Your slot with Dr. $selectedDoctor has been booked for ${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year} at ${selectedSlot!.format(context)}!';
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Widget buildDoctorCard(String doctorId, String name, String title, String? profileImageUrl, bool isSelected) {
    return GestureDetector(
      onTap: () => selectDoctor(doctorId, name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1C2B4B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl) : null,
                backgroundColor: const Color(0xFF1C2B4B),
                child: profileImageUrl == null ? const Icon(Icons.person, color: Colors.white) : null,
                radius: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
                    Text(title, style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Book an Appointment'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1C2B4B),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text('Hello, $userName 👋', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
              Text(
                "Selected Date: ${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Text('Available Doctors', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          Expanded(
            child: doctors.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                final isSelected = selectedDoctor == doctor['profiles']['name'];
                return buildDoctorCard(
                  doctor['id'],
                  doctor['profiles']['name'],
                  doctor['speciality'],
                  doctor['profile_image'],
                  isSelected,
                );
              },
            ),
          ),

          ElevatedButton(
            onPressed: _selectTime,
            child: const Text('Select Time Slot'),
          ),
          ElevatedButton(
            onPressed: _confirmBooking,
            child: const Text('Confirm Your Slot'),
          ),
          if (confirmationMessage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(confirmationMessage!, style: const TextStyle(color: Colors.green)),
            ),
        ],
      ),
    );
  }
}
