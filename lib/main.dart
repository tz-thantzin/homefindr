import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/locale_provider.dart';
import 'core/router/app_router.dart';
import 'l10n/app_localizations.dart';

void main() {
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