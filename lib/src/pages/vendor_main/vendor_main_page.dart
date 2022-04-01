import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/pages/home/home_page.dart';
import 'package:top_rated_app/src/pages/main/main_page.dart';
import 'package:top_rated_app/src/pages/notifications/notifications_page.dart';
import 'package:top_rated_app/src/pages/vendor_message/vendor_message_page.dart';
import 'package:top_rated_app/src/pages/vendor_profile/vendor_profile_page.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/widgets/screen_progress_loader.dart';

class VendorMainPage extends StatefulWidget {
  @override
  _VendorMainPageState createState() => new _VendorMainPageState();
}

class _VendorMainPageState extends State<VendorMainPage> {
  ThemeData theme;
  BuildContext _context;
  bool _isLoading = false;
  int _bottomBarIndex = 0;

  final _bottomBarIcons = [Icons.person, Icons.home, Icons.notifications];

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    // bloc = new BaseBloc();
    // bloc.isLoading.listen((event) {
    //   setState(() {
    //     _isLoading = event;
    //   });
    // });

    // bloc.exception.listen((event) {
    //   UIUtils.showAdaptiveDialog(_context, "Error", event);
    // });
//bloc.error.listen((event) {
    //    UIUtils.showError(_context, event);
    //});
  }

  @override
  void dispose() {
    super.dispose();
    // bloc.dispose();
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
              return Column(
                children: [
                  Expanded(child: _buildBody(context)),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(WidgetConstants.cornerRadius),
                      topRight: Radius.circular(WidgetConstants.cornerRadius),
                    ),
                    child: _buildBottomBar(context),
                  ),
                ],
              );
            },
          ),
        ),
        _isLoading ? ScreenProgressLoader() : SizedBox(),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Top Rated".tr()),
      leading: Container(
        padding: EdgeInsets.all(10),
        child: Image.asset(
          "assets/images/logo_color.png",
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        if (_bottomBarIndex == 2)
          IconButton(
            onPressed: () {
              pushPage(context, VendorMessagePage());
            },
            icon: Icon(Icons.message_outlined),
            color: theme.primaryColor,
          )
        else if (_bottomBarIndex == 0)
          IconButton(
            onPressed: () {
              _showLogoutDialog();
            },
            icon: Icon(Icons.exit_to_app),
            color: theme.primaryColor,
          ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.margin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < _bottomBarIcons.length; i++)
              BottomNavItem(
                icon: _bottomBarIcons[i],
                isSelected: _bottomBarIndex == i,
                onClick: () {
                  setState(() {
                    _bottomBarIndex = i;
                  });
                  // if (i == 1) {
                  //   pushPage(context, VendorMessagePage());
                  // } else {

                  // }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return IndexedStack(
      children: [
        VendorProfilePage(),
        HomePage(),
        NotificationsPage(),
      ],
      index: _bottomBarIndex,
    );
  }

  _showLogoutDialog() {
    UIUtils.showAdaptiveConfirmationDialog(
      _context,
      "Logout".tr(),
      "Do you want to logout".tr()+"?",
      onPositiveAction: () {
        AuthManager.instance.logout();
        Navigator.of(_context).pushReplacementNamed(Routes.login);
      },
    );
  }
}
