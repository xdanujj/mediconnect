import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'VideoCallPage.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({Key? key}) : super(key: key);

  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
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
    try {
      setState(() => isLoading = true);

      // Removed 'specialty' from query to avoid error
      final raw = await supabase
          .from('doctors')
          .select('''
            id,
            profiles ( name, email )
          ''');

      final List<Map<String, dynamic>> fetchedDoctors = (raw as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      setState(() {
        doctors = fetchedDoctors;
      });
    } on PostgrestException catch (e) {
      _showError('Failed to fetch doctors: ${e.message}');
    } catch (e) {
      _showError('Unexpected error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Doctors')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : doctors.isEmpty
          ? const Center(
        child: Text('No doctors available for video consultation.'),
      )
          : ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (ctx, i) {
          final doctor = doctors[i];
          final id = doctor['id'];
          final profile = doctor['profiles'];
          final doctorName = profile != null ? profile['name'] ?? 'Unknown' : 'Unknown';

          // Since 'specialty' is not available, show default
          const specialty = 'General Physician';

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
                  final channelName = 'channel_${id}_${supabase.auth.currentUser!.id}';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoCallPage(
                        channelName: channelName,
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
