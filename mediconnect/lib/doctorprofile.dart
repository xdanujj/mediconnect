import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'doctordashboard.dart';

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
  bool _profileExists = false;

  final List<String> _specialities = [
    'General Physician', 'Cardiologist', 'Dermatologist', 'Neurologist',
    'Pediatrician', 'Psychiatrist', 'Orthopedic', 'Gynecologist',
    'Ophthalmologist', 'Nephrologist', 'Urologist', 'Oncologist', 'Dentist'
  ];

  @override
  void initState() {
    super.initState();
    _fetchDoctorName();
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Certificate uploaded successfully.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file selected.")),
      );
    }
  }

  Future<String?> _uploadFile(File file, String bucketName, String extension) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;

      final filePath = '$bucketName/${user.id}.${extension.toLowerCase()}';

      await Supabase.instance.client.storage.from(bucketName).upload(
        filePath,
        file,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      final publicUrl = Supabase.instance.client.storage
          .from(bucketName)
          .getPublicUrl(filePath);

      print("File uploaded to $publicUrl");
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

      // ✅ Upload Profile Picture
      String? imageUrl;
      if (_profileImage != null) {
        final extension = _profileImage!.path.split('.').last;
        imageUrl = await _uploadFile(_profileImage!, 'profilepictures', extension);
      }

      // ✅ Upload Certificate
      String? certificateUrl;
      if (_certificateFile != null) {
        certificateUrl = await _uploadFile(_certificateFile!, 'certifications', 'pdf');
      }

      // ✅ Insert Data into 'doctors' Table with Description
      await Supabase.instance.client.from('doctors').upsert({
        'id': user.id,
        'speciality': _selectedSpeciality,
        'description': _descriptionController.text.trim(), // ✅ Storing Description
        'profile_image': imageUrl,
        'certificate_url': certificateUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile submitted! Redirecting to dashboard.")),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoctorDashboardScreen()),
        );
      });

    } catch (error) {
      print("Error during profile submission: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profileExists) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Profile already exists. Redirecting to dashboard..."),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2B4B),
        title: const Text(
          "Doctor Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFF1C2B4B),
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 40, color: Colors.white),
                        SizedBox(height: 8),
                        Text("Upload Profile Pic", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              if (_doctorName != null)
                Text("Name: $_doctorName", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1C2B4B))),

              const SizedBox(height: 30),

              DropdownButtonFormField<String>(
                value: _selectedSpeciality,
                onChanged: (value) => setState(() => _selectedSpeciality = value),
                items: _specialities.map((speciality) => DropdownMenuItem(value: speciality, child: Text(speciality))).toList(),
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Select Speciality"),
                validator: (value) => value == null ? "Please select a speciality" : null,
              ),

              const SizedBox(height: 20),

              // ✅ Short Description Field
              TextFormField(
                controller: _descriptionController,
                maxLength: 150,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Add Short Description",
                  hintText: "Write a short description about yourself (max 150 characters)",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a short description";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _pickCertificate,
                child: const Text("Upload Certification (PDF Only)"),
              ),
              if (_certificateFile != null)
                Text("Uploaded: ${_certificateFile!.path.split('/').last}"),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submitDoctorDetails,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1C2B4B)),
                child: const Text("Save Profile", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
