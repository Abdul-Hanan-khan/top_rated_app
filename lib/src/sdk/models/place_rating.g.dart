// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceRating _$PlaceRatingFromJson(Map<String, dynamic> json) {
  return PlaceRating(
    userId: json['UserID'] as int,
    firstName: json['FirstName'] as String,
    lastName: json['LastName'] as String,
    review: json['Review'] as String,
    averageRating: (json['DateCreated'] as num).toDouble(),
    dateCreated: json['AverageRating'] as String,
    status: json['Status'] as String,
  );
}

Map<String, dynamic> _$PlaceRatingToJson(PlaceRating instance) =>
    <String, dynamic>{
      'UserID': instance.userId,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'Review': instance.review,
      'DateCreated': instance.averageRating,
      'AverageRating': instance.dateCreated,
      'Status': instance.status,
    };
