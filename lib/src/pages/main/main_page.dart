import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:top_rated_app/src/app/app_theme.dart';
import 'package:top_rated_app/src/pages/favorites/favorites_page.dart';
import 'package:top_rated_app/src/pages/main/main_bloc.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/static_vars.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../testing_class.dart';
import '../../sdk/constants/dimens.dart';
import '../../sdk/utils/navigation_utils.dart';
import '../home/home_page.dart';
import '../notifications/notifications_page.dart';
import '../profile/profile_page.dart';
import '../search/search_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ThemeData theme;
  BuildContext _context;
  int _bottomBarIndex = StaticVars.isFirstRoute == true?2:0;
  MainBloc bloc;

  GlobalKey<HomePageState> _homeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    bloc = new MainBloc();
    bloc.error.listen((event) {
      UIUtils.showAdaptiveDialog(_context, "Error", event);
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
    return Scaffold(
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
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Top Rated".tr(),style: TextStyle(color: Colors.grey),),
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
        if (_bottomBarIndex == 0)
          IconButton(
            onPressed: () {
              _homeKey.currentState.onFilterClick();
            },
            icon: Icon(FontAwesomeIcons.filter),
            color: theme.primaryColor,
          ),
        if (_bottomBarIndex == 3)
          IconButton(
            onPressed: () {
              _showLogoutDialog();
            },
            icon: Icon(Icons.exit_to_app),
            color: theme.primaryColor,
          ),
        // IconButton(
        //   icon: Icon(Icons.search),
        //   onPressed: () {
        //     pushPage(context, SearchPage());
        //   },
        // ),
      ],
    );
  }

  final _bottomBarIcons = [
    Icons.home,
    Icons.search,
    Icons.notifications,
    Icons.person,
    Icons.favorite];
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
                // isSelected: _bottomBarIndex == i,
                isSelected: _bottomBarIndex == i,
                onClick: () {
                  StaticVars.isFirstRoute=false;

                  if (i == 1) {
                    pushPage(context, SearchPage());
                  } else {
                    setState(() {
                      _bottomBarIndex = i;
                    });
                  }
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
        HomePage(
          key: _homeKey,
        ),
        SizedBox(),
        NotificationsPage(),
        // TestingClass(),
        ProfilePage(),
        FavoritesPage(),
      ],
      index: StaticVars.isFirstRoute == true? 2 : _bottomBarIndex,
    );
  }

  _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: Dimens.margin, right: Dimens.margin, top: Dimens.margin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sort".tr(),
                      style: theme.textTheme.headline6.copyWith(color: theme.accentColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sort by Rating".tr()+" :"),
                        Checkbox(
                          value: true,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Area".tr()+" :"),
                        DropdownButton<String>(
                          items: <String>['First Area', 'Second Area', 'Third Area'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value.tr()),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      popPage(context);
                    },
                    child: Text(
                      "Clear".tr(),
                      style: theme.textTheme.subtitle1,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      popPage(context);
                    },
                    child: Text(
                      "Apply".tr(),
                      style: theme.textTheme.subtitle1.copyWith(color: theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _showLogoutDialog() {
    UIUtils.showAdaptiveConfirmationDialog(
      _context,
      "Logout",
      "Do you want to logout?".tr(),
      onPositiveAction: () {
        AuthManager.instance.logout();
        Navigator.of(_context).pushReplacementNamed(Routes.login);
      },
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    Key key,
    @required this.icon,
    this.isSelected = false,
    @required this.onClick,
  }) : super(key: key);

  final bool isSelected;
  final Function onClick;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: onClick,
      child: isSelected
          ? Column(
              children: [
                _buildButton(context),
                Spacing.vSmall,
                Container(
                  height: 4,
                  width: 4,
                  decoration: new BoxDecoration(
                    color: theme.accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            )
          : _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.margin),
        border: isSelected ? null
            : Border.all(
                color: AppColor.primaryTextColor,
                width: 1,
              ),
        gradient: isSelected
            ? LinearGradient(
                begin: Alignment.bottomCenter,
                colors: [theme.accentColor, theme.primaryColor],
                transform: GradientRotation(90),
              )
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: theme.accentColor.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 5), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        color: isSelected ? theme.colorScheme.onPrimary : AppColor.primaryTextColor,
      ),
    );
  }
}
