import "package:go_router/go_router.dart";
import 'package:flutter/material.dart';

import 'package:weather_app/features/weather/presentation/history/history_page.dart';
import 'package:weather_app/features/weather/presentation/home/homepage.dart';
import  'package:weather_app/features/weather/presentation/email/email_supriction_page.dart';
class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => HistoryPage(),
      ),
      GoRoute(path: '/email',
        builder: (context, state) => EmailSubscriptionPage(),
      ),
    ],
  );
}
