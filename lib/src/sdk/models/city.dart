import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  // fields go here
  @JsonKey(name: "CityID")
  String id;
  @JsonKey(name: "City")
  String name;

  City({this.id, this.name});

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);
}
