import 'package:freezed_annotation/freezed_annotation.dart';

part 'property.freezed.dart';
part 'property.g.dart';

enum PropertyType {
  apartment,
  villa,
  studio,
  office,
  townhouse,
}

@freezed
abstract class Property with _$Property {
  const factory Property({
    required String id,
    required String title,
    required String location,
    required String price,
    required String status,
    required PropertyType type,
    required int beds,
    required int baths,
    required int sqft,
    required String imageUrl,
    required DateTime createdAt,
    @Default(false) bool isFeatured,
  }) = _Property;

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
}