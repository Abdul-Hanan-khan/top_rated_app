import 'package:firebase_database/firebase_database.dart';

class Likes {
   String likeStatus;
   String notificationId;
   String userId;


  Likes(
    this.likeStatus,
    this.notificationId,
    this.userId,
  );

  Likes.fromJson(Map<dynamic, dynamic> json) {
    likeStatus = json['likeStatus'];
    notificationId = json['notificationId'];
    userId = json['userId'];
  }


   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};
     data['likeStatus'] = likeStatus;
     data['notificationId'] = notificationId;
     data['userId'] = userId;




}
}