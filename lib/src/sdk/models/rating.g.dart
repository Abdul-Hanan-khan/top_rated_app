// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) {
  return Rating(
    ratingId: json['RatingTypeID'] as int,
    value: (json['RateValue'] as num).toDouble(),
  );
}

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'RatingTypeID': instance.ratingId,
      'RateValue': instance.value,
    };
