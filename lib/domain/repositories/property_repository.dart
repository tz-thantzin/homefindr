
import '../models/property.dart';

abstract class PropertyRepository {
  Future<List<Property>> getProperties();
  Future<List<Property>> getFeaturedProperties();
}