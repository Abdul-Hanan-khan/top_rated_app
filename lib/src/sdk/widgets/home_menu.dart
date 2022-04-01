import 'package:flutter/material.dart';

class HomeMenu extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;
  final Function() onPressed;

  HomeMenu(
      {@required this.title,
      @required this.color,
      @required this.icon,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: this.onPressed,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: this.color,
            ),
            child: Icon(this.icon, color: Colors.white, size: 30),
          ),
        ),
        Text(
          this.title,
          style: Theme.of(context).textTheme.subtitle2,
          textAlign: TextAlign.center,
        )
      ],
    ));
  }
}
