import 'package:flutter/material.dart';

import 'dimens.dart';

class Spacing extends Object {
  static Widget get vertical => SizedBox(height: Dimens.margin);
  static Widget get vXSmall => SizedBox(height: Dimens.margin_xsmall);
  static Widget get vSmall => SizedBox(height: Dimens.margin_small);
  static Widget get vMedium => SizedBox(height: Dimens.margin_medium);
  static Widget get vXMedium => SizedBox(height: Dimens.margin_xmedium);
  static Widget get vLarge => SizedBox(height: Dimens.margin_large);
  static Widget get vXLarge => SizedBox(height: Dimens.margin_xlarge);
  static Widget get vXXLarge => SizedBox(height: Dimens.margin_xxlarge);

  static Widget get horizontal => SizedBox(width: Dimens.margin);
  static Widget get hXSmall => SizedBox(width: Dimens.margin_xsmall);
  static Widget get hSmall => SizedBox(width: Dimens.margin_small);
  static Widget get hMedium => SizedBox(width: Dimens.margin_medium);
  static Widget get hXMedium => SizedBox(width: Dimens.margin_xmedium);
  static Widget get hLarge => SizedBox(width: Dimens.margin_large);
  static Widget get hXLarge => SizedBox(width: Dimens.margin_xlarge);
  static Widget get hXXLarge => SizedBox(width: Dimens.margin_xxlarge);
}
