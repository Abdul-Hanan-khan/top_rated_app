// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRating _$UserRatingFromJson(Map<String, dynamic> json) {
  return UserRating(
    id: json['RatingID'],
    placeNameEng: json['PlaceEnglish'] as String,
    placeNameAr: json['PlaceArabic'] as String,
    dateCreated: json['DateCreated'] as String,
    review: json['Review'] as String,
    status: json['Status'] as String,
    averageRating: json['AverageRating'],
    totalLikes: json['totalLikes'] as String,
    isLiked: json['isLiked'] as String,
  );
}

Map<String, dynamic> _$UserRatingToJson(UserRating instance) =>
    <String, dynamic>{
      'RatingID': instance.id,
      'PlaceEnglish': instance.placeNameEng,
      'PlaceArabic': instance.placeNameAr,
      'DateCreated': instance.dateCreated,
      'Review': instance.review,
      'Status': instance.status,
      'AverageRating': instance.averageRating,
      'totalLikes': instance.totalLikes,
      'isLiked': instance.isLiked,
    };
