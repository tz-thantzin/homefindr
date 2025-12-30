import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'core/extensions/theme_ex.dart';
import 'core/router/app_router.dart';
import 'l10n/app_localizations.dart';

final getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      routerConfig: AppRouter.router,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}