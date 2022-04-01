import 'package:json_annotation/json_annotation.dart';

part 'place_stats.g.dart';

@JsonSerializable()
class PlaceStats {
  // fields go here

  String totalDownloads;
  String totalReviews;
  String categoryReviews;
  String bestRatedPlaces;
  int placeRating;
  String placeReviews;

  PlaceStats({
    this.totalDownloads,
    this.totalReviews,
    this.categoryReviews,
    this.bestRatedPlaces,
    this.placeRating,
    this.placeReviews,
  });

  factory PlaceStats.fromJson(Map<String, dynamic> json) => _$PlaceStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceStatsToJson(this);
}
