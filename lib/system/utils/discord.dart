import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class Discord {
  static const url = 'https://discord.com/api/webhooks/1285808728125341706/Hgt_LJ5UV-ou1EGPGHV0klmFKGSuq_ZFP9weP6RkM033FEODvJ8tbnv_Jzjhuv-cGn94';
  final _dio = Dio();

  Future<void> sendMessage(String message) async {
    try {
      final response = await _dio.post(
        url,
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
        data: jsonEncode({
          'content': message,
        }),
      );

      if (response.statusCode != 204) {
        Debug.severe("Failed to send message to Discord: ${response.statusCode}");
      }
    } catch (e) {
      Debug.severe("Error sending message to Discord: $e");
    }
  }
}
