import 'dart:convert';
import 'package:http/http.dart' as http;

class Discord {
  static const url =
      'https://discord.com/api/webhooks/1285808728125341706/Hgt_LJ5UV-ou1EGPGHV0klmFKGSuq_ZFP9weP6RkM033FEODvJ8tbnv_Jzjhuv-cGn94';

  Future<void> sendMessage(String message) async {
    // final payload = {
    //   'content': "$sharedUsername: $message",
    // };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(message),
      );
      if (response.statusCode != 204) {
        print("Failed to send message to Discord: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending message to Discord: $e");
    }
  }
}
