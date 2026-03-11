import '../../core/constants/constant_data.dart';
import '../../domain/models/property.dart';
import '../../domain/repositories/property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  @override
  Future<List<Property>> getProperties() async {
    return mockProperties;
  }

  @override
  Future<List<Property>> getFeaturedProperties() async {
    return mockProperties.where((p) => p.isFeatured).toList();
  }
}