import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global/environment.dart';

import '../models/user.dart';
import '../models/messages_response.dart';

import '../services/auth_service.dart';

class ChatService with ChangeNotifier {
  User addressee;

  Future<List<Message>> getChat(String userId) async {
    final response = await http.get('${Environment.apiUrl}/messages/$userId',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });

    final messagesResponse = messagesResponseFromJson(response.body);
    return messagesResponse.messages;
  }
}
