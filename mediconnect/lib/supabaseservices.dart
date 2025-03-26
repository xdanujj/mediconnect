import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  // ✅ Sign Up with Display Name
  Future<String?> signUp(String name, String email, String password) async {
    try {
      // Step 1: Check if user already exists using auth
      final existingUser = await client
          .from('profiles')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      if (existingUser != null) {
        return "You are already registered with this email. Please log in.";
      }

      // Step 2: Sign up using Supabase Auth
      final response = await client.auth.signUp(
        password: password,
        email: email,
      );

      if (response.user == null) {
        return "Sign-up failed. Please try again.";
      }

      // Step 3: Insert user data into the profiles table
      await client.from('profiles').insert({
        'id': response.user!.id,
        'name': name,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
      });

      return "Success";
    } on AuthException catch (e) {
      if (e.message.contains('already registered') || e.message.contains('User already exists')) {
        return "This email is already registered. Please log in.";
      }
      return e.message;
    } catch (e) {
      return "An unexpected error occurred: $e";
    }
  }

  // ✅ Sign In
  Future<String?> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Session is automatically persisted by Supabase
        return "Login successful";
      }
      return "Invalid email or password. Please try again.";
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('invalid')) {
        return "Invalid email or password. Please try again.";
      }
      return "Error: ${e.message}";
    } catch (e) {
      return "An unexpected error occurred. Please try again.";
    }
  }

  // ✅ Sign Out
  Future<String?> signOut() async {
    try {
      await client.auth.signOut();
      return "User signed out successfully.";
    } catch (e) {
      return "Error during sign-out: $e";
    }
  }

  // ✅ Get Current User
  User? getCurrentUser() {
    return client.auth.currentUser;
  }

  // ✅ Check if User is Logged In
  bool isUserLoggedIn() {
    return getCurrentUser() != null;
  }

  // ✅ Get Current Session
  Session? getCurrentSession() {
    return client.auth.currentSession;
  }
}
