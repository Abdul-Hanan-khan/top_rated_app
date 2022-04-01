import 'package:flutter/material.dart';

class CCAppBar extends StatelessWidget {
  final String title;
  final Function onBack;
  final bool canGoBack;

  CCAppBar({
    @required this.title,
    this.canGoBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryColor,
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                this.title,
                style: theme.textTheme.headline5
                    .copyWith(fontWeight: FontWeight.w500)
                    .copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Opacity(
                opacity: canGoBack ? 1 : 0,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                  onPressed: !canGoBack
                      ? null
                      : onBack ??
                          () {
                            Navigator.of(context).pop();
                          },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
