import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'VideoCallPage.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({Key? key}) : super(key: key);

  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    setState(() => isLoading = true);

    try {
      // Fetch from doctors + join profiles to get doctor's name
      final raw = await supabase
          .from('doctors')
          .select('''
            id,
            specialty,
            profiles ( name, email )
          ''');

      final List<Map<String, dynamic>> data = (raw as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      setState(() {
        doctors = data;
        isLoading = false;
      });
    } on PostgrestException catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch doctors: ${e.message}')),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Doctors')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : doctors.isEmpty
          ? const Center(child: Text('No doctors available for video consultation.'))
          : ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (ctx, i) {
          final doc = doctors[i];
          final id = doc['id'];
          final profile = doc['profiles'];
          final doctorName = profile != null ? profile['name'] ?? 'Unknown' : 'Unknown';
          final specialty = doc['specialty'] ?? 'General Physician';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(doctorName),
              subtitle: Text(specialty),
              trailing: ElevatedButton(
                child: const Text('Video Call'),
                onPressed: id != null
                    ? () {
                  final channel = 'channel_${id}_${supabase.auth.currentUser!.id}';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoCallPage(
                        channelName: channel,
                        doctorId: id,
                      ),
                    ),
                  );
                }
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
