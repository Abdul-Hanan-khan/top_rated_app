import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/dummy/controller/get_data_fb.dart';
import 'package:top_rated_app/dummy/controller/test_home.dart';
import 'src/app/app.dart';
import 'package:get/get.dart';
import 'src/sdk/utils/notifications_helper.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await translator.init(
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['en', 'ar'],
    assetsDirectory: 'assets/locales/',
  );

  NotificationsHelper.instance.init();
  Firebase.initializeApp();
  runApp(
    LocalizedApp(
      child: MediaQuery(
          data:  MediaQueryData.fromWindow(ui.window),
          child: Directionality(
              textDirection: TextDirection.ltr,
              child: MyApp())),
      // child: TestHome(),
    ),
  );
}
