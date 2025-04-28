import 'package:flutter/material.dart';
import 'package:mediconnect/ProfilepageDoc.dart';
import 'package:mediconnect/DoctorInputPrescriptionPage.dart';
import 'package:mediconnect/doctorprofile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class DoctorDashboardScreen extends StatefulWidget {
  @override
  _DoctorDashboardScreenState createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF1C2B4B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String doctorName = "Doctor's Name";
  String doctorProfilePicUrl = '';
  TimeOfDay lowerLimit = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay upperLimit = const TimeOfDay(hour: 17, minute: 0);
  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctorData();
    _fetchAvailability();
    _fetchAppointments();
  }

  Future<void> _fetchDoctorData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final doctorResponse = await Supabase.instance.client
          .from('doctors')
          .select('profile_image')
          .eq('id', user.id)
          .single();

      if (doctorResponse?['profile_image'] != null) {
        setState(() {
          doctorProfilePicUrl = doctorResponse['profile_image'];
        });
      }

      final nameResponse = await Supabase.instance.client
          .from('profiles')
          .select('name')
          .eq('id', user.id)
          .single();

      if (nameResponse?['name'] != null) {
        setState(() {
          doctorName = nameResponse['name'];
        });
      }
    } catch (error) {
      print('Error fetching doctor data: $error');
    }
  }

  Future<void> _fetchAvailability() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final response = await Supabase.instance.client
          .from('doctor_availability')
          .select('start_time, end_time')
          .eq('doctor_id', user.id)
          .single();

      if (response != null) {
        setState(() {
          lowerLimit = _parseTime(response['start_time']);
          upperLimit = _parseTime(response['end_time']);
        });
      }
    } catch (error) {
      print('Error fetching availability: $error');
    }
  }

  Future<void> _saveAvailability() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      await Supabase.instance.client.from('doctor_availability').upsert({
        'doctor_id': user.id,
        'start_time': _formatTimeForDB(lowerLimit),
        'end_time': _formatTimeForDB(upperLimit),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Availability set: ${_formatTime(lowerLimit)} - ${_formatTime(upperLimit)}')),
      );
    } catch (error) {
      print('Error saving availability: $error');
    }
  }

  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay time) {
    final hours = time.hourOfPeriod;
    final minutes = time.minute;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hours == 0 ? 12 : hours}:${minutes.toString().padLeft(2, '0')} $period';
  }

  String _formatTimeForDB(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final initialTime = isStart ? lowerLimit : upperLimit;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: isStart ? 'Select Start Time' : 'Select End Time',
    );

    if (pickedTime != null) {
      setState(() {
        isStart ? lowerLimit = pickedTime : upperLimit = pickedTime;
      });
    }
  }

  Future<void> _fetchAppointments() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final response = await Supabase.instance.client
          .from('appointments')
          .select('id, patient_id, appointment_date, appointment_time, profiles(name)')
          .eq('doctor_id', user.id)
          .eq('status', 'pending')
          .order('appointment_date', ascending: true);

      setState(() {
        appointments = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      print('Error fetching appointments: $error');
    }
  }

  Future<void> _markAsVisited(String appointmentId) async {
    try {
      await Supabase.instance.client
          .from('appointments')
          .update({'status': 'visited'})
          .eq('id', appointmentId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient marked as visited!')),
      );

      _fetchAppointments(); // Refresh the list
    } catch (error) {
      print('Error marking as visited: $error');
    }
  }

  String _formatTimeForDisplay(String timeString) {
    final parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '${hour}:${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: const BoxDecoration(
              color: Color(0xFF1C2B4B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: doctorProfilePicUrl.isNotEmpty
                      ? NetworkImage(doctorProfilePicUrl)
                      : const AssetImage('assets/images/profile_placeholder.png') as ImageProvider,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome Dr.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  doctorName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _pickTime(context, true);
                    await _pickTime(context, false);
                    _saveAvailability();
                  },
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
          const Text(
            'Patients List',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          appointments.isEmpty
              ? const Text('No patients yet.', style: TextStyle(color: Colors.grey))
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final patient = appointments[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                    backgroundColor: const Color(0xFF1C2B4B),
                    foregroundColor: Colors.white,
                  ),
                  title: Text(patient['profiles']['name'] ?? 'Unknown'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${patient['appointment_date']} | Time: ${_formatTimeForDisplay(patient['appointment_time'])}',
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _markAsVisited(patient['id']),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1C2B4B),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: const Text('Visited', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DoctorPrescriptionInputPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: const Text('Prescription', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
