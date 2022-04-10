import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  BuildContext _context;
  NotificationsBloc bloc;

  DatabaseReference likesRef;
  final user = AuthManager.instance.user;
  final place = AuthManager.instance.place;

  @override
  void initState() {
    super.initState();

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
    RxBool likeStatus = false.obs;
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

                        dbController.allPosts[currentPostIndex.value].like
                            .forEach((element) {
                          // print(user.userId);
                          // print(place.id);
                          if (user != null) {
                            if (element.userId == user.userId.toString()) {
                              likeStatus.value = true;
                            }
                          } else {
                            if (element.userId == place.id.toString()) {
                              likeStatus.value = true;
                            }
                          }
                        });

                        return Stack(
                          children: [
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
                                            // SystemSound.play(SystemSoundType.click);
                                            Feedback.forTap(context);

                                            likesRef = FirebaseDatabase.instance
                                                .reference()
                                                .child('myAlerts')
                                                .child(
                                                    'post-${notification.id}')
                                                .child('likes');
                                            likeFunction(notification.id);
                                          },
                                          child: Container(
                                            width: size.width * 0.13,
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 3),
                                            child: Obx(
                                              () => Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  likeButton(currentPostIndex,
                                                          notification,size) ??
                                                      Icon(
                                                        Icons
                                                            .thumb_up_alt_outlined,
                                                        color: Colors.red,
                                                      ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Center(
                                                    child: Obx(
                                                      () => currentPostIndex
                                                                  .value ==
                                                              -1
                                                          ? Container()
                                                          : dbController
                                                                      .allPosts[
                                                                          currentPostIndex
                                                                              .value]
                                                                      .like
                                                                      .length ==
                                                                  0
                                                              ? Container()
                                                              : Text(
                                                                  "${dbController.allPosts[currentPostIndex.value].like.length}"),
                                                    ),
                                                  ),
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
                                                Container(
                                                  width: size.width * 0.1,
                                                  height: size.height * 0.04,
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 3),
                                                  decoration: BoxDecoration(
                                                      // color: Colors.blue,
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/icons/comments.png'),
                                                          fit: BoxFit.contain)),
                                                ),

                                                // Container(
                                                //     width: 1,
                                                //     height: 1,
                                                //     child: _getlikes(context, notification.id)),
                                                Obx(
                                                  () => currentPostIndex
                                                              .value ==
                                                          -1
                                                      ? Container()
                                                      : dbController
                                                                  .allPosts[
                                                                      currentPostIndex
                                                                          .value]
                                                                  .comment
                                                                  .length ==
                                                              0
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
                                            height: size.height * 0.04,
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 3),
                                            decoration: BoxDecoration(
                                                // color: Colors.blue,
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/icons/share.png'),
                                                    fit: BoxFit.contain)),
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

  Widget likeButton(RxInt currentIndex, var notification,Size size) {
    bool likeStatus = false;
    dbController.allPosts[currentIndex.value].like.forEach((element) {
      if (user != null) {
        if (likeStatus == false) {
          if (element.userId == "${user.userId}") {
            likeStatus = true;
          } else {
            likeStatus = false;
          }
        }
      } else {
        if (likeStatus == false) {
          if (element.userId == "${place.id}") {
            likeStatus = true;
          } else {
            likeStatus = false;
          }
        }
      }
    });

    // return Icon(likeStatus ? Icons.thumb_up : Icons.thumb_up_alt_outlined);
    return likeStatus?    Container(
      width: size.width * 0.1,
      height: size.height * 0.04,
      padding: EdgeInsets.only(
          top: 5, bottom: 3),
      decoration: BoxDecoration(
        // color: Colors.blue,
          image: DecorationImage(
              image: AssetImage(
                  'assets/icons/like.png'),
              fit: BoxFit.contain)),
    ): Icon(Icons.thumb_up_alt_outlined);
  }

  Future<dynamic> likeFunction(String notificationId) {
    // like function clear for both user and vendor

    String likeKey;
    String likeStatus;
    var exists;
    if (user != null) {
      /// Normal user operations
      likesRef.once().then((snapshot) {
        var data = snapshot.value;
        likeKey = "$notificationId" + "-" + "${user.userId}";
        if (data != null) {
          if (data[likeKey] == null) {
            likesRef.child(likeKey).set({
              "userId": "${user.userId}",
              "likeStatus": '1',
              "notificationId": '$notificationId'
            });
            // likeStatus = data[likeKey]['likeStatus'];
            // print('getting null');
          } else {
            likeStatus = data[likeKey]['likeStatus'];
            if (likeStatus == '0') {
              // update like
              likeStatus = '1';
              likesRef.child(likeKey).set({
                "userId": "${user.userId}",
                "likeStatus": '1',
                "notificationId": '$notificationId'
              });
            } else if (likeStatus == '1') {
              likeStatus = '0';
              //delete like
              likesRef.child(likeKey).remove();
            }
          }
        } else {
          // create new like
          likesRef.child(likeKey).set({
            "userId": "${user.userId}",
            "likeStatus": '1',
            "notificationId": '$notificationId'
          });
        }
      });
    } else {
      /// Vendor operations
      likesRef.once().then(
        (snapshot) {
          var data = snapshot.value;
          likeKey = "$notificationId" + "-" + "${place.id}";
          if (data != null) {
            if (data[likeKey] == null) {
              likesRef.child(likeKey).set({
                "userId": "${place.id}",
                "likeStatus": '1',
                "notificationId": '$notificationId'
              });
            } else {
              likeStatus = data[likeKey]['likeStatus'];

              if (likeStatus == '0') {
                likeStatus = '1';
                likesRef.child(likeKey).set({
                  "userId": "${place.id}",
                  "likeStatus": '1',
                  "notificationId": '$notificationId'
                });
              } else if (likeStatus == '1') {
                likeStatus = '0';
                likesRef.child(likeKey).remove();
                // likesRef.child(likeKey).set({
                //   "userId": "${user.userId}",
                //   "likeStatus": '0',
                //   "notificationId": '$notificationId'
                // });
              }
            }
          } else {
            likesRef.child(likeKey).set({
              "userId": "${place.id}",
              "likeStatus": '1',
              "notificationId": '$notificationId'
            });
          }
        },
      );
    }

    return exists;
  }
}
