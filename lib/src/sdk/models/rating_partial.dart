import 'package:json_annotation/json_annotation.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/models/reply.dart';
import 'package:top_rated_app/src/sdk/utils/date_utils.dart';
import 'package:top_rated_app/src/sdk/extensions/string_extension.dart';

part 'rating_partial.g.dart';

@JsonSerializable()
class RatingPartial {
  @JsonKey(name: "RatingID")
  dynamic id;
  @JsonKey(name: "UserID")
  dynamic userId;
  @JsonKey(name: "FirstName")
  String firstName;
  @JsonKey(name: "LastName")
  String lastName;
  @JsonKey(name: "Review")
  String review;
  @JsonKey(name: "AverageRating")
  dynamic averageRating;
  @JsonKey(name: "DateCreated")
  String dateCreated;
  @JsonKey(name: "Status")
  String status;
  @JsonKey(name: "replies")
  List<Reply> replies;
  @JsonKey(name: "totalLikes")
  String totalLikes;
  @JsonKey(name: "isLiked")
  String isLiked;

  RatingPartial({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.review,
    this.averageRating,
    this.dateCreated,
    this.status,
    this.replies,
    this.totalLikes,
    this.isLiked,
  });

  factory RatingPartial.fromJson(Map<String, dynamic> json) => _$RatingPartialFromJson(json);

  Map<String, dynamic> toJson() => _$RatingPartialToJson(this);

  String get name {
    return "$firstName $lastName".capitalized();
  }

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
