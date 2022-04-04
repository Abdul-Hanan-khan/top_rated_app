import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/app/app_theme.dart';
import 'package:top_rated_app/src/app_widgets/reply_widget.dart';
// import 'package:get/get.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';

class MessageWidget extends StatelessWidget {
  final String commentMessage;
  final String postID;
  final String sender;
  final String commentID;
  final DateTime date;

  MessageWidget(
      {@required this.commentMessage,
      @required this.postID,
      @required this.sender,
      @required this.commentID,
      @required this.date});

  var repCommentCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = AuthManager.instance.user;
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 1, top: 5, right: 1, bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            width: size.width * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          sender == " " ? "Top Rated User" : sender,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent),
                        ),
                      ),
                      Container(
                        // width: size.width * 0.65,
                        child: GestureDetector(
                          onTap: () {
                            _showReplyDialog(context);
                            // showBottomSheet(context, postID, commentMessage,
                            //     user.firstName + " " + user.lastName);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 4, left: 4),
                            child: Text(
                              'Reply',
                              style:
                              TextStyle(fontSize: 15, color: Colors.orangeAccent),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 0, right: 0),
                    child: Text(
                      commentMessage,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd, kk:mma')
                            .format(date)
                            .toString(),
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _getRepliesList(context),
        ],
      ),
    );
  }

  Widget _getRepliesList(BuildContext context) {
    DatabaseReference replyCommentRef;
    replyCommentRef = FirebaseDatabase.instance
        .reference()
        .child('myAlerts')
        .child('post-$postID')
        .child('comments')
        .child(commentID)
        .child('reply');
    return Container(
      // height: 200,
      // width: double.infinity,
      // color: Colors.white,
      child: FirebaseAnimatedList(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        query: replyCommentRef,
        itemBuilder: (context, snapshot, animation, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 39, right: 39),
            child: ReplyWidget(
                snapshot.value['body'],
                DateTime.parse(snapshot.value['dateTime']),
                snapshot.value['sender']),
          );
        },
      ),
    );
  }
  //
  // Widget showBottomSheet(BuildContext context1, String postIdForReply,
  //     String commentToReply, String sender) {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topRight: Radius.circular(10), topLeft: Radius.circular(10))),
  //     context: context1,
  //     builder: (context) {
  //       return Form(
  //         key: key,
  //         child: SingleChildScrollView(
  //           child: AnimatedPadding(
  //               padding: MediaQuery.of(context).viewInsets,
  //               duration: const Duration(milliseconds: 100),
  //               curve: Curves.decelerate,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Row(
  //                     mainAxisSize: MainAxisSize.max,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         'Replying on :   ',
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold, fontSize: 14),
  //                       ),
  //                       Text('${commentToReply}'),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 100,
  //                   ),
  //                   Container(
  //                     padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
  //                     height: 60,
  //                     width: double.infinity,
  //                     color: Colors.white,
  //                     child: Row(
  //                       children: <Widget>[
  //                         SizedBox(
  //                           width: 15,
  //                         ),
  //                         Expanded(
  //                           child: TextField(
  //                             controller: repCommentCtr,
  //                             decoration: InputDecoration(
  //                                 hintText: "Write reply...",
  //                                 hintStyle: TextStyle(color: Colors.black54),
  //                                 border: InputBorder.none),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 15,
  //                         ),
  //                         FloatingActionButton(
  //                           onPressed: () {
  //                             if (repCommentCtr.text.trim() == '' ||
  //                                 repCommentCtr.text.trim().isEmpty ||
  //                                 repCommentCtr.text.trim() == null) {}
  //                             sendReplyCommentMessage(
  //                                 context, postIdForReply, sender);
  //                           },
  //                           child: Icon(
  //                             Icons.send,
  //                             color: Colors.white,
  //                             size: 18,
  //                           ),
  //                           backgroundColor: AppColor.secondaryDark,
  //                           elevation: 0,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 20,
  //                   )
  //                 ],
  //               )),
  //         ),
  //       );
  //     },
  //   );
  // }


  _showReplyDialog(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // _replyController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: Dimens.margin, right: Dimens.margin, top: Dimens.margin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reply".tr(),
                      style: theme.textTheme.headline6.copyWith(color: theme.accentColor),
                    ),
                    Spacing.vMedium,
                    TextField(
                      maxLines: 3,
                      controller: repCommentCtr,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.vMedium,
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      // popPage(context);
                      final text = repCommentCtr.text.trim();
                      if (text.isNotEmpty) {
                        sendReplyCommentMessage(context, postID, sender);

                        // bloc.reply(rating.getId(), text);
                      }
                    },
                    child: Text(
                      "Send".tr(),
                      style: theme.textTheme.subtitle1.copyWith(color: theme.primaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      popPage(context);
                    },
                    child: Text(
                      "Cancel".tr(),
                      style: theme.textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }



  sendReplyCommentMessage(
      BuildContext context, String postIdForReply, String sender) {
    DatabaseReference replyCommentRef;
    replyCommentRef = FirebaseDatabase.instance
        .reference()
        .child('myAlerts')
        .child('post-$postID')
        .child('comments')
        .child(commentID)
        .child('reply');
    try {
      String replyId = replyCommentRef.push().key;
      replyCommentRef.child(replyId).set({
        'dateTime': '${DateTime.now()}',
        'body': '${repCommentCtr.text.trim()}',
        'replyId': '${replyId}',
        'sender': '$sender',
      });


      repCommentCtr.clear();
      Navigator.pop(context);
    } on Exception catch (_) {
      print('Failed to reply');
    }

    // commentRef.key;
  }
}
