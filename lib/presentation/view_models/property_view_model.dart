import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/property_providers.dart';
import '../../domain/models/property.dart';


final latestPropertiesViewModel =
FutureProvider.family<List<Property>, int>((ref, limit) {
  return ref.watch(limitedPropertiesProvider(limit).future);
});

final featuredPropertiesViewModel =
FutureProvider<List<Property>>((ref) {
  return ref.watch(featuredPropertiesProvider.future);
});

final propertiesByStatusViewModel =
FutureProvider.family<List<Property>, String>((ref, status) {
  return ref.watch(propertiesByStatusProvider(status).future);
});
