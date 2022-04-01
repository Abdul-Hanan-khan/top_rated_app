// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reply _$ReplyFromJson(Map<String, dynamic> json) {
  return Reply(
    firstName: json['FirstName'] as String,
    lastName: json['LastName'] as String,
    text: json['Reply'] as String,
    createdAt: json['Created_AT'] as String,
  );
}

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'Reply': instance.text,
      'Created_AT': instance.createdAt,
    };
