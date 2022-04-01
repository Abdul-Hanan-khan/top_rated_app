// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'average_rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AverageRating _$AverageRatingFromJson(Map<String, dynamic> json) {
  return AverageRating(
    nameArabic: json['RatingTypeArabic'] as String,
    nameEnglish: json['RatingTypeEnglish'] as String,
    averageRating: json['AverageRating'],
  );
}

Map<String, dynamic> _$AverageRatingToJson(AverageRating instance) =>
    <String, dynamic>{
      'RatingTypeArabic': instance.nameArabic,
      'RatingTypeEnglish': instance.nameEnglish,
      'AverageRating': instance.averageRating,
    };
