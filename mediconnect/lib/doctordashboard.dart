import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorDashboardScreen extends StatefulWidget {
  @override
  _DoctorDashboardScreenState createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  String doctorName = "Doctor's Name";
  String doctorProfilePicUrl = '';
  TimeOfDay lowerLimit = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay upperLimit = const TimeOfDay(hour: 17, minute: 0);

  @override
  void initState() {
    super.initState();
    _fetchDoctorData();
    _fetchAvailability();
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

      if (doctorResponse != null && doctorResponse['profile_image'] != null) {
        setState(() {
          doctorProfilePicUrl = doctorResponse['profile_image'];
        });
      }

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
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );


    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          lowerLimit = pickedTime;
        } else {
          upperLimit = pickedTime;
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: doctorProfilePicUrl.isNotEmpty
                        ? NetworkImage(doctorProfilePicUrl)
                        : const AssetImage('assets/images/profile_placeholder.png') as ImageProvider,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 20),

                  // Doctor Name
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

                  // Select Time Slot Button
                  ElevatedButton(
                    onPressed: () async {
                      await _pickTime(context, true);
                      await _pickTime(context, false);
                      _saveAvailability();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1C2B4B),
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Select Your TimeSlot'),
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