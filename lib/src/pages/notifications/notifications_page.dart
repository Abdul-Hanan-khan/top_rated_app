import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_rated_app/dummy/controller/get_data_fb.dart';
import 'package:top_rated_app/src/app/app_bloc.dart';
import 'package:top_rated_app/src/app/app_theme.dart';
import 'package:top_rated_app/src/app_widgets/bounce_anim.dart';
import 'package:top_rated_app/src/app_widgets/message_widget.dart';
import 'package:top_rated_app/src/pages/comment/comment.dart';
import 'package:top_rated_app/src/pages/likes/db_service.dart';
import 'package:top_rated_app/src/pages/notifications/notifications_bloc.dart';
import 'package:top_rated_app/src/pages/vendor_detail/vendor_detail_page.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/models/alerts_model_firebase.dart';
import 'package:top_rated_app/src/sdk/models/likes.dart';
import 'package:top_rated_app/src/sdk/models/message.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:get/get.dart' hide Trans;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => new _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  MyDatabaseController dbController = Get.find();
  ThemeData theme;
  List<Likes> allLikes;
  BuildContext _context;
  NotificationsBloc bloc;

  String totalComments;
  RxInt totalLikes = 0.obs;
  // RxString likeStatus = '0'.obs;


  // CollectionReference ref = FirebaseFirestore.instance.collection("Users");
  DatabaseReference likesRef;
  final user = AuthManager.instance.user;

  @override
  void initState() {
    super.initState();

    // dbController.getData().then((value) {
    //
    // });
    // getAllLikes();
    bloc = new NotificationsBloc();
    bloc.error.listen((event) {
      UIUtils.showAdaptiveDialog(_context, "Error", event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("widget build");
    theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Stack(
        children: [
          Builder(
            builder: (context) {
              _context = context;
              return RefreshIndicator(
                  onRefresh: () async {
                    bloc.fetchNotifications();
                  },
                  child: _buildBody(context));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    RxBool likeStatus=false.obs;
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<List<Message>>(
        stream: bloc.notifications,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? !snapshot.hasError
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox()
              : snapshot.data.length == 0
                  ? Center(child: Text("No Notifications".tr()))
                  : ListView.builder(
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.all(Dimens.margin),
                      itemBuilder: (context, index) {
                        final notification = snapshot.data[index];
                        RxInt currentPostIndex = 0.obs;
                        currentPostIndex.value = dbController.allPosts
                            .indexWhere(
                                (element) => element.postID == notification.id);

                        dbController.allPosts[currentPostIndex.value].like.forEach((element) {
                          print(user.userId);
                          if(element.userId == user.userId.toString()){
                            likeStatus.value=true;
                          }
                        });



                        return Stack(
                          children: [
                            // getTestAllLikes(),
                            // _getMessageList(context, notification.id),
                            Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: Dimens.margin_medium),
                              color: theme.colorScheme.surface,
                              elevation: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(Dimens.margin_xmedium),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (notification.image != null &&
                                            notification.image.isNotEmpty)
                                        ? Image.network(
                                            "${AppConstants.imageMessageBaseUrl}${notification.image}",
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : SizedBox(),
                                    Spacing.vertical,
                                    ((notification.title != null &&
                                                notification
                                                    .title.isNotEmpty) ||
                                            notification.hasPlace())
                                        ? GestureDetector(
                                            onTap: () {
                                              if (notification.hasPlace()) {
                                                if (AuthManager
                                                    .instance.isUserAccount)
                                                  pushPage(
                                                      context,
                                                      VendorDetailPage(
                                                        place: notification
                                                            .getPlace(),
                                                      ));
                                              }
                                            },
                                            child: Text(
                                              notification.hasPlace()
                                                  ? notification
                                                      .getPlace()
                                                      .placeNameEng
                                                      .tr()
                                                  : notification.title.tr(),
                                              style: theme.textTheme.subtitle1,
                                              // textAlign: TextAlign.end,
                                            ),
                                          )
                                        : SizedBox(),
                                    Text(
                                      notification.body.tr(),
                                      style: theme.textTheme.bodyText2,
                                      // textAlign: TextAlign.end,
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        /// like
                                        BouncingAnim(
                                          onPress: () {
                                            likesRef = FirebaseDatabase.instance
                                                .reference()
                                                .child('myAlerts')
                                                .child(
                                                    'post-${notification.id}')
                                                .child('likes');

                                            likeFunction(notification.id);
                                            // print(data);
                                            // if (data == null) {
                                            //   likesRef.set({
                                            //     "userId": "${user.userId}",
                                            //     "likeStatus": likeStatus
                                            //   });
                                            // }
                                          },
                                          child: Container(
                                            width: size.width * 0.2,
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 3),
                                            child: Obx(
                                              () => Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [

                                                 likeButton(currentPostIndex, notification)?? Icon(Icons.thumb_up_alt_outlined,color: Colors.red,),

                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Center(
                                                      child:Obx(
                                                            () => currentPostIndex.value == -1
                                                            ? Container()
                                                            : dbController.allPosts[currentPostIndex.value].like.length == 0
                                                            ? Container()
                                                            : Text(
                                                            "${dbController.allPosts[currentPostIndex.value].like.length}"),
                                                      ),),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        /// comment

                                        BouncingAnim(
                                          onPress: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CommentSection(
                                                            notification.id)));
                                          },
                                          child: Container(
                                            width: size.width * 0.25,
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 3),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.message_rounded),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                // Container(
                                                //     width: 1,
                                                //     height: 1,
                                                //     child: _getlikes(context, notification.id)),
                                                Obx(
                                                  () => currentPostIndex.value == -1
                                                      ? Container()
                                                      : dbController.allPosts[currentPostIndex.value].comment.length == 0
                                                          ? Container()
                                                          : Text(
                                                              "${dbController.allPosts[currentPostIndex.value].comment.length}"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        /// share
                                        BouncingAnim(
                                          onPress: () {
                                            Share.share(AppBloc.instance
                                                .notificationShareMessage(
                                                    notification));
                                          },
                                          child: Container(
                                            width: size.width * 0.2,
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 3),
                                            child: Icon(Icons.share),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
        });
  }

  Widget likeButton(RxInt currentIndex, var notification){
    bool likeStatus=false;
    dbController.allPosts[currentIndex.value].like.forEach((element) {
      if(element.userId == "${user.userId}"){
        likeStatus=true;
      }else{
        likeStatus=false;
      }
    });

    return Icon(
     likeStatus? Icons.thumb_up :Icons.thumb_up_alt_outlined
    );
  }
  Future<dynamic> likeFunction(String notificationId) {
    String likeKey;
    String likeStatus;
    var exists;
    likesRef.once().then((snapshot) {
      var data = snapshot.value;
      likeKey = "$notificationId" + "-" + "${user.userId}";
      if (data != null) {
        likeStatus = data[likeKey]['likeStatus'];
        if (likeStatus == '0') {
          likesRef.child(likeKey).set({
            "userId": "${user.userId}",
            "likeStatus": '1',
            "notificationId": '$notificationId'
          });
        } else if (likeStatus == '1') {
          likesRef.child(likeKey).remove();
          // likesRef.child(likeKey).set({
          //   "userId": "${user.userId}",
          //   "likeStatus": '0',
          //   "notificationId": '$notificationId'
          // });
        }
      } else {
        likesRef.child(likeKey).set({
          "userId": "${user.userId}",
          "likeStatus": '1',
          "notificationId": '$notificationId'
        });
      }
    });

    // likesRef.once().then((snapshot) {
    //   exists = snapshot.value;
    //
    //   likeKey = "$notificationId" + "-" + "${user.userId}";
    //
    //   if (exists == null) {
    //     /// create like
    //     likesRef.child(likeKey).set({
    //       "userId": "${user.userId}",
    //       "likeStatus": '1',
    //       "notificationId": '$notificationId'
    //     });
    //   } else {
    //     /// update like
    //
    //     if (exists[likeKey]['likeStatus'] == '0') {
    //       likesRef.child(likeKey).set({"likeStatus": '1'});
    //     } else {
    //       likesRef.child(likeKey).set({"likeStatus": '0'});
    //     }
    //   }
    // });
    // setState(() {});

    return exists;
  }

  displayBottomSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///all comments
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bilal Ahmed'.tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                'very nice chocolate cake. i would like to try this'
                                    .tr(),
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text("15 minutes".tr()),
                        )
                      ],
                    ),
                  ),

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
                            decoration: InputDecoration(
                                hintText: "Write comment ...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {},
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
            ),
          );
        });
  }

// Widget _getMessageList(BuildContext context,String notificationId) {
//   DatabaseReference commentRef = FirebaseDatabase.instance
//       .reference()
//       .child('myAlerts')
//       .child('${notificationId}')
//       .child('comments');
//
//
//   Size size = MediaQuery.of(context).size;
//   commentRef = FirebaseDatabase.instance
//       .reference()
//       .child('myAlerts')
//       .child('${notificationId}')
//       .child('comments');
//   return FirebaseAnimatedList(
//     shrinkWrap: true,
//     // controller: _scrollController,
//     query: commentRef,
//     itemBuilder: (context, snapshot, animation, index) {
//       totalComments='$index';
//       final json = snapshot.value as Map<dynamic, dynamic>;
//       print(snapshot.value['body']);
//       // final message = Message.fromJson(json);
//       // return MessageWidget(message.text, message.date);
//       return Container();
//     },
//   );
// }

// Widget getTestAllLikes() {
//   List<Likes> workshopList = [];
//   // List<Map<dynamic,dynamic>> workshopList = [];
//   final dbRef = FirebaseDatabase.instance.reference().child('myAlerts').child('83').child('likes');
//   return FutureBuilder(
//       future: dbRef.once(),
//       builder: (context,AsyncSnapshot<DataSnapshot> snapshot){
//         if(snapshot.hasData){
//           workshopList.clear();
//
//           Map<dynamic, dynamic> values = snapshot.data.value;
//           Likes likes = Likes.fromJson(values['80-23']);
//           workshopList.add(likes);
//
//           print(likes);
//           print(values);
//
//
//         }
//         return Container();
//       }
//
//   );
// }

//
// Future getAllLikes(String postId) async {
//   RxList<Like> likesInfo;
//   // likesInfo.clear();
//
//   var databaserRef = FirebaseDatabase.instance
//       .reference()
//       .child('myAlerts')
//       .child('post-81')
//       .child('likes');
//   databaserRef.onValue.listen((event) {
//     Map commData = event.snapshot.value;
//      likesInfo=<Like>[].obs;
//     commData.entries.forEach((element) {
//       likesInfo.add(Like.fromJson(Map<String, dynamic>.from(element.value)));
//     });
//
//     print(likesInfo);
//
//   });
//
// }
//
// Widget _getlikes(BuildContext context,String postId) {
//   var commentRef;
//   Size size = MediaQuery.of(context).size;
//   commentRef = FirebaseDatabase.instance
//       .reference()
//       .child('myAlerts')
//       .child('post-$postId')
//       .child('likes');
//   return FirebaseAnimatedList(
//     shrinkWrap: true,
//     // controller: _scrollController,
//     query: commentRef,
//     itemBuilder: (context, snapshot, animation, index) {
//
//       // final json = snapshot.value as Map<dynamic, dynamic>;
//       print(snapshot.value['likeStatus']);
//       if(snapshot.value['likeStatus']=='1'){
//         totalLikes.value=totalLikes.value+1;
//       }
//
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//           ),
//         ],
//       );
//     },
//   );
// }
}
