import 'package:json_annotation/json_annotation.dart';

part 'average_rating.g.dart';

@JsonSerializable()
class AverageRating {
  @JsonKey(name: "RatingTypeArabic")
  String nameArabic;
  @JsonKey(name: "RatingTypeEnglish")
  String nameEnglish;
  @JsonKey(name: "AverageRating")
  dynamic averageRating;

  AverageRating({
    this.nameArabic,
    this.nameEnglish,
    this.averageRating,
  });

  factory AverageRating.fromJson(Map<String, dynamic> json) => _$AverageRatingFromJson(json);

  Map<String, dynamic> toJson() => _$AverageRatingToJson(this);

  double getAverageRating() {
    if (this.averageRating == null) return 0;
    if (this.averageRating is String) {
      return double.tryParse(this.averageRating) ?? 0;
    } else if (this.averageRating is double) {
      return this.averageRating as double;
    }
    return 0;
  }
}
