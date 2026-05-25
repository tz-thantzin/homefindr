import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────
// Favorites Provider — in-memory Set of property IDs
// ─────────────────────────────────────────────
class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String propertyId) {
    if (state.contains(propertyId)) {
      state = {...state}..remove(propertyId);
    } else {
      state = {...state, propertyId};
    }
  }

  bool isFavorite(String propertyId) => state.contains(propertyId);
}

final favoritesProvider =
NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);