import 'package:json_annotation/json_annotation.dart';

part 'user_detail.g.dart';

@JsonSerializable()
class UserDetail {
  @JsonKey(name: "UserAddress")
  String address;
  @JsonKey(name: "UserGender")
  String gender;
  @JsonKey(name: "UserPhone")
  String phone;
  @JsonKey(name: "UserBirthdate")
  String birthdate;
  @JsonKey(name: "totalFollowers")
  int followersCount;
  @JsonKey(name: "totalFollowing")
  int followingCount;
  @JsonKey(name: "isFollowing")
  int isFollowing;

  UserDetail({
    this.address,
    this.gender,
    this.phone,
    this.birthdate,
    this.followersCount,
    this.followingCount,
    this.isFollowing,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => _$UserDetailFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailToJson(this);
}
