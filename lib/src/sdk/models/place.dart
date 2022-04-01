import 'package:json_annotation/json_annotation.dart';
import 'package:top_rated_app/src/sdk/models/user.dart';

part 'place.g.dart';

@JsonSerializable()
class Place {
  @JsonKey(name: "PlaceID")
  dynamic id;
  @JsonKey(name: "PlaceEnglish")
  String placeNameEng;
  @JsonKey(name: "PlaceArabic")
  String placeNameAr;
  @JsonKey(name: "PlaceAddress")
  String address;
  @JsonKey(name: "City")
  String city;
  @JsonKey(name: "Image")
  String image;
  @JsonKey(name: "OverallRating")
  dynamic overallRating;
  @JsonKey(name: "CategoryID")
  dynamic categoryId;
  @JsonKey(name: "SubCategoryID")
  dynamic subCategoryId;
  @JsonKey(name: "Email")
  String email;
  @JsonKey(name: "Status")
  String status;
  @JsonKey(name: "EmailStatus")
  String emailStatus;

  Place({
    this.id,
    this.placeNameEng,
    this.placeNameAr,
    this.address,
    this.city,
    this.image,
    this.overallRating,
    this.categoryId,
    this.subCategoryId,
    this.email,
    this.status,
    this.emailStatus,
  });

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceToJson(this);

  int getId() {
    if (this.id is String) {
      return int.tryParse(this.id) ?? 0;
    } else if (this.id is int) {
      return this.id as int;
    }
    return -1;
  }

  double getOverallrating() {
    if (this.overallRating is String) {
      return double.tryParse(this.overallRating) ?? 0;
    } else if (this.overallRating is double) {
      return this.overallRating as double;
    }
    return 0;
  }

  bool get isAccountActivated {
    return this.status == UserStatus.active;
  }
}
