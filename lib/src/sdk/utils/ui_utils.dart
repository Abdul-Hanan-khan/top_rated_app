import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../widgets/adaptive_alert_dialog.dart';

class UIUtils {
  static showError(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message.tr())));
  }

  static showAdaptiveDialog(BuildContext context, String title, String message,
      {Function onPressed}) {
    showDialog(
        context: context,
        builder: (context) {
          return AdaptiveAlertDialog(
            title: title,
            message: message,
            actions: [
              AdaptiveAlertAction(
                  text: "OK".tr(),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onPressed != null) {
                      onPressed();
                    }
                  })
            ],
          );
        });
  }

  static showAdaptiveConfirmationDialog(
      BuildContext context, String title, String message,
      {Function onPositiveAction, Function onNegativeAction}) {
    showDialog(
        context: context,
        builder: (context) {
          return AdaptiveAlertDialog(
            title: title,
            message: message,
            actions: [
              AdaptiveAlertAction(
                  text: "Yes",
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onPositiveAction != null) {
                      onPositiveAction();
                    }
                  }),
              AdaptiveAlertAction(
                  text: "No",
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onNegativeAction != null) {
                      onNegativeAction();
                    }
                  }),
            ],
          );
        });
  }
}
