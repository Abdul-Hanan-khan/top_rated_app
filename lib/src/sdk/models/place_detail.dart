import 'package:json_annotation/json_annotation.dart';
import 'package:top_rated_app/src/sdk/models/place_image.dart';
import 'package:top_rated_app/src/sdk/models/rating_partial.dart';

import 'average_rating.dart';

part 'place_detail.g.dart';

@JsonSerializable()
class PlaceDetail {
  @JsonKey(name: "PlaceWebsite")
  String website;
  @JsonKey(name: "PlaceLocation")
  String location;
  @JsonKey(name: "PlaceAddress")
  String address;
  @JsonKey(name: "Phone")
  String phone;
  @JsonKey(name: "Status")
  String status;
  @JsonKey(name: "PlaceBio")
  String bio;
  @JsonKey(name: "OverallRating")
  dynamic overallRating;
  @JsonKey(name: "RatingCount")
  int reviewCount;
  @JsonKey(name: "AverageRating")
  List<AverageRating> averageRatings = [];
  @JsonKey(name: "Ratings")
  List<RatingPartial> ratings = [];
  @JsonKey(name: "Images")
  List<PlaceImage> images = [];
  @JsonKey(name: "isFavourite")
  int isFavourite;

  PlaceDetail({
    this.website,
    this.location,
    this.phone,
    this.status,
    this.bio,
    this.overallRating,
    this.reviewCount,
    this.averageRatings,
    this.ratings,
    this.images,
    this.address,
    this.isFavourite,
  });

  factory PlaceDetail.fromJson(Map<String, dynamic> json) => _$PlaceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDetailToJson(this);

  double getOverallRating() {
    if (this.overallRating == null) return 0;
    if (this.overallRating is String) {
      return double.tryParse(this.overallRating) ?? 0;
    } else if (this.overallRating is double) {
      return this.overallRating as double;
    }
    return 0;
  }
}
