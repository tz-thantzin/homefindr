import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'core/providers/locale_provider.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: HomezApp()));
}

class HomezApp extends ConsumerWidget {
  const HomezApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuilds MaterialApp whenever the locale changes
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Homez',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: kSupportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      routerConfig: AppRouter.router,
    );
  }
}