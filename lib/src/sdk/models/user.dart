import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "UserID")
  dynamic userId;
  @JsonKey(name: "FirstName")
  String firstName;
  @JsonKey(name: "LastName")
  String lastName;
  @JsonKey(name: "Email")
  String email;
  @JsonKey(name: "Password")
  String password;
  @JsonKey(name: "Status")
  String status;
  @JsonKey(name: "UserImage")
  String path;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.status,
    this.path,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  bool get isAccountActivated {
    return this.status == UserStatus.active;
  }

  bool get isBlocked {
    return this.status == UserStatus.block;
  }

  String get fullName {
    return "$firstName $lastName";
  }

  int get id {
    if (this.userId is String) {
      return int.tryParse(this.userId) ?? 0;
    } else if (this.userId is int) {
      return this.userId as int;
    }
    return -1;
  }
}

abstract class UserStatus {
  static final pending = "Pending";
  static final active = "Active";
  static final block = "Block";
}
