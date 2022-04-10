import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_rated_app/src/sdk/models/alerts_model_firebase.dart';

class MyDatabaseController extends GetxController {
  DatabaseReference reference;
  DatabaseReference firestoreRef;
  RxBool isLoading = false.obs;
  RxList<AlertPost> allPosts = <AlertPost>[].obs;
  RxList<Comment> postComments = <Comment>[].obs;

  List<Comment> dummyComments = <Comment>[].obs;
  List<AlertPost> dummyAlertPost=<AlertPost>[];






  Future getPostData() async {
    allPosts.clear();
    isLoading.value = true;

    var databaserRef = FirebaseDatabase.instance.reference().child('myAlerts');
    databaserRef.onValue.listen((event) {
      Map commData = event.snapshot.value;

      allPosts.clear();
    if(commData != null){
      commData.entries.forEach((element) {
        allPosts.add(AlertPost.fromJson(Map<String, dynamic>.from(element.value)));
      });
    }
      print(allPosts);
    });
  }


  /// get all comments backup
  //
  // Future getCommentsData() async {
  //   dummyComments.clear();
  //   isLoading.value = true;
  //
  //   var databaserRef = FirebaseDatabase.instance
  //       .reference()
  //       .child('myAlerts')
  //       .child('post-81')
  //       .child('comments');
  //   databaserRef.onValue.listen((event) {
  //     Map commData = event.snapshot.value;
  //     List myList = [];
  //     commData.length;
  //
  //     commData.entries.forEach((element) {
  //       dummyComments
  //           .add(Comment.fromJson(Map<String, dynamic>.from(element.value)));
  //     });
  //     print(dummyComments[0].reply[0].body);
  //   });
  // }

  // addCommentToFirestore() {
  //   try {
  //     var addCommentRef = FirebaseFirestore.instance
  //         .collection('myAlerts')
  //         .doc('post-80')
  //         .collection('comments')
  //         .doc();
  //     String commentId = addCommentRef.id;
  //     addCommentRef.set({
  //       'body': 'asfdsfsd',
  //       'commentID': '$commentId',
  //       'dateTime': 'asfdsfsd',
  //       'sender': 'asfdsfsd',
  //     });
  //   } catch (e) {
  //     print("Firestore Exception raised add comment = $e");
  //   }
  // }

  // addReplyToFirestore() {
  //   try {
  //     var replyRef = FirebaseFirestore.instance
  //         .collection('myAlerts')
  //         .doc('post-80')
  //         .collection('comments')
  //         .doc("nfaXDd27PEfBxKe5CUgC")
  //         .collection('reply')
  //         .doc();
  //     String replyId = replyRef.id;
  //     replyRef.set({
  //       'reply': 'asfdsfsd',
  //       'replyId': '$replyId',
  //       'dateTime': 'asfdsfsd',
  //       'sender': 'asfdsfsd',
  //     });
  //   } catch (e) {
  //     print("Firestore Exception raised on add reply = $e");
  //   }
  // }

  getAllLikes() {
    Comment replyModel;
    try {
      CollectionReference reference = FirebaseFirestore.instance
          .collection('myAlerts')
          .doc('post-80')
          .collection('comments');
      reference.snapshots().listen((querySnapshot) {
        dummyComments.clear();
        querySnapshot.docChanges.forEach((change) {
          var data = change.doc;
          replyModel =
              Comment.fromJson(Map<String, dynamic>.from(change.doc.data()));
          dummyComments.add(replyModel);
        });
        for (int i = 0; i < dummyComments.length; i++) {
          print(dummyComments[i].sender);
        }
        print(dummyComments);
        print(replyModel.sender);
        // List rawList=replyModel;
      });
    } catch (e) {
      print("Exception on Firestore get = $e");
    }
  }
}
