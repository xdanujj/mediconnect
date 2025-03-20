import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: AppointmentScreen()));
}

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  int selectedMonthIndex = DateTime.now().month - 1;
  int selectedYear = DateTime.now().year;

  final List<Doctor> doctors = [
    Doctor(
      name: 'Olivia Wilson',
      specialty: 'Consultant - Physiotherapy',
      rating: 4.9,
      reviews: 37,
      image: 'assets/doctor1.png',
      timeSlots: ['09:00', '10:00', '10:30', '11:00', '11:30', '12:00',
        '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
        '16:00', '16:30', '17:00'],
    ),
    Doctor(
      name: 'Jonathan Patterson',
      specialty: 'Consultant - Physiotherapy',
      rating: 4.9,
      reviews: 37,
      image: 'assets/doctor2.png',
      timeSlots: ['09:00', '10:00', '10:30', '11:00', '11:30', '12:00',
        '13:00'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: GestureDetector(
          onTap: _selectMonth,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${months[selectedMonthIndex]} $selectedYear',
                  style: const TextStyle(color: Colors.white)),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDateBar(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  return _buildDoctorCard(doctors[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to Show Month Picker
  void _selectMonth() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: ListView.builder(
            itemCount: months.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${months[index]} $selectedYear'),
                onTap: () {
                  Navigator.pop(context, index);
                },
              );
            },
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedMonthIndex = selected;
      });
    }
  }

  // Generate Dates Based on Selected Month and Year
  List<DateTime> _generateDatesForMonth() {
    int daysInMonth = DateTime(selectedYear, selectedMonthIndex + 1, 0).day;
    return List<DateTime>.generate(daysInMonth, (index) =>
        DateTime(selectedYear, selectedMonthIndex + 1, index + 1));
  }

  // Date Bar UI with Horizontal Scrolling
  Widget _buildDateBar() {
    List<DateTime> dates = _generateDatesForMonth();
    DateTime today = DateTime.now();

    return SizedBox(
      height: 80,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: dates.map((date) {
            bool isToday = date.year == today.year &&
                date.month == today.month &&
                date.day == today.day;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isToday ? Colors.blueAccent : Colors.blueGrey[800],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1],
                    style: const TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isToday ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Doctor Card UI
  Widget _buildDoctorCard(Doctor doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(doctor.image),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    doctor.specialty,
                    style: const TextStyle(color: Colors.white54),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 18),
                      Text(
                        '${doctor.rating} (${doctor.reviews} Reviews)',
                        style: const TextStyle(color: Colors.white),
                      ),
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
            children: doctor.timeSlots.map((time) {
              return _buildTimeSlot(time);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Time Slot UI
  Widget _buildTimeSlot(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Text(
        time,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

// Doctor Model
class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final String image;
  final List<String> timeSlots;

  Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.timeSlots,
  });
}
