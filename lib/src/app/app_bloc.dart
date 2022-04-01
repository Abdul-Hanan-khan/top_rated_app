import 'dart:io';

import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/models/message.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:top_rated_app/src/sdk/models/place_detail.dart';
import 'package:top_rated_app/src/sdk/models/rating_partial.dart';
import 'package:top_rated_app/src/sdk/models/user_rating.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/services/push_notification_service.dart';

import '../sdk/base/bloc_base.dart';
import '../sdk/cc_app.dart';

class AppBloc extends BaseBloc {
  final androidLink = "https://play.google.com/store/apps/details?id=com.toprated.bh";

  AppBloc._privateConstructor() {
    initialize();
  }
  static final AppBloc instance = AppBloc._privateConstructor();

  List<Place> places = new List.empty(growable: true);

  initialize() {
    CCApp.instance.initialize();
    PushNotificationService.instance.initialize();
  }

  uploadDeviceToken() async {
    if (await AuthManager.instance.isLoggedIn() && AuthManager.instance.isUserAccount) {
      final token = await PushNotificationService.instance.getToken();
      ApiController.instance.setDeviceToken(token);
      PushNotificationService.instance.subscribeTopic(FirebaseTopics.general);
    }
  }

  logout() async {
    AuthManager.instance.logout();
    PushNotificationService.instance.unsubscribeTopic(FirebaseTopics.general);
  }

  String notificationShareMessage(Message message) {
    return "${message.title}\n${message.body}\n\nLink: $androidLink";
  }

  String placeShareMessage(Place place, PlaceDetail detail) {
    return "Name: ${place.placeNameEng}/${place.placeNameAr}\nPhone: ${detail.phone}\nAddress: ${place.address}\nRating: ${detail.getOverallRating()}\n\nLink: $androidLink";
  }

  String reviewShareMessage(RatingPartial rating) {
    return "Name: ${rating.name}\nRating: ${rating.getAverageRating()}\nDate: ${rating.displayDate}\n\nReview: ${rating.review?.trim() ?? "None"}\n\nLink: $androidLink";
  }

  String userReviewShareMessage(UserRating rating) {
    return "Name: ${rating.placeNameEng}/${rating.placeNameAr}\nRating: ${rating.getAverageRating()}\nDate: ${rating.displayDate}\n\nReview: ${rating.review?.trim() ?? "None"}\n\nLink: $androidLink";
  }

  @override
  void dispose() async {}
}
