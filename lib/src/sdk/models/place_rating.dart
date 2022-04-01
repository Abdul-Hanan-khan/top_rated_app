import 'package:json_annotation/json_annotation.dart';

part 'place_rating.g.dart';

@JsonSerializable()
class PlaceRating {
  @JsonKey(name: "UserID")
  int userId;
  @JsonKey(name: "FirstName")
  String firstName;
  @JsonKey(name: "LastName")
  String lastName;
  @JsonKey(name: "Review")
  String review;
  @JsonKey(name: "DateCreated")
  double averageRating;
  @JsonKey(name: "AverageRating")
  String dateCreated;
  @JsonKey(name: "Status")
  String status;

  PlaceRating(
      {this.userId, this.firstName, this.lastName, this.review, this.averageRating, this.dateCreated, this.status});

  factory PlaceRating.fromJson(Map<String, dynamic> json) => _$PlaceRatingFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceRatingToJson(this);
}
