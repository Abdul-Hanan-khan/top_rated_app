// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return Review(
    placeId: json['PlaceID'] as int,
    userId: json['UserID'] as int,
    review: json['Review'] as String,
    userRating: (json['UserRating'] as List).map((e) => Rating.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'PlaceID': instance.placeId,
      'UserID': instance.userId,
      'Review': instance.review,
      'UserRating': instance.userRating,
    };
