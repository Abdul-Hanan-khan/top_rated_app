import 'package:get/get.dart';

class AlertModel {
  List<AlertPost> myAlerts;
  AlertModel({this.myAlerts});

  AlertModel.fromJson(Map<String, dynamic> json) {
    if (json['myAlerts'] != null) {
      myAlerts = <AlertPost>[];
      json['myAlerts'].forEach((v) {
        myAlerts.add(new AlertPost.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.myAlerts != null) {
      data['myAlerts'] = this.myAlerts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AlertPost {
  RxList<Comment> comment=<Comment>[].obs;
  RxList<Like> like=<Like>[].obs;
  String postID;

  AlertPost({this.comment, this.like,this.postID});

  AlertPost.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comment.value = <Comment>[];
      Map cmts=json['comments'];
      cmts.entries.forEach((element) {
        comment.value.add(Comment.fromJson(Map<String, dynamic>.from(element.value)));
      });
      // json['comment'].forEach((v) {
      //   comment.add(new Comment.fromJson(v));
      // });
    }
    if (json['likes'] != null) {
      like.value = <Like>[];
      Map lks=json['likes'];
      lks.entries.forEach((element) {
        like.value.add(Like.fromJson(Map<String, dynamic>.from(element.value)));
      });

      // json['like'].forEach((v) {
      //   like.add(new Like.fromJson(v));
      // });
    }
    postID= json['postId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comment != null) {
      data['comment'] = this.comment.value.map((v) => v.toJson()).toList();
    }
    if (this.like != null) {
      data['like'] = this.like.value.map((v) => v.toJson()).toList();
    }
    data['postId']=this.postID;
    return data;
  }
}

class Comment {
  String body;
  String postId;
  String commentID;
  String dateTime;
  RxList<Reply> reply=<Reply>[].obs;
  String sender;

  Comment({this.body,this.postId, this.commentID, this.dateTime, this.reply, this.sender});

  Comment.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    postId=json['postId'];
    commentID = json['commentId'];
    dateTime = json['dateTime'];
    if (json['reply'] != null) {
      reply.value = <Reply>[];
      Map rep=json['reply'];
      rep.entries.forEach((element) {
        reply.value.add(Reply.fromJson(Map<String, dynamic>.from(element.value)));
      });
      // json['reply'].forEach((v)
      // {
      //   reply.add(new Reply.fromJson(v));
      // });
    }
    sender = json['sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['postId']=this.postId;
    data['commentId'] = this.commentID;
    data['dateTime'] = this.dateTime;
    if (this.reply != null) {
      data['reply'] = this.reply.value.map((v) => v.toJson()).toList();
    }
    data['sender'] = this.sender;
    return data;
  }
}

class Reply {
  String replyId;
  String body;
  String dateTime;
  String sender;

  Reply({this.replyId, this.body, this.dateTime, this.sender});

  Reply.fromJson(Map<String, dynamic> json) {
    replyId = json['replyId'];
    body = json['body'];
    dateTime = json['dateTime'];
    sender = json['sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['replyId'] = this.replyId;
    data['body'] = this.body;
    data['dateTime'] = this.dateTime;
    data['sender'] = this.sender;
    return data;
  }
}

class Like {
  String likeStatus;
  String notificationId;
  String userId;

  Like({this.likeStatus, this.notificationId, this.userId});

  Like.fromJson(Map<String, dynamic> json) {
    likeStatus = json['likeStatus'];
    notificationId = json['notificationId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['likeStatus'] = this.likeStatus;
    data['notificationId'] = this.notificationId;
    data['userId'] = this.userId;
    return data;
  }
}