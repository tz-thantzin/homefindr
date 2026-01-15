import 'package:go_router/go_router.dart';

import '../../presentation/pages/home/home.dart';
import '../../presentation/widgets/page_not_found.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutePath.initial,
    // errorBuilder is called when a user enters a non-existent URL.
    errorBuilder: (context, state) => NotFoundSection(
      onGoHome: () => context.go(RoutePath.initial),
    ),
    routes: [
      GoRoute(
        path: RoutePath.initial,
        name: RouteName.initial,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}

class RoutePath {
  static const String initial = '/';
  static const String home = '/home';
}

class RouteName {
  static const String initial = '/';
  static const String home = 'home';
}
