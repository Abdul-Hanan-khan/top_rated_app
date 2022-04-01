import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/app/app_theme.dart';
import 'package:top_rated_app/src/app_widgets/message_widget.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/widget_utils.dart';

class CommentSection extends StatelessWidget {
  String postId;

  CommentSection(this.postId);

  var commentCtr = TextEditingController();
  var repCommentCtr = TextEditingController();
  DatabaseReference commentRef;
  final user = AuthManager.instance.user;

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(backgroundColor: Colors.grey[400],
        //   title: Text('Comments'.tr()),
        // ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              ///all comments
              Expanded(child: _getMessageList(context)),



              /// send message
              Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: commentCtr,
                        decoration: InputDecoration(
                            hintText: "Write comment...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {

                        if (commentCtr.text.trim() == '' ||
                            commentCtr.text.trim().isEmpty ||
                            commentCtr.text.trim() == null) {}
                        setPostRef();
                        // sendCommentMessage();
                        // setPostRef();
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: AppColor.secondaryDark,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  sendCommentMessage() {
    commentRef = FirebaseDatabase.instance
        .reference()
        .child('myAlerts')
        .child('post-$postId')
        .child('comments');
    try {
      String commentId = commentRef.push().key;
      commentRef.child(commentId).set({
        'postId':"post-$postId",
        'dateTime': '${DateTime.now()}',
        'body': '${commentCtr.text.tr()}',
        'commentId': '$commentId',
        'sender':'${user.firstName+" "+user.lastName}'
      });

      commentCtr.clear();
    } on Exception catch (_) {
      print('Failed to comment');
    }
    // commentRef.key;
  }
  Future setPostRef()async{
    commentRef = FirebaseDatabase.instance
        .reference()
        .child('myAlerts')
        .child('post-$postId');
    commentRef.update({
      'postId':"$postId"
    }).then((value) {
      sendCommentMessage();
    });
  }


  Widget _getMessageList(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    commentRef = FirebaseDatabase.instance
        .reference()
        .child('myAlerts')
        .child('post-$postId')
        .child('comments');
    return FirebaseAnimatedList(
      shrinkWrap: true,
      // controller: _scrollController,
      query: commentRef,
       itemBuilder: (context, snapshot, animation, index) {
        if (snapshot != null) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToBottom());
        }
        final json = snapshot.value as Map<dynamic, dynamic>;
        print(snapshot.value['body']);
        // final message = Message.fromJson(json);
        // return MessageWidget(message.text, message.date);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 5),
              child: MessageWidget(
                commentMessage: snapshot.value['body'],
                postID: postId,
                sender: snapshot.value['sender'],
                commentID: snapshot.value['commentId'],
                date: DateTime.parse(snapshot.value['dateTime']),
              ),
            ),
          ],
        );
      },
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
