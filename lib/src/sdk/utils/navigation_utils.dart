import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<Object> getPageRoute(WidgetBuilder builder) {
  if (Platform.isIOS) {
    return CupertinoPageRoute(fullscreenDialog: true, builder: builder);
  } else {
    return MaterialPageRoute(fullscreenDialog: true, builder: builder);
  }
}

Future<Object> pushPage(BuildContext context, Widget widget) {
  return Navigator.of(context).push(getPageRoute((context) => widget));
}

void popPage(BuildContext context) {
  Navigator.of(context).pop();
}
