import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_rated_app/src/pages/verify_code/verify_code_page.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/widget_utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/static_vars.dart';
import '../../sdk/constants/app_constants.dart';
import '../../sdk/constants/dimens.dart';
import '../../sdk/constants/spacing.dart';
import '../../sdk/utils/navigation_utils.dart';
import '../../sdk/utils/ui_utils.dart';
import '../../sdk/widgets/app_button.dart';
import '../../sdk/widgets/screen_progress_loader.dart';
import '../../sdk/widgets/stream_text_field.dart';
import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ThemeData theme;
  BuildContext _context;
  LoginBloc bloc;
  bool _isLoading = false;
  bool localeStatus;

  @override
  void initState() {
    getLocaleStatus();
    super.initState();
    initBloc();
  }

  setLoacaleStatus()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    if(localeStatus == null || localeStatus == false){
      prefs.setBool('localeStatus', false);
      StaticVars.localeStatus=localeStatus;
    }
  }
  getLocaleStatus()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    localeStatus= prefs.getBool('localeStatus')??false;
    StaticVars.localeStatus=localeStatus;
    print(localeStatus);
  }

  initBloc() {
    bloc = new LoginBloc();
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
    bloc.loggedUser.listen((isAccountActivated) {
      if (isAccountActivated) {
        if (AuthManager.instance.isUserAccount) {
          setLoacaleStatus();
          Navigator.of(_context).pushReplacementNamed(Routes.home);

        } else {
          Navigator.of(_context).pushReplacementNamed(Routes.vendorHome);
          setLoacaleStatus();
        }
      } else {
        setLoacaleStatus();
        Navigator.of(_context).push(getPageRoute((context) => VerifyCodePage()));
      }
    });

    bloc.emailNotVerified.listen((event) {
      setLoacaleStatus();
      if (event) {
        Navigator.of(_context).push(getPageRoute((context) => VerifyCodePage()));
      }
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
      mainAxisAlignment: MainAxisAlignment.start,
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
          child: Padding(
            padding: const EdgeInsets.all(Dimens.margin),
            child: ListView(
              children: [
                _buildEmailField(context),
                Spacing.vertical,
                _buildPasswordField(context),
                Spacing.vLarge,
                Row(
                  children: [
                    Expanded(child: _buildLoginButton(context)),
                  ],
                ),
                _buildRegisterButton(context),
                _buildForgotPasswordButton(context),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildLoginButton(BuildContext context) {
    return AppButton(
      text: "Sign In",
      onPressed: () async {
        bloc.login();
      },
    );
  }

  TextEditingController _controller;
  Widget _buildForgotPasswordButton(BuildContext context) {
    _controller = TextEditingController();
    return TextButton(
        onPressed: () {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Forgot Password'.tr()),
                  content: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email".tr(),
                    ),
                    controller: _controller,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel".tr()),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        final email = _controller.text.trim();
                        if (email.isNotEmpty) {
                          if (await bloc.sendResetPasswordCode(email)) {
                            Navigator.of(_context).push(getPageRoute((_context) => VerifyCodePage(email: email)));
                          }
                        }
                      },
                      child: Text("Send Code".tr()),
                    ),
                  ],
                );
              });
        },
        child: Text("Forgot Password?".tr()));
  }

  Widget _buildRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        WidgetUtils.showAdaptiveBottomSheet(
          context,
          actions: [
            AdaptiveBottomSheetAction(
              text: "Sign up as User",
              icon: Icons.person,
              onPressed: () async {
                SharedPreferences prefs=await SharedPreferences.getInstance();
                prefs.setBool('localeStatus', false);
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(Routes.userRegister);
              },
            ),
            AdaptiveBottomSheetAction(
              text: "Sign up as Vendor",
              icon: Icons.store,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(Routes.vendorRegister);
              },
            ),
          ],
          cancelButton: AdaptiveBottomSheetAction(
            text: "Cancel",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
      child: RichText(
          text: TextSpan(style: theme.textTheme.subtitle2, children: [
        TextSpan(text: "Don't have any account? ".tr()),
        TextSpan(text: "Sign up".tr(), style: TextStyle(color: theme.primaryColor)),
      ])),
    );
  }
}
