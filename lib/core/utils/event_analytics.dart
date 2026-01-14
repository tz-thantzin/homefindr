import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  Future<void> sentEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    _analytics.logEvent(
      name: eventName,
      parameters: {
        ...parameters ?? {},
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
