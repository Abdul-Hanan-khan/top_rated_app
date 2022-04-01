import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../sdk/constants/spacing.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  ThemeData theme;
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    // AuthManager.instance
    //     .reauthenticate()
    //     .then(
    //         (value) => Navigator.of(context).pushReplacementNamed(Routes.home))
    //     .catchError((error) {
    //   Navigator.of(context).pushReplacementNamed(Routes.login);
    // });

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Builder(
        builder: (context) {
          _context = context;
          return _buildBody(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogo(),
              Spacing.vLarge,
              Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          "assets/images/logo_stars.png",
          width: 200,
          height: 200,
        ),
        Text(
          "Top Rated".tr(),
          style: theme.textTheme.headline4.copyWith(
            color: theme.colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
