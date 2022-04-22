import 'package:flutter/material.dart';
import 'package:top_rated_app/src/pages/register/register_bloc.dart';
import 'package:top_rated_app/src/pages/vendor_register/vendor_register_page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/pages/verify_code/verify_code_page.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/widgets/app_button.dart';
import 'package:top_rated_app/src/sdk/widgets/screen_progress_loader.dart';
import 'package:top_rated_app/src/sdk/widgets/stream_text_field.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ThemeData theme;
  BuildContext _context;
  RegisterBloc bloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    bloc = new RegisterBloc();
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
              _buildFirstNameField(context),
              Spacing.vertical,
              _buildLastNameField(context),
              Spacing.vertical,
              _buildEmailField(context),
              Spacing.vertical,
              _buildPasswordField(context),
              Spacing.vertical,
              _buildConfirmPasswordField(context),
              Spacing.vLarge,
              Row(
                children: [
                  Expanded(child: _buildRegisterButton(context)),
                ],
              ),
              _buildBackButton(context),
              _buildVendorRegisterButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFirstNameField(BuildContext context) {
    return StrTextField(
      bloc.firstName,
      onChanged: bloc.firstNameSink,
      hintText: "First Name".tr(),
    );
  }

  Widget _buildLastNameField(BuildContext context) {
    return StrTextField(
      bloc.lastName,
      onChanged: bloc.lastNameSink,
      hintText: "Last Name".tr(),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return StrTextField(
      bloc.email,
      hintText: "Email".tr(),
      onChanged: bloc.emailSink,
      keyboardType: TextInputType.emailAddress,
    );
  }

  var _showPassword = false;
  Widget _buildPasswordField(BuildContext context) {
    return StrTextField(
      bloc.password,
      hintText: "Password".tr(),
      onChanged: bloc.passwordSink,
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _showPassword = !_showPassword;
          });
        },
        icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
      ),
      obsureText: !_showPassword,
    );
  }

  var _showConfirmPassword = false;
  Widget _buildConfirmPasswordField(BuildContext context) {
    return StrTextField(
      bloc.password,
      onChanged: bloc.confirmPasswordSink,
      hintText: "Confirm Password".tr(),
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _showConfirmPassword = !_showConfirmPassword;
          });
        },
        icon: Icon(_showConfirmPassword ? Icons.visibility_off : Icons.visibility),
      ),
      obsureText: !_showConfirmPassword,
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return AppButton(
      text: "Sign up as User".tr(),
      background: theme.accentColor,
      onPressed: () async {
        final user = await bloc.register();
        if (user != null && !user.isAccountActivated) {
          UIUtils.showAdaptiveDialog(
            _context,
            "Success".tr(),
            "Thanks for signing up. Check your email address for verification code".tr(),
            onPressed: () {
              Navigator.of(context).push(getPageRoute((context) => VerifyCodePage()));
            },
          );
        }
      },
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        popPage(context);
      },
      child: RichText(
          text: TextSpan(style: theme.textTheme.subtitle2, children: [
        TextSpan(text: "Already have an Account? ".tr()),
        TextSpan(text: "Sign in".tr(), style: TextStyle(color: theme.primaryColor)),
      ])),
    );
  }

  Widget _buildVendorRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed(Routes.vendorRegister);
      },
      child: RichText(
          text: TextSpan(style: theme.textTheme.subtitle2, children: [
        TextSpan(text: "Are you a Vendor".tr()+" ?"),
        TextSpan(text: "Register Here".tr(), style: TextStyle(color: theme.primaryColor)),
      ])),
    );
  }
}
