// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceStats _$PlaceStatsFromJson(Map<String, dynamic> json) {
  return PlaceStats(
    totalDownloads: json['totalDownloads'] as String,
    totalReviews: json['totalReviews'] as String,
    categoryReviews: json['categoryReviews'] as String,
    bestRatedPlaces: json['bestRatedPlaces'] as String,
    placeRating: json['placeRating'] as int,
    placeReviews: json['placeReviews'] as String,
  );
}

Map<String, dynamic> _$PlaceStatsToJson(PlaceStats instance) => <String, dynamic>{
      'totalDownloads': instance.totalDownloads,
      'totalReviews': instance.totalReviews,
      'categoryReviews': instance.categoryReviews,
      'bestRatedPlaces': instance.bestRatedPlaces,
      'placeRating': instance.placeRating,
      'placeReviews': instance.placeReviews,
    };
