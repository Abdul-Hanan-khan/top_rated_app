import 'package:json_annotation/json_annotation.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/extensions/string_extension.dart';
import 'package:top_rated_app/src/sdk/utils/date_utils.dart';

part 'reply.g.dart';

@JsonSerializable()
class Reply {
  // fields go here
  @JsonKey(name: "FirstName")
  String firstName;
  @JsonKey(name: "LastName")
  String lastName;
  @JsonKey(name: "Reply")
  String text;
  @JsonKey(name: "Created_AT")
  String createdAt;

  Reply({
    this.firstName,
    this.lastName,
    this.text,
    this.createdAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyToJson(this);

  String get name {
    return "$firstName $lastName".capitalized();
  }

  String get displayDate {
    final date = DateUtil.getDateFromString(createdAt, AppConstants.apiDateTimeFormat);
    return DateUtil.getFormattedDate(date, AppConstants.appDateFormat);
  }
}
