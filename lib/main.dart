import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:localize_and_translate/localize_and_translate.dart';


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
  // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]).then((_){
  //
  // });
  runApp(
    LocalizedApp(
      child: MyApp(),
      // child: TestHome(),
    ),
  );

}
