// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    id: json['MessageID'] as String,
    title: json['MessageTitle'] as String,
    body: json['Message'] as String,
    dateCreated: json['DateCreated'] as String,
    image: json['MessageImage'] as String,
    placeId: json['PlaceID'],
    placeNameEng: json['PlaceEnglish'] as String,
    placeNameAr: json['PlaceArabic'] as String,
    address: json['PlaceAddress'] as String,
    city: json['City'] as String,
    placeImage: json['Image'] as String,
    overallRating: json['OverallRating'],
    categoryId: json['CategoryID'],
    subCategoryId: json['SubCategoryID'],
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'MessageID': instance.id,
      'MessageTitle': instance.title,
      'Message': instance.body,
      'DateCreated': instance.dateCreated,
      'PlaceID': instance.placeId,
      'PlaceEnglish': instance.placeNameEng,
      'PlaceArabic': instance.placeNameAr,
      'PlaceAddress': instance.address,
      'City': instance.city,
      'Image': instance.placeImage,
      'OverallRating': instance.overallRating,
      'CategoryID': instance.categoryId,
      'SubCategoryID': instance.subCategoryId,
    };
