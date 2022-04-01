import 'package:json_annotation/json_annotation.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/models/reply.dart';
import 'package:top_rated_app/src/sdk/utils/date_utils.dart';

part 'user_rating.g.dart';

@JsonSerializable()
class UserRating {
  @JsonKey(name: "RatingID")
  dynamic id;
  @JsonKey(name: "PlaceEnglish")
  String placeNameEng;
  @JsonKey(name: "PlaceArabic")
  String placeNameAr;
  @JsonKey(name: "DateCreated")
  String dateCreated;
  @JsonKey(name: "Review")
  String review;
  @JsonKey(name: "Status")
  String status;
  @JsonKey(name: "AverageRating")
  dynamic averageRating;
  // @JsonKey(name: "replies")
  // List<Reply> replies;
  @JsonKey(name: "totalLikes")
  String totalLikes;
  @JsonKey(name: "isLiked")
  String isLiked;

  UserRating({
    this.id,
    this.placeNameEng,
    this.placeNameAr,
    this.dateCreated,
    this.review,
    this.status,
    this.averageRating,
    // this.replies,
    this.totalLikes,
    this.isLiked,
  });

  factory UserRating.fromJson(Map<String, dynamic> json) => _$UserRatingFromJson(json);

  Map<String, dynamic> toJson() => _$UserRatingToJson(this);

  String get displayDate {
    final date = DateUtil.getDateFromString(dateCreated, AppConstants.apiDateTimeFormat);
    return DateUtil.getFormattedDate(date, AppConstants.appDateFormat);
  }

  double getAverageRating() {
    if (this.averageRating == null) return 0;
    if (this.averageRating is String) {
      return double.tryParse(this.averageRating) ?? 0;
    } else if (this.averageRating is double) {
      return this.averageRating as double;
    }
    return 0;
  }

  int getId() {
    if (this.id is String) {
      return int.tryParse(this.id) ?? 0;
    } else if (this.id is int) {
      return this.id as int;
    }
    return -1;
  }
}
