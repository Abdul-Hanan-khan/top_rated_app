import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../constants/dimens.dart';
import '../constants/spacing.dart';

class WidgetUtils {
  static Decoration getDecoratedBackground(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.surface,
      // borderRadius: BorderRadius.circular(Dimens.margin_medium)
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.margin_medium),
        bottomRight: Radius.circular(Dimens.margin_medium),
      ),
    );
  }

  static Widget getCircularDot(Color color) {
    return Text(
      "●",
      style: TextStyle(color: color, fontSize: 25),
    );
  }

  static Widget getAdaptiveBackButton(BuildContext context, {Function onBack}) {
    return IconButton(
      icon: Icon(
        Platform.isAndroid ? Icons.arrow_back : Icons.close,
        color: Theme.of(context).primaryColor,
      ),
      onPressed: onBack ??
          () {
            Navigator.of(context).pop();
          },
    );
  }

  static showAdaptiveBottomSheet(
    BuildContext context, {
    String title,
    String message,
    @required List<AdaptiveBottomSheetAction> actions,
    AdaptiveBottomSheetAction cancelButton,
  }) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              title: title != null ? Text(title.tr()) : null,
              message: message != null ? Text(message.tr()) : null,
              cancelButton: cancelButton != null
                  ? CupertinoActionSheetAction(
                      child: Text(cancelButton.text.tr()),
                      onPressed: cancelButton.onPressed,
                    )
                  : null,
              actions: <Widget>[
                for (var action in actions)
                  CupertinoActionSheetAction(
                    child: Text(action.text.tr()),
                    onPressed: action.onPressed,
                  ),
              ],
            );
          });
    } else {
      showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).backgroundColor,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(Dimens.margin),
              child: Wrap(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      title != null ? Text(title.tr(), style: Theme.of(context).primaryTextTheme.headline6) : SizedBox(),
                      message != null ? Text(message.tr()) : SizedBox(),
                    ],
                  ),
                  Spacing.vMedium,
                  for (var action in actions)
                    ListTile(
                      leading: action.icon != null ? Icon(action.icon) : null,
                      title: Text(action.text.tr()),
                      onTap: action.onPressed,
                    ),
                  Spacing.vMedium,
                  cancelButton != null
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            textColor: Theme.of(context).accentColor,
                            child: Text(cancelButton.text.tr().toUpperCase()),
                            onPressed: cancelButton.onPressed,
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            );
          });
    }
  }

  static showInfoSnackbar(BuildContext context, String message) {
    final theme = Theme.of(context);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message.tr(),
          style: theme.textTheme.bodyText1.copyWith(
            color: theme.colorScheme.onError,
          )),
      backgroundColor: theme.colorScheme.error,
    ));
  }
}

class AdaptiveBottomSheetAction {
  final String text;
  final Function onPressed;
  final IconData icon;

  AdaptiveBottomSheetAction({this.text, this.icon, this.onPressed})
      : assert(text != null),
        assert(onPressed != null);
}
