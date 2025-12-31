// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Property _$PropertyFromJson(Map<String, dynamic> json) => _Property(
  id: json['id'] as String,
  title: json['title'] as String,
  location: json['location'] as String,
  price: json['price'] as String,
  status: json['status'] as String,
  beds: (json['beds'] as num).toInt(),
  baths: (json['baths'] as num).toInt(),
  sqft: (json['sqft'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isFeatured: json['isFeatured'] as bool? ?? false,
);

Map<String, dynamic> _$PropertyToJson(_Property instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'location': instance.location,
  'price': instance.price,
  'status': instance.status,
  'beds': instance.beds,
  'baths': instance.baths,
  'sqft': instance.sqft,
  'imageUrl': instance.imageUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'isFeatured': instance.isFeatured,
};
