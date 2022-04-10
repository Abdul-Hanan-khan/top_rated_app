import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_rated_app/src/app/app_theme.dart';
import 'package:top_rated_app/src/pages/vendor_edit_profile/vendor_edit_profile_page.dart';
import 'package:top_rated_app/src/pages/vendor_profile/vendor_profile_bloc.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/widgets/app_button.dart';
import 'package:top_rated_app/src/sdk/widgets/screen_progress_loader.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tuple/tuple.dart';

import '../../../static_vars.dart';

class VendorProfilePage extends StatefulWidget {
  @override
  _VendorProfilePageState createState() => new _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
  ThemeData theme;
  BuildContext _context;
  VendorProfileBloc bloc;
  bool _isLoading = false;
  bool status = false;

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    bloc = new VendorProfileBloc();
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

  changeLocalityStatus(bool localeStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('localeStatus', localeStatus);
    bool ssss = prefs.getBool("localeStatus");
    print(ssss);
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
    final image = AuthManager.instance.place.image;

    return ListView(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          child: image.isNotEmpty
              ? Image.network(
                  "${AppConstants.imagePlaceBaseUrl}$image",
                  fit: BoxFit.cover,
                )
              : Container(),
        ),
        Padding(
          padding: const EdgeInsets.all(Dimens.margin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${AuthManager.instance.place.placeNameEng}".tr(),
                    style:
                        theme.textTheme.headline6.copyWith(color: Colors.black),
                  ),
                  Text("${AuthManager.instance.place.email}".tr(),
                      style: theme.textTheme.subtitle2),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 20,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300],
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                changeLocalityStatus(false);
                                status = false;
                                translator.setNewLanguage(
                                  context,
                                  newLanguage: 'en',
                                  remember: true,
                                  restart: true,
                                );
                                StaticVars.localeStatus = false;
                                print(status);
                              });
                            },
                            child: Container(
                              width: 45,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: StaticVars.localeStatus
                                      ? Colors.transparent
                                      : Colors.orange,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                  child: Text(
                                'Eng',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              StaticVars.localeStatus = true;
                              setState(() {
                                changeLocalityStatus(true);
                                status = true;
                                translator.setNewLanguage(
                                  context,
                                  newLanguage: 'ar',
                                  remember: true,
                                  restart: true,
                                );
                                print(status);
                              });
                            },
                            child: Container(
                              width: 45,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: !StaticVars.localeStatus
                                      ? Colors.transparent
                                      : Colors.orange,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                  child: Text('Ar',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppButton(
                height: 30,
                onPressed: () async {
                  await pushPage(context, VendorEditProfilePage());
                  setState(() {});
                },
                text: "Edit Profile".tr(),
              )
            ],
          ),
        ),
        Spacing.vertical,
        StreamBuilder<List<Tuple3<String, String, String>>>(
            stream: bloc.data,
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        for (var item in snapshot.data)
                          _buildItem(item.item1, item.item2, item.item3),
                      ],
                    );
            }),
      ],
    );
  }

  Widget _buildItem(String imageName, String title, String count) {
    return new Container(
      width: 120,
      height: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.surface,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.margin, vertical: Dimens.margin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/$imageName",
            width: 50,
            height: 50,
          ),
          Spacing.vSmall,
          Expanded(
            child: Text(
              title.tr(),
              style: theme.textTheme.bodyText2.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Spacing.vSmall,
          Expanded(
            child: Text(
              "$count".tr(),
              maxLines: 2,
              textAlign: TextAlign.center,
              style: count.length > 5
                  ? theme.textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryTextColor,
                    )
                  : theme.textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
