import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable()
class Rating {
  @JsonKey(name: "RatingTypeID")
  int ratingId;
  @JsonKey(name: "RateValue")
  double value;

  Rating({
    this.ratingId,
    this.value,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
