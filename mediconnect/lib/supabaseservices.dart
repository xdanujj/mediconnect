import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  // Sign Up with Display Name
  Future<String?> signUp(String name, String email, String password) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name}, // Saving Display Name to Metadata
      );
      return response.user?.id;
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Sign In
  Future<String?> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user?.id;
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Get Current User
  User? getCurrentUser() {
    return client.auth.currentUser;
  }
}
