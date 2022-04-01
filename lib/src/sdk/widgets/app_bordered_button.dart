import 'package:flutter/material.dart';

class AppBorderedButton extends StatelessWidget {
  final String text;
  final Color color;
  final Widget icon;
  final double radius;
  final Color backgroundColor;
  final Function onPressed;

  AppBorderedButton({
    this.text,
    this.color,
    this.icon,
    this.backgroundColor,
    this.radius,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return this.icon == null
        ? FlatButton(
            shape: _border,
            child: _getText(context),
            color: backgroundColor,
            onPressed: onPressed,
          )
        : FlatButton.icon(
            shape: _border,
            label: _getText(context),
            icon: icon,
            color: backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 16),
            onPressed: onPressed,
          );
  }

  ShapeBorder get _border {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color ?? Colors.grey));
  }

  Text _getText(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.button.copyWith(
              color: color,
            ));
  }
}
