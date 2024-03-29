import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../constants/dimens.dart';
import '../constants/spacing.dart';

class ScreenProgressLoader extends StatelessWidget {
  const ScreenProgressLoader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IgnorePointer(
        ignoring: false,
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          child: Center(
            child: CCProgressLoader(),
          ),
        ),
      ),
    );
  }
}

class CCProgressLoader extends StatelessWidget {
  const CCProgressLoader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.margin, vertical: Dimens.margin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(
            strokeWidth: 3,
          ),
          Spacing.vertical,
          Text("Please Wait".tr())
        ],
      ),
    );
  }
}
