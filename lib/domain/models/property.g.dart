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
  type: $enumDecode(_$PropertyTypeEnumMap, json['type']),
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
  'type': _$PropertyTypeEnumMap[instance.type]!,
  'beds': instance.beds,
  'baths': instance.baths,
  'sqft': instance.sqft,
  'imageUrl': instance.imageUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'isFeatured': instance.isFeatured,
};

const _$PropertyTypeEnumMap = {
  PropertyType.apartment: 'apartment',
  PropertyType.villa: 'villa',
  PropertyType.studio: 'studio',
  PropertyType.office: 'office',
  PropertyType.townhouse: 'townhouse',
};
