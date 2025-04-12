import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ChatbotService {
  static const String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";
  static const String apiKey = "AIzaSyCrZUMi1W8fmD6eCS7VSyKDzfuj6N5cqsU"; // Store securely

  void checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("✅ Internet is available!");
      }
    } on SocketException catch (_) {
      print("❌ No internet connection!");
    }
  }

  Future<String> sendMessage(String message) async {
    // Embedding system instructions within the user message
    String prompt = "You are MediConnect, an AI assistant built for a doctor appointment app. "
        "You help users with booking appointments, checking doctor availability, understanding time slots, "
        "and answering basic medical queries. You do not give medical diagnoses or prescriptions. "
        "If a question is unrelated to healthcare or MediConnect services, politely decline. \n\nUser: $message";

    final requestBody = {
      "contents": [
        {"parts": [{"text": prompt}]}
      ]
    };

    try {
      final response = await http.post(
        Uri.parse("$apiUrl?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["candidates"][0]["content"]["parts"][0]["text"] ??
            "I couldn't process that request.";
      } else {
        return "Error: ${response.body}";
      }
    } catch (e) {
      return "Error: Unable to connect to AI service.";
    }
  }
}