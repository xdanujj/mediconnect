import 'package:flutter/material.dart';
import 'chatbot_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatbotService _chatbotService = ChatbotService();
  List<Map<String, String>> messages = [];

  Future<void> sendMessage(String message) async {
    messages.add({"role": "user", "text": message});
    notifyListeners();

    String response = await _chatbotService.sendMessage(message);
    messages.add({"role": "bot", "text": response});
    notifyListeners();
  }
}