import 'package:flutter/material.dart';
import 'package:top_rated_app/src/pages/change_password/change_password_bloc.dart';
import 'package:top_rated_app/src/pages/verify_code/verify_code_page.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/utils/widget_utils.dart';
import 'package:top_rated_app/src/sdk/widgets/app_button.dart';
import 'package:top_rated_app/src/sdk/widgets/screen_progress_loader.dart';
import 'package:top_rated_app/src/sdk/widgets/stream_text_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ChangePasswordPage extends StatefulWidget {
  final String email;
  ChangePasswordPage({this.email});

  @override
  _ChangePasswordPageState createState() => new _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  ThemeData theme;
  BuildContext _context;
  ChangePasswordBloc bloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    bloc = new ChangePasswordBloc(widget.email);
    bloc.isLoading.listen((event) {
      setState(() {
        _isLoading = event;
      });
    });

    bloc.exception.listen((event) {
      UIUtils.showAdaptiveDialog(_context, "Error", event);
    });
    bloc.error.listen((event) {
      UIUtils.showError(_context, event);
    });
    bloc.loggedUser.listen((isAccountActivated) {
      if (AuthManager.instance.isUserAccount) {
        if (isAccountActivated) {
          Navigator.of(_context).pushReplacementNamed(Routes.home);
        } else {
          Navigator.of(_context).push(getPageRoute((context) => VerifyCodePage()));
        }
      } else {
        if (isAccountActivated) {
          Navigator.of(_context).pushReplacementNamed(Routes.vendorHome);
        }
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
          appBar: _buildAppBar(context),
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

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Update Password".tr()),
      leading: WidgetUtils.getAdaptiveBackButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(Dimens.margin),
      children: [
        _buildPasswordField(context),
        Spacing.vertical,
        _buildConfirmPasswordField(context),
        Spacing.vertical,
        _buildUpdateButton(context),
      ],
    );
  }

  var _showPassword = false;
  Widget _buildPasswordField(BuildContext context) {
    return StrTextField(
      bloc.password,
      hintText: "Password",
      onChanged: bloc.onPasswordChanged,
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
      onChanged: bloc.onConfirmPasswordChanged,
      hintText: "Confirm Password",
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

  Widget _buildUpdateButton(BuildContext context) {
    return AppButton(
      text: "Update",
      background: theme.accentColor,
      onPressed: () async {
        bloc.update();
      },
    );
  }
}
