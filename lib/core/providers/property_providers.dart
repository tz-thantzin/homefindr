import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/property_repository_impl.dart';
import '../../domain/models/property.dart';
import '../../domain/repositories/property_repository.dart';

/// ------------------------------------------------------------
/// Repository Provider (DI)
/// ------------------------------------------------------------
final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  return PropertyRepositoryImpl();
});

/// ------------------------------------------------------------
/// Base Properties Provider
/// ------------------------------------------------------------
final propertiesProvider = FutureProvider<List<Property>>((ref) async {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getProperties();
});

/// ------------------------------------------------------------
/// Latest / Limited Properties (Home page)
/// ------------------------------------------------------------
final limitedPropertiesProvider = FutureProvider.family<List<Property>, int>((ref, limit) async {
  final properties = await ref.watch(propertiesProvider.future);
  return properties.take(limit).toList();
});

/// ------------------------------------------------------------
/// Featured Properties
/// ------------------------------------------------------------
final featuredPropertiesProvider = FutureProvider<List<Property>>((ref) async {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getFeaturedProperties();
});

/// ------------------------------------------------------------
/// Properties by Status (For Rent / For Sale / Sold)
/// ------------------------------------------------------------
final propertiesByStatusProvider = FutureProvider.family<List<Property>, String>((ref, status) async {
  final properties = await ref.watch(propertiesProvider.future);
  return properties.where((p) => p.status == status).toList();
});
