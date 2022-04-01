// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_partial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingPartial _$RatingPartialFromJson(Map<String, dynamic> json) {
  return RatingPartial(
    id: json['RatingID'],
    userId: json['UserID'],
    firstName: json['FirstName'] as String,
    lastName: json['LastName'] as String,
    review: json['Review'] as String,
    averageRating: json['AverageRating'],
    dateCreated: json['DateCreated'] as String,
    status: json['Status'] as String,
    replies: (json['replies'] as List).map((e) => Reply.fromJson(e as Map<String, dynamic>)).toList(),
    totalLikes: json['totalLikes'] as String,
    isLiked: json['isLiked'] as String,
  );
}

Map<String, dynamic> _$RatingPartialToJson(RatingPartial instance) => <String, dynamic>{
      'RatingID': instance.id,
      'UserID': instance.userId,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'Review': instance.review,
      'AverageRating': instance.averageRating,
      'DateCreated': instance.dateCreated,
      'Status': instance.status,
      'replies': instance.replies,
      'totalLikes': instance.totalLikes,
      'isLiked': instance.isLiked,
    };
