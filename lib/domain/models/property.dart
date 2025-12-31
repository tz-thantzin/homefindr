import 'package:freezed_annotation/freezed_annotation.dart';

part 'property.freezed.dart';
part 'property.g.dart';

@freezed
abstract class Property with _$Property {
  const factory Property({
    required String id,
    required String title,
    required String location, // Address or neighborhood
    required String price,
    required String status, // "For Rent" or "For Sale"
    required int beds,
    required int baths,
    required int sqft,
    required String imageUrl,
    required DateTime createdAt,
    @Default(false) bool isFeatured,
  }) = _Property;

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
}