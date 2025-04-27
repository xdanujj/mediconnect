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
      // 1) call .select() with no generic
      // 2) await it directly (no .execute())
      final raw = await supabase
          .from('doctors')
          .select();            // <-- no <…>()


      // raw is PostgrestList, i.e. List<dynamic>
      final List<Map<String, dynamic>> data =
      (raw as List<dynamic>)
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
      appBar: AppBar(title: Text('Available Doctors')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : doctors.isEmpty
          ? Center(child: Text('No doctors available for video consultation.'))
          : ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (ctx, i) {
          final doc = doctors[i];
          final id  = doc['id'];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text(doc['name'] ?? 'Unknown'),
              subtitle: Text(doc['specialization'] ?? 'General Physician'),
              trailing: ElevatedButton(
                child: Text('Video Call'),
                onPressed: id != null
                    ? () {
                  final channel =
                      'channel_${id}_${supabase.auth.currentUser!.id}';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoCallPage(channelName: channel),
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