// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingType _$RatingTypeFromJson(Map<String, dynamic> json) {
  return RatingType(
    id: json['RatingTypeID'],
    nameEng: json['RatingTypeEnglish'] as String,
    nameAr: json['RatingTypeArabic'] as String,
  );
}

Map<String, dynamic> _$RatingTypeToJson(RatingType instance) =>
    <String, dynamic>{
      'RatingTypeID': instance.id,
      'RatingTypeEnglish': instance.nameEng,
      'RatingTypeArabic': instance.nameAr,
    };
