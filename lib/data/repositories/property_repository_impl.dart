import '../../core/constants/constant_data.dart';
import '../../domain/models/property.dart';
import '../../domain/repositories/property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  @override
  Future<List<Property>> getProperties() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return mockProperties;
  }

  @override
  Future<List<Property>> getFeaturedProperties() async {
    final properties = await getProperties();
    return properties.where((p) => p.isFeatured).toList();
  }
}