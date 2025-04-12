import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/service/email_service.dart';
import 'package:weather_app/features/weather/model/email.dart';

class EmailSubscriptionRepository {
  static const String _key = 'email_subscriptions';
  final EmailService _emailService;

  EmailSubscriptionRepository() : _emailService = EmailService();

  Future<void> subscribe(String email, String? cityName) async {
    try {
      final subscriptions = await _getSubscriptions();

      if (subscriptions.any((sub) => sub.email == email)) {
        throw Exception('Email already subscribed');
      }

      final newSubscription = EmailSubscription(
        email: email,
        createdAt: DateTime.now(),
        cityName: cityName,
      );

      subscriptions.add(newSubscription);
      await _saveSubscriptions(subscriptions);

      await _sendConfirmationEmail(email);
    } catch (e) {
      print('Error in subscribe: $e');
      throw Exception('Failed to subscribe');
    }
  }

  Future<void> unsubscribe(String email) async {
    try {
      final subscriptions = await _getSubscriptions();
      subscriptions.removeWhere((sub) => sub.email == email);
      await _saveSubscriptions(subscriptions);
      await _sendUnsubcridedEmail(email);
    } catch (e) {
      print('Error in unsubscribe: $e');
      throw Exception('Failed to unsubscribe');
    }
  }
  Future<void> _sendConfirmationEmail(String email) async {
    final htmlContent = '''
      Welcome to Weather Service!
      You have successfully subscribed to daily weather updates.
      If you didn’t request this, you can unsubscribe anytime.
    ''';

    await _emailService.sendEmail(
      to: email,
      subject: 'Subscription Confirmed',
      htmlContent: htmlContent,
    );
  }

  Future<void> _sendUnsubcridedEmail(String email) async {
    final htmlContent = '''
      You haven't subscribed
      You can't subscribed to daily weather updates again anytime.

    ''';

    await _emailService.sendEmail(
      to: email,
      subject: 'Subscription Confirmed',
      htmlContent: htmlContent,
    );
  }

  // === Local storage helpers ===
  Future<List<EmailSubscription>> _getSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return [];

    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => EmailSubscription.fromJson(json)).toList();
  }

  Future<void> _saveSubscriptions(List<EmailSubscription> subscriptions) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(subscriptions.map((s) => s.toJson()).toList());
    await prefs.setString(_key, data);
  }
}
