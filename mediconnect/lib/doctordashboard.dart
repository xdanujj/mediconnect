import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorDashboardScreen extends StatefulWidget {
  @override
  _DoctorDashboardScreenState createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  String doctorName = "Doctor's Name";
  String doctorProfilePicUrl = '';
  double lowerLimit = 0; // Starting from 12:00 AM
  double upperLimit = 24; // Ending at 11:59 PM

  // Example appointments data
  List<Map<String, dynamic>> appointments = [
    {
      'id': 1,
      'name': 'Akshat Shah',
      'date': '21/02/2025',
      'timeSlot': '9:00am to 9:15am',
    },
    {
      'id': 2,
      'name': 'Anuj Lolam',
      'date': '22/02/2025',
      'timeSlot': '10:00am to 10:15am',
    }
  ];

  @override
  void initState() {
    super.initState();
    _fetchDoctorData();
  }

  // Fetch Doctor Data using auth.users.id
  Future<void> _fetchDoctorData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        print('User not logged in');
        return;
      }

      // Fetch profile_image from doctors table
      final doctorResponse = await Supabase.instance.client
          .from('doctors')
          .select('profile_image')
          .eq('id', user.id)
          .single();

      if (doctorResponse != null && doctorResponse['profile_image'] != null) {
        setState(() {
          doctorProfilePicUrl = doctorResponse['profile_image'];
        });
      }

      // Fetch name from profiles table
      final nameResponse = await Supabase.instance.client
          .from('profiles')
          .select('name')
          .eq('id', user.id)
          .single();

      if (nameResponse != null && nameResponse['name'] != null) {
        setState(() {
          doctorName = nameResponse['name'];
        });
      }
    } catch (error) {
      print('Error fetching doctor data: $error');
    }
  }

  void _handleAppointmentAction(int id, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment $action for ID: $id')),
    );
  }

  String _formatTime(double time) {
    int hours = time.floor();
    int minutes = ((time - hours) * 60).round();
    String period = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12 == 0 ? 12 : hours % 12;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
  }

  void _showTimeSlotSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 400,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Select Your Availability',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Lower Limit Slider
                  const Text('Start Time:'),
                  Slider(
                    value: lowerLimit,
                    min: 0,
                    max: 24,
                    divisions: 24, // 1-hour interval
                    label: _formatTime(lowerLimit),
                    onChanged: (value) {
                      setModalState(() {
                        if (value < upperLimit) {
                          lowerLimit = value;
                        }
                      });
                    },
                  ),
                  Text('Start Time: ${_formatTime(lowerLimit)}'),

                  const SizedBox(height: 20),

                  // Upper Limit Slider
                  const Text('End Time:'),
                  Slider(
                    value: upperLimit,
                    min: 0,
                    max: 24,
                    divisions: 24,
                    label: _formatTime(upperLimit),
                    onChanged: (value) {
                      setModalState(() {
                        if (value > lowerLimit) {
                          upperLimit = value;
                        }
                      });
                    },
                  ),
                  Text('End Time: ${_formatTime(upperLimit)}'),

                  const SizedBox(height: 20),

                  // Confirm Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Availability Set: ${_formatTime(lowerLimit)} to ${_formatTime(upperLimit)}')),
                      );
                    },
                    child: const Text('Confirm Availability'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF1C2B4B),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Profile Picture
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      image: DecorationImage(
                        image: doctorProfilePicUrl.isNotEmpty
                            ? NetworkImage(doctorProfilePicUrl)
                            : const AssetImage('assets/images/profile_placeholder.png')
                        as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Welcome Text
                  const Text(
                    'Welcome Dr.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    doctorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: _showTimeSlotSelector,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1C2B4B),
                    ),
                    child: const Text('Select Your TimeSlot'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Appointments Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Appointments:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Appointment Cards
            for (var appointment in appointments)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${appointment['id']}. ${appointment['name']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Date: ${appointment['date']}'),
                    Text('Time-Slot: ${appointment['timeSlot']}'),
                    const SizedBox(height: 10),

                    // Accept & Reject Buttons
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              _handleAppointmentAction(appointment['id'], 'Accepted'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Accept'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () =>
                              _handleAppointmentAction(appointment['id'], 'Rejected'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
