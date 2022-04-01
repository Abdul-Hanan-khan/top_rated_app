// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetail _$UserDetailFromJson(Map<String, dynamic> json) {
  return UserDetail(
    address: json['UserAddress'] as String,
    gender: json['UserGender'] as String,
    phone: json['UserPhone'] as String,
    birthdate: json['UserBirthdate'] as String,
    followersCount: json['totalFollowers'] as int,
    followingCount: json['totalFollowing'] as int,
    isFollowing: json['isFollowing'] as int,
  );
}

Map<String, dynamic> _$UserDetailToJson(UserDetail instance) =>
    <String, dynamic>{
      'UserAddress': instance.address,
      'UserGender': instance.gender,
      'UserPhone': instance.phone,
      'UserBirthdate': instance.birthdate,
      'totalFollowers': instance.followersCount,
      'totalFollowing': instance.followingCount,
      'isFollowing': instance.isFollowing,
    };
