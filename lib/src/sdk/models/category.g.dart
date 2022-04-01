// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    id: json['CategoryID'] as int,
    nameEng: json['CategoryEnglish'] as String,
    nameAr: json['CategoryArabic'] as String,
    status: json['Status'],
    iconPath: json['Icon'] as String,
    subCategories: (json['SubCategories'] as List).map((e) => SubCategory.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'CategoryID': instance.id,
      'CategoryEnglish': instance.nameEng,
      'CategoryArabic': instance.nameAr,
      'Status': instance.status,
      'Icon': instance.iconPath,
      'SubCategories': instance.subCategories,
    };
