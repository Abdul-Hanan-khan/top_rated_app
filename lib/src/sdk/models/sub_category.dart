import 'package:json_annotation/json_annotation.dart';

import 'city.dart';

part 'sub_category.g.dart';

@JsonSerializable()
class SubCategory {
  @JsonKey(name: "SubCategoryID")
  int subId;
  @JsonKey(name: "SubCategoryArabic")
  String nameAr;
  @JsonKey(name: "SubCategoryEnglish")
  String nameEng;
  @JsonKey(name: "Status")
  dynamic status;
  @JsonKey(name: "Icon")
  String iconPath;
  @JsonKey(name: "CategoryID")
  int categoryId;
  @JsonKey(name: "Cities")
  List<City> cities;

  SubCategory({
    this.subId,
    this.nameAr,
    this.nameEng,
    this.status,
    this.iconPath,
    this.categoryId,
    this.cities,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => _$SubCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryToJson(this);
}
