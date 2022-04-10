import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_rated_app/static_vars.dart';
import '../../sdk/constants/app_constants.dart';
import '../../sdk/constants/dimens.dart';
import '../../sdk/constants/spacing.dart';
import '../../sdk/models/user_detail.dart';
import '../../sdk/utils/date_utils.dart';
import '../../sdk/utils/navigation_utils.dart';
import '../../sdk/utils/ui_utils.dart';
import '../../sdk/widgets/app_button.dart';
import '../../sdk/widgets/screen_progress_loader.dart';
import '../../sdk/widgets/stream_text_field.dart';
import '../followers/followers_page.dart';
import 'profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ThemeData theme;
  BuildContext _context;
  ProfileBloc bloc;
  bool _isLoading = false;
  bool _isEditMode = false;
  final ImagePicker _picker = ImagePicker();
  bool status = false;

  @override
  void initState() {
    super.initState();
// getLocaleStatus();
    initBloc();
  }

  changeLocalityStatus(bool localeStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('localeStatus', localeStatus);
    bool ssss= prefs.getBool("localeStatus");
    print(ssss);
  }
  // getLocaleStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   status = prefs.getBool('localeStatus');
  //   print(status);
  // }

  initBloc() {
    bloc = new ProfileBloc();
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
    return RefreshIndicator(
      onRefresh: () async {
        bloc.fetchUserDetail();
      },
      child: ListView(
        padding: EdgeInsets.only(top: Dimens.margin_large),
        children: [
          Stack(
            children: [
              Positioned(
                left: 20,
                child: Container(
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
                              StaticVars.localeStatus=false;
                              print(status);
                            });
                          },
                          child: Container(
                            width: 45,
                            height: 20,
                            decoration: BoxDecoration(
                                color:
                                    StaticVars.localeStatus ? Colors.transparent : Colors.orange,
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
                            StaticVars.localeStatus=true;
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
                                color: !StaticVars.localeStatus ? Colors.transparent : Colors.orange,
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
              ),
              Container(
                padding: EdgeInsets.all(Dimens.margin),
                margin:
                    EdgeInsets.fromLTRB(Dimens.margin, 60, Dimens.margin, 0),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(WidgetConstants.cornerRadius),
                  color: theme.colorScheme.surface,
                ),
                child: Column(
                  children: [
                    StreamBuilder<UserDetail>(
                        stream: bloc.detail,
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? SizedBox()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        await pushPage(
                                            context, FollowersPage());
                                      },
                                      child: Text("Followers".tr() +
                                          ": ${snapshot.data.followersCount ?? 0}"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await pushPage(context,
                                            FollowersPage(isFollowers: false));
                                      },
                                      child: Text("Following".tr() +
                                          ": ${snapshot.data.followingCount ?? 0}"),
                                    ),
                                  ],
                                );
                        }),
                    SizedBox(height: 25),
                    AppButton(
                      text: _isEditMode ? "Save".tr() : "Edit Profile".tr(),
                      height: 30,
                      foreground: theme.colorScheme.onPrimary,
                      elevation: 0,
                      onPressed: () async {
                        if (_isEditMode) {
                          await bloc.save();
                        }
                        setState(() {
                          _isEditMode = !_isEditMode;
                        });
                      },
                    ),
                    Spacing.vLarge,
                    _buildNameField(context),
                    Spacing.vertical,
                    _buildEmailField(context),
                    Spacing.vertical,
                    _buildGenderField(context),
                    Spacing.vertical,
                    _buildDateOfBirthField(context),
                    Spacing.vertical,
                    _buildPhoneField(context),
                    Spacing.vertical,
                    _buildAddressField(context),
                    Spacing.vertical,
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () async {
                    final image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      await bloc.updateImage(File(image.path));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: theme.backgroundColor, width: 8),
                        borderRadius: BorderRadius.circular(70)),
                    child: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        width: 120,
                        height: 120,
                        child: StreamBuilder<String>(
                            stream: bloc.imagePath,
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? Image.network(
                                      snapshot.data,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "assets/images/user.png",
                                      fit: BoxFit.cover,
                                    );
                            }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return StrTextField(
      bloc.name,
      labelText: "Name".tr(),
      prefixIcon: Icon(Icons.person),
      readOnly: !_isEditMode,
      border: OutlineInputBorder(),
      onChanged: bloc.onNameChanged,
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return StrTextField(
      bloc.email,
      labelText: "Email".tr(),
      prefixIcon: Icon(Icons.email),
      readOnly: !_isEditMode,
      border: OutlineInputBorder(),
      onChanged: bloc.onEmailChanged,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildGenderField(BuildContext context) {
    return StreamBuilder<String>(
        stream: bloc.gender,
        builder: (context, snapshot) {
          return DropdownButtonFormField(
            isExpanded: true,
            value: snapshot.data,
            decoration: InputDecoration(
              labelText: "Gender".tr(),
              prefixIcon: Icon(FontAwesomeIcons.male),
              border: OutlineInputBorder(),
            ),
            items: bloc.genders
                .map(
                  (value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.tr()),
                  ),
                )
                .toList(),
            isDense: true,
            onChanged: _isEditMode ? bloc.onGenderChanged : null,
          );
        });
  }

  Widget _buildDateOfBirthField(BuildContext context) {
    return StreamBuilder<DateTime>(
        stream: bloc.dob,
        builder: (context, snapshot) {
          return TextField(
            enabled: _isEditMode,
            decoration: InputDecoration(
              labelText: "Date of Birth".tr(),
              isDense: true,
              prefixIcon: Icon(Icons.date_range),
              border: OutlineInputBorder(),
            ),
            controller: snapshot.hasData
                ? TextEditingController(
                    text:
                        DateUtil.getFormattedDate(snapshot.data, "dd-MM-yyyy"))
                : null,
            onTap: () async {
              final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1980),
                  firstDate: DateTime(1960),
                  lastDate: DateTime.now());
              if (date != null) {
                bloc.onDobChanged(date);
              }
            },
          );
        });
  }

  Widget _buildPhoneField(BuildContext context) {
    return StrTextField(
      bloc.phone,
      labelText: "Phone".tr(),
      prefixIcon: Icon(Icons.phone),
      readOnly: !_isEditMode,
      border: OutlineInputBorder(),
      onChanged: bloc.onPhoneChanged,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildAddressField(BuildContext context) {
    return StrTextField(
      bloc.address,
      labelText: "Address".tr(),
      prefixIcon: Icon(Icons.location_history),
      readOnly: !_isEditMode,
      border: OutlineInputBorder(),
      onChanged: bloc.onAddressChanged,
    );
  }
}
