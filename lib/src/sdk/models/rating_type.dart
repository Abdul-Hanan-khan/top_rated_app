import 'package:json_annotation/json_annotation.dart';

part 'rating_type.g.dart';

@JsonSerializable()
class RatingType {
  @JsonKey(name: "RatingTypeID")
  dynamic id;
  @JsonKey(name: "RatingTypeEnglish")
  String nameEng;
  @JsonKey(name: "RatingTypeArabic")
  String nameAr;

  RatingType({
    this.id,
    this.nameEng,
    this.nameAr,
  });

  factory RatingType.fromJson(Map<String, dynamic> json) => _$RatingTypeFromJson(json);

  Map<String, dynamic> toJson() => _$RatingTypeToJson(this);

  int getId() {
    if (this.id is String) {
      return int.tryParse(this.id) ?? 0;
    } else if (this.id is int) {
      return this.id as int;
    }
    return -1;
  }
}
