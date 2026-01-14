import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get_it/get_it.dart';
import 'package:homefindr/core/utils/event_analytics.dart';
import 'package:homefindr/firebase_options.dart';

import 'core/extensions/theme_ex.dart';
import 'core/router/app_router.dart';
import 'l10n/app_localizations.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  await AnalyticsService().logAppOpen();
  runApp(const ProviderScope(child: HomezApp()));
}

class HomezApp extends StatelessWidget {
  const HomezApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Homez - Real Estate',
      debugShowCheckedModeBanner: false,
      theme: context.theme(),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.linear(mediaQuery.textScaler.scale(1.0).clamp(0.6, 1.4))),
          child: child!,
        );
      },
      routerConfig: AppRouter.router,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
