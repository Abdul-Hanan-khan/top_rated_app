// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return Place(
    id: json['PlaceID'],
    placeNameEng: json['PlaceEnglish'] as String,
    placeNameAr: json['PlaceArabic'] as String,
    address: json['PlaceAddress'] as String,
    city: json['City'] as String,
    image: json['Image'] as String,
    overallRating: json['OverallRating'],
    categoryId: json['CategoryID'],
    subCategoryId: json['SubCategoryID'],
    email: json['Email'] as String,
    status: json['Status'] as String,
    emailStatus: json['EmailStatus'] as String,
  );
}

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'PlaceID': instance.id,
      'PlaceEnglish': instance.placeNameEng,
      'PlaceArabic': instance.placeNameAr,
      'PlaceAddress': instance.address,
      'City': instance.city,
      'Image': instance.image,
      'OverallRating': instance.overallRating,
      'CategoryID': instance.categoryId,
      'SubCategoryID': instance.subCategoryId,
      'Email': instance.email,
      'Status': instance.status,
    };
