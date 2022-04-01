import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:top_rated_app/src/app/app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Color foreground;
  final Color background;
  final IconData icon;
  final Function onPressed;
  final double elevation;
  final double height;

  AppButton({
    this.text,
    this.foreground,
    this.icon,
    this.background,
    this.elevation,
    this.height,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return this.icon == null
        ? Container(
            height: this.height ?? 40,
            decoration: getDecoration(theme),
            child: RaisedButton(
              color: Colors.transparent,
              child: _getText(context),
              onPressed: onPressed,
              elevation: 0,
              hoverElevation: 0,
              highlightElevation: 0,
              disabledElevation: 0,
              focusElevation: 0,
            ),
          )
        : Container(
            height: this.height ?? 40,
            decoration: getDecoration(theme),
            child: RaisedButton.icon(
              label: _getText(context),
              color: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              disabledElevation: 0,
              icon: FaIcon(
                icon,
                color: foreground ?? Theme.of(context).iconTheme.color,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              onPressed: onPressed,
            ),
          );
  }

  Decoration getDecoration(ThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(colors: [theme.accentColor, theme.primaryColor]),
      borderRadius: BorderRadius.circular(20),
    );
  }

  Text _getText(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.button.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ));
  }
}
