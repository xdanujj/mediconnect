import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class DoctorProfileScreen extends StatefulWidget {
  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  File? _profileImage;
  File? _certificateFile;
  String? _doctorName;

  String? _selectedSpeciality;
  final List<String> _specialities = [
    'General Physician', 'Cardiologist', 'Dermatologist', 'Neurologist',
    'Pediatrician', 'Psychiatrist', 'Orthopedic', 'Gynecologist',
    'Ophthalmologist', 'Nephrologist', 'Urologist', 'Oncologist', 'Dentist'
  ];

  @override
  void initState() {
    super.initState();
    _fetchDoctorName();
    _checkIfProfileExists();
  }

  // ✅ Fetch Doctor's Name from Profiles Table
  Future<void> _fetchDoctorName() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final response = await Supabase.instance.client
        .from('profiles')
        .select('name')
        .eq('id', user.id)
        .maybeSingle();

    if (response != null) {
      setState(() {
        _doctorName = response['name'];
      });
    }
  }

  Future<void> _checkIfProfileExists() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final response = await Supabase.instance.client
        .from('doctors')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    if (response != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile already exists. Redirecting to dashboard...")),
        );
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _pickCertificate() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _certificateFile = File(result.files.single.path!);
      });
    }
  }

  Future<String?> _uploadFile(File file, String folder, String extension) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;

      final filePath = '$folder/${user.id}.$extension';

      await Supabase.instance.client.storage.from(folder).upload(
        filePath,
        file,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      final publicUrl = Supabase.instance.client.storage
          .from(folder)
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      print("File upload error: $e");
      return null;
    }
  }
  Future<void> _submitDoctorDetails() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
        return;
      }

      String? imageUrl;
      if (_profileImage != null) {
        imageUrl = await _uploadFile(_profileImage!, 'profilepictures', 'jpg');
      }

      String? certificateUrl;
      if (_certificateFile != null) {
        certificateUrl = await _uploadFile(_certificateFile!, 'certifications', 'pdf');
      }

      await Supabase.instance.client.from('doctors').upsert({
        'id': user.id,
        'speciality': _selectedSpeciality,
        'description': _descriptionController.text.trim(),
        'profile_image': imageUrl,
        'certificate_url': certificateUrl,
      });

      // Show "Waiting for verification" message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Waiting for verification...")),
      );

      // Wait for 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to the "Coming Soon" page without a new file
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text("Coming Soon")),
              body: const Center(
                child: Text(
                  "This feature is under development. Stay tuned!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $error")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Profile"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blueGrey[100],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Upload your profile photo here", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              if (_doctorName != null)
                Text("Name: $_doctorName", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              const Text("Speciality", style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _selectedSpeciality,
                onChanged: (value) {
                  setState(() => _selectedSpeciality = value);
                },
                items: _specialities.map((speciality) {
                  return DropdownMenuItem(
                    value: speciality,
                    child: Text(speciality),
                  );
                }).toList(),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value == null ? "Select a speciality" : null,
              ),
              const SizedBox(height: 10),

              const Text("Short Description", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Enter description" : null,
              ),
              const SizedBox(height: 10),

              const Text("Upload Certification", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickCertificate,
                    child: const Text("Choose File"),
                  ),
                  const SizedBox(width: 10),
                  _certificateFile != null
                      ? Expanded(child: Text(_certificateFile!.path.split('/').last))
                      : const Text("No file chosen"),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitDoctorDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C2B4B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Save Profile", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}