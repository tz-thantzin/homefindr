import 'package:go_router/go_router.dart';

import '../../presentation/pages/buy_rent/buy_screen.dart';
import '../../presentation/pages/buy_rent/rent_screen.dart';
import '../../presentation/pages/contact/contact_screen.dart';
import '../../presentation/pages/home/home_screen.dart';
import '../../presentation/pages/property/property_details_screen.dart';
import '../../presentation/pages/search/search_result/search_result_screen.dart';
import '../../presentation/widgets/page_not_found.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutePath.initial,
    errorBuilder: (context, state) => NotFoundSection(
      onGoHome: () => context.go(RoutePath.initial),
    ),
    routes: [
      GoRoute(
        path: RoutePath.initial,
        name: RouteName.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePath.buy,
        name: RouteName.buy,
        pageBuilder: (context, state) =>
            NoTransitionPage(
              child: BuyScreen(initialType: state.uri.queryParameters['type'] ?? ''),
            ),
      ),
      GoRoute(
        path: RoutePath.rent,
        name: RouteName.rent,
        pageBuilder: (context, state) =>
            NoTransitionPage(
              child: RentScreen(initialType: state.uri.queryParameters['type'] ?? ''),
            ),
      ),
      GoRoute(
        path: RoutePath.contact,
        name: RouteName.contact,
        pageBuilder: (context, state) => const NoTransitionPage(child: ContactScreen()),
      ),
      GoRoute(
        path: RoutePath.search,
        name: RouteName.search,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: SearchResultsScreen(
              query: state.uri.queryParameters['q'] ?? '',
              status: state.uri.queryParameters['status'] ?? '',
              type: state.uri.queryParameters['type'] ?? '',
            )),
      ),
      GoRoute(
        path: RoutePath.propertyDetail,
        name: RouteName.propertyDetail,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: PropertyDetailScreen(
              propertyId: state.pathParameters['id'] ?? '',
            )),
      ),
    ],
  );
}

class RoutePath {
  static const String initial = '/';
  static const String buy = '/buy';
  static const String rent = '/rent';
  static const String contact = '/contact';
  static const String search = '/search';
  static const String propertyDetail = '/property/:id';
}

class RouteName {
  static const String home = 'home';
  static const String buy = 'buy';
  static const String rent = 'rent';
  static const String contact = 'contact';
  static const String search = 'search';
  static const String propertyDetail = 'propertyDetail';
}