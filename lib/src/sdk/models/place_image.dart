import 'package:json_annotation/json_annotation.dart';

part 'place_image.g.dart';

@JsonSerializable()
class PlaceImage {
  @JsonKey(name: "Image")
  String imagePath;

  PlaceImage({
    this.imagePath,
  });

  factory PlaceImage.fromJson(Map<String, dynamic> json) => _$PlaceImageFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceImageToJson(this);
}
