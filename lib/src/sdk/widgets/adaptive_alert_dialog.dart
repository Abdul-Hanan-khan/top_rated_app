import 'dart:io';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<AdaptiveAlertAction> actions;

  AdaptiveAlertDialog({this.title, this.message, this.actions})
      : assert(title != null),
        assert(message != null);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text(title.tr()),
            content: Text(message.tr()),
            actions: _getActions(),
          )
        : AlertDialog(
            title: Text(title.tr()),
            content: Text(message.tr()),
            actions: _getActions(),
          );
  }

  List<Widget> _getActions() {
    List<Widget> buttons = [];
    this.actions.forEach((action) {
      buttons.add(_makeAction(action));
    });
    return buttons;
  }

  Widget _makeAction(AdaptiveAlertAction action) {
    return Platform.isIOS
        ? CupertinoDialogAction(
            child: Text(action.text.tr()),
            onPressed: action.onPressed,
          )
        : FlatButton(
            child: Text(action.text.tr()),
            onPressed: action.onPressed,
          );
  }
}

class AdaptiveAlertAction {
  final String text;
  final Function onPressed;

  AdaptiveAlertAction({this.text, this.onPressed})
      : assert(text != null),
        assert(onPressed != null);
}
