// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategory _$SubCategoryFromJson(Map<String, dynamic> json) {
  return SubCategory(
    subId: json['SubCategoryID'] as int,
    nameAr: json['SubCategoryArabic'] as String,
    nameEng: json['SubCategoryEnglish'] as String,
    status: json['Status'],
    iconPath: json['Icon'] as String,
    categoryId: json['CategoryID'] as int,
    cities: (json['Cities'] as List).map((e) => City.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

Map<String, dynamic> _$SubCategoryToJson(SubCategory instance) => <String, dynamic>{
      'SubCategoryID': instance.subId,
      'SubCategoryArabic': instance.nameAr,
      'SubCategoryEnglish': instance.nameEng,
      'Status': instance.status,
      'Icon': instance.iconPath,
      'CategoryID': instance.categoryId,
      'Cities': instance.cities,
    };
