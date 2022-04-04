import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:top_rated_app/src/app/app_theme.dart';

class ReplyWidget extends StatelessWidget {
  String replyMessage;
  DateTime replyDate;
  String sender;

  ReplyWidget(this.replyMessage, this.replyDate, this.sender);

  var repCommentCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 1, top: 5, right: 1, bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      replyMessage,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd, kk:mma').format(replyDate).toString(),
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // _getRepliesList(context),
          // GestureDetector(
          //   onTap: (){
          //     sendCommentReply();
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.only(top: 4,left: size.width*0.65),
          //     child: Text('reply'),
          //   ),
          // ),
        ],
      ),
    );
  }

// Widget _getRepliesList(BuildContext context) {
//   DatabaseReference replyCommentRef;
//
//   Size size = MediaQuery.of(context).size;
//   replyCommentRef = FirebaseDatabase.instance
//       .reference()
//       .child('myAlerts')
//       .child('${postID}')
//       .child('comments')
//       .child(commentID)
//       .child('reply');
//   return Container(
//     width: size.width*0.5,
//     height: size.height*0.1,
//     child: FirebaseAnimatedList(
//       // controller: _scrollController,
//       query: replyCommentRef,
//       itemBuilder: (context, snapshot, animation, index) {
//         // if (snapshot != null) {
//         //   WidgetsBinding.instance
//         //       .addPostFrameCallback((_) => _scrollToBottom());
//         // }
//         final json = snapshot.value as Map<dynamic, dynamic>;
//         // print(snapshot.value['body']);
//         // final message = Message.fromJson(json);
//         // return MessageWidget(message.text, message.date);
//         return Text("$index");
//       },
//     ),
//   );
// }

}
