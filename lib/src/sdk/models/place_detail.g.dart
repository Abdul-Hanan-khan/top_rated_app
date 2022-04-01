// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceDetail _$PlaceDetailFromJson(Map<String, dynamic> json) {
  return PlaceDetail(
    website: json['PlaceWebsite'] as String,
    location: json['PlaceLocation'] as String,
    phone: json['Phone'] as String,
    status: json['Status'] as String,
    bio: json['PlaceBio'] as String,
    overallRating: json['OverallRating'],
    reviewCount: json['RatingCount'] as int,
    isFavourite: json['isFavourite'] as int,
    averageRatings: (json['AverageRating'] as List)
        .map<AverageRating>((e) => AverageRating.fromJson(e as Map<String, dynamic>))
        .toList(),
    ratings:
        (json['Ratings'] as List).map<RatingPartial>((e) => RatingPartial.fromJson(e as Map<String, dynamic>)).toList(),
    images: (json['Images'] as List).map((e) => PlaceImage.fromJson(e as Map<String, dynamic>)).toList(),
    address: json['PlaceAddress'] as String,
  );
}

Map<String, dynamic> _$PlaceDetailToJson(PlaceDetail instance) => <String, dynamic>{
      'PlaceWebsite': instance.website,
      'PlaceLocation': instance.location,
      'PlaceAddress': instance.address,
      'Phone': instance.phone,
      'Status': instance.status,
      'PlaceBio': instance.bio,
      'OverallRating': instance.overallRating,
      'RatingCount': instance.reviewCount,
      'AverageRating': instance.averageRatings,
      'Ratings': instance.ratings,
      'Images': instance.images,
    };
