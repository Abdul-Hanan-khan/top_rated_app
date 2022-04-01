import 'package:json_annotation/json_annotation.dart';
import 'package:top_rated_app/src/sdk/models/rating.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  @JsonKey(name: "PlaceID")
  int placeId;
  @JsonKey(name: "UserID")
  int userId;
  @JsonKey(name: "Review")
  String review;
  @JsonKey(name: "UserRating")
  List<Rating> userRating;

  Review({this.placeId, this.userId, this.review, this.userRating});

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
