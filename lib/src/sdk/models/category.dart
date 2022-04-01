import 'package:json_annotation/json_annotation.dart';

import 'sub_category.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  @JsonKey(name: "CategoryID")
  int id;
  @JsonKey(name: "CategoryEnglish")
  String nameEng;
  @JsonKey(name: "CategoryArabic")
  String nameAr;
  @JsonKey(name: "Status")
  dynamic status;
  @JsonKey(name: "Icon")
  String iconPath;
  @JsonKey(name: "SubCategories")
  List<SubCategory> subCategories;

  Category({
    this.id,
    this.nameEng,
    this.nameAr,
    this.status,
    this.iconPath,
    this.subCategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
