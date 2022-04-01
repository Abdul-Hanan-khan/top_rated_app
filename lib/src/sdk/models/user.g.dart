// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    userId: json['UserID'],
    firstName: json['FirstName'] as String,
    lastName: json['LastName'] as String,
    email: json['Email'] as String,
    password: json['Password'] as String,
    status: json['Status'] as String,
    path: json['UserImage'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'UserID': instance.userId,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'Email': instance.email,
      'Password': instance.password,
      'Status': instance.status,
      'UserImage': instance.path,
    };
