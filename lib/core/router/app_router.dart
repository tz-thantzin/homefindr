import 'package:go_router/go_router.dart';

import '../../presentation/pages/home/home.dart';

class AppRouter {
  static const String home = 'home';

  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}