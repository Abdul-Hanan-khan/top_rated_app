import 'package:flutter/widgets.dart';

class KeyboardUtils {
  static dismiss(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
