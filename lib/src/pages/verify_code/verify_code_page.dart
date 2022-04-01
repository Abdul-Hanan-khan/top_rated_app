import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/pages/change_password/change_password_page.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/preference_keys.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/pref_utils.dart';
import 'package:top_rated_app/src/sdk/widgets/app_button.dart';
import 'package:top_rated_app/src/sdk/widgets/stream_text_field.dart';

import '../../sdk/utils/ui_utils.dart';
import '../../sdk/widgets/screen_progress_loader.dart';
import 'verify_code_bloc.dart';

class VerifyCodePage extends StatefulWidget {
  final String email;
  VerifyCodePage({this.email});

  @override
  _VerifyCodePageState createState() => new _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  ThemeData theme;
  BuildContext _context;
  VerifyCodeBloc bloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    bloc = new VerifyCodeBloc(widget.email);
    bloc.isLoading.listen((event) {
      setState(() {
        _isLoading = event;
      });
    });

    bloc.exception.listen((event) {
      UIUtils.showAdaptiveDialog(_context, "Error".tr(), event);
    });
    bloc.error.listen((event) {
      UIUtils.showError(_context, event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Builder(
            builder: (context) {
              _context = context;
              return _buildBody(context);
            },
          ),
        ),
        _isLoading ? ScreenProgressLoader() : SizedBox(),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(
              top: Dimens.margin_large,
            ),
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(WidgetConstants.cornerRadius),
                  bottomRight: Radius.circular(WidgetConstants.cornerRadius),
                )),
            child: Center(
              child: Image.asset(
                "assets/images/logo_with_title.png",
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
        Spacing.vLarge,
        Expanded(
          flex: 3,
          child: ListView(
            padding: const EdgeInsets.all(Dimens.margin),
            children: [
              _buildCodeField(context),
              Spacing.vertical,
              _buildResendTimer(context),
              Spacing.vLarge,
              Row(
                children: [
                  Expanded(child: _buildVerifyButton(context)),
                  Spacing.horizontal,
                  Expanded(child: _buildResendButton(context)),
                ],
              ),
              _buildBackButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResendTimer(BuildContext context) {
    return Center(
        child: StreamBuilder<String>(
            stream: bloc.resendCounter,
            builder: (context, snapshot) {
              return Text(snapshot.hasData ? snapshot.data : "02:00");
            }));
  }

  Widget _buildCodeField(BuildContext context) {
    return StrTextField(
      bloc.verificationCode,
      hintText: "Activation Code".tr(),
      onChanged: bloc.verificationCodeSink,
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return AppButton(
      text: "Verify".tr(),
      background: theme.accentColor,
      onPressed: () async {
        if (await bloc.onVerifyAction()) {
          if (widget.email != null) {
            pushPage(context, ChangePasswordPage(email: widget.email));
          } else {
            if (await PreferenceUtils.getBool(PreferenceKeys.IS_VENDOR, defaultValue: false)) {
              UIUtils.showAdaptiveDialog(
                  _context, "Verified".tr(), "Thanks for registering. We will revert to you within 36 hours via email".tr(),
                  onPressed: () {
                Navigator.of(context).pushReplacementNamed(Routes.login);
              });
            } else {
              UIUtils.showAdaptiveDialog(
                  _context, "Verified".tr(), "Email verified successfully, Please login again to use application.".tr(),
                  onPressed: () {
                Navigator.of(context).pushReplacementNamed(Routes.login);
              });
            }
          }
        }
      },
    );
  }

  Widget _buildResendButton(BuildContext context) {
    return AppButton(
      text: "Resend".tr(),
      background: theme.accentColor,
      onPressed: () {
        bloc.onResendAction();
      },
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(Routes.login);
      },
      child: Text("Cancel".tr()),
      // child: RichText(
      //     text: TextSpan(style: theme.textTheme.subtitle2, children: [
      //   TextSpan(text: "Already have an Account? "),
      //   TextSpan(text: "Sign in", style: TextStyle(color: theme.primaryColor)),
      // ])),
    );
  }
}
