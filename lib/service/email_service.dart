import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailService {
 final String emailJsUrl = dotenv.env['EMAIL_JS_URL'] ?? '';
  final String serviceId = dotenv.env['SERVICE_ID'] ?? '';
  final String templateId = dotenv.env['TEMPLATE_ID'] ?? '';
  final String userId = dotenv.env['USER_ID'] ?? '';

  Future<void> sendEmail({
    required String to,
    required String subject,
    required String htmlContent,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(emailJsUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'to_email': to,
            'subject': subject,
            'message': htmlContent,
          },
        }),
      );

      if (response.statusCode != 200) {
        print('Failed to send email: ${response.body}');
        throw Exception('Failed to send email');
      }

      print('Email sent successfully');
    } catch (e) {
      print('Error sending email: $e');
      throw Exception('Failed to send email');
    }
  }
}
