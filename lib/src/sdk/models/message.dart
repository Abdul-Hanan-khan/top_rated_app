import 'package:json_annotation/json_annotation.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  @JsonKey(name: "MessageID")
  String id;
  @JsonKey(name: "MessageTitle")
  String title;
  @JsonKey(name: "Message")
  String body;
  @JsonKey(name: "DateCreated")
  String dateCreated;
  @JsonKey(name: "MessageImage")
  String image;

  @JsonKey(name: "PlaceID")
  dynamic placeId;
  @JsonKey(name: "PlaceEnglish")
  String placeNameEng;
  @JsonKey(name: "PlaceArabic")
  String placeNameAr;
  @JsonKey(name: "PlaceAddress")
  String address;
  @JsonKey(name: "City")
  String city;
  @JsonKey(name: "Image")
  String placeImage;
  @JsonKey(name: "OverallRating")
  dynamic overallRating;
  @JsonKey(name: "CategoryID")
  dynamic categoryId;
  @JsonKey(name: "SubCategoryID")
  dynamic subCategoryId;

  Message(
      {this.id,
      this.title,
      this.body,
      this.dateCreated,
      this.image,
      this.placeId,
      this.placeNameEng,
      this.placeNameAr,
      this.address,
      this.city,
      this.placeImage,
      this.overallRating,
      this.categoryId,
      this.subCategoryId});

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  bool hasPlace() {
    return placeId != null && placeId.toString().compareTo("0") != 0;
  }

  Place getPlace() {
    if (!hasPlace()) return null;
    return Place(
      id: placeId,
      placeNameEng: placeNameEng,
      placeNameAr: placeNameAr,
      address: address,
      city: city,
      image: placeImage,
      overallRating: overallRating,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
    );
  }
}
