import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class DoctorProfileScreen extends StatefulWidget {
  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _specialityController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _profileImage;

  // ✅ Pick Image using Image Picker
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  // ✅ Upload Image to Supabase Storage
  Future<String?> _uploadImage(File imageFile) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) return null;

      final imagePath = 'profilepictures/${user.id}.jpg';

      // Upload to Supabase Storage
      await Supabase.instance.client.storage.from('profilepictures').upload(
        imagePath,
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      // Generate Public URL
      final publicUrl = Supabase.instance.client.storage
          .from('profilepictures')
          .getPublicUrl(imagePath);

      return publicUrl;
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  // ✅ Submit Doctor's Details to Supabase
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
        imageUrl = await _uploadImage(_profileImage!);
      }

      await Supabase.instance.client.from('doctors').upsert({
        'id': user.id,
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'speciality': _specialityController.text.trim(),
        'description': _descriptionController.text.trim(),
        'profile_image': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully!")),
      );

      // Clear fields
      _firstNameController.clear();
      _lastNameController.clear();
      _specialityController.clear();
      _descriptionController.clear();
      setState(() => _profileImage = null);
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
              // ✅ Profile Picture
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

                    // ✅ Instruction Text
                    const Text(
                      "Upload Your Profile Pic Here",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),


              // ✅ First Name
              const Text("First Name", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Enter first name" : null,
              ),
              const SizedBox(height: 10),

              // ✅ Last Name
              const Text("Last Name", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Enter last name" : null,
              ),
              const SizedBox(height: 10),

              // ✅ Speciality
              const Text("Speciality", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _specialityController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Enter speciality" : null,
              ),
              const SizedBox(height: 10),

              // ✅ Description
              const Text("Short Description", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Enter description" : null,
              ),
              const SizedBox(height: 20),

              // ✅ Submit Button
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
