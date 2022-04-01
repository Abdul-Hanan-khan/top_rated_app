import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_rated_app/src/pages/change_password/change_password_page.dart';
import 'package:top_rated_app/src/pages/vendor_edit_profile/vendor_edit_profile_bloc.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/utils/widget_utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/sdk/widgets/app_button.dart';
import 'package:top_rated_app/src/sdk/widgets/screen_progress_loader.dart';
import 'package:top_rated_app/src/sdk/widgets/stream_text_field.dart';

class VendorEditProfilePage extends StatefulWidget {
  @override
  _VendorEditProfilePageState createState() => new _VendorEditProfilePageState();
}

class _VendorEditProfilePageState extends State<VendorEditProfilePage> {
  ThemeData theme;
  BuildContext _context;
  VendorEditProfileBloc bloc;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    bloc = new VendorEditProfileBloc();
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
      title: Text("Edit Profile".tr()),
      leading: WidgetUtils.getAdaptiveBackButton(context),
      actions: [
        IconButton(
          icon: Icon(Icons.password, color: theme.primaryColor),
          onPressed: () {
            pushPage(
                context,
                ChangePasswordPage(
                  email: AuthManager.instance.place.email,
                ));
          },
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(Dimens.margin),
      children: [
        _buildImage(context),
        Spacing.vertical,
        _buildNameEngField(context),
        Spacing.vertical,
        _buildNameArbField(context),
        Spacing.vertical,
        _buildEmailField(context),
        Spacing.vertical,
        _buildAddressField(context),
        // Spacing.vertical,
        // _buildCityField(context),
        Spacing.vertical,
        _buildPhoneField(context),
        Spacing.vertical,
        _buildLocationField(context),
        Spacing.vertical,
        _buildWebsiteField(context),
        Spacing.vertical,
        _buildBioField(context),
        Spacing.vLarge,
        _buildUpdateButton(context)
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () async {
          final image = await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            await bloc.updateImage(File(image.path));
          }
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: theme.backgroundColor, width: 8), borderRadius: BorderRadius.circular(70)),
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
    );
  }

  Widget _buildNameEngField(BuildContext context) {
    return StrTextField(
      bloc.nameEng,
      onChanged: bloc.onNameEngChanged,
      hintText: "Vendor Name (English)".tr(),
    );
  }

  Widget _buildNameArbField(BuildContext context) {
    return StrTextField(
      bloc.nameArb,
      onChanged: bloc.onNameArbChanged,
      hintText: "Vendor Name (Arabic)".tr(),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return StrTextField(
      bloc.email,
      hintText: "Email",
      onChanged: bloc.onEmailChanged,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildCityField(BuildContext context) {
    return StrTextField(
      bloc.city,
      onChanged: bloc.onCityChanged,
      hintText: "City",
    );
  }

  Widget _buildAddressField(BuildContext context) {
    return StrTextField(
      bloc.address,
      onChanged: bloc.onAddressChanged,
      hintText: "Address",
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return StrTextField(
      bloc.phone,
      onChanged: bloc.onPhoneChanged,
      hintText: "Phone",
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildWebsiteField(BuildContext context) {
    return StrTextField(
      bloc.website,
      onChanged: bloc.onWebsiteChanged,
      hintText: "Website",
    );
  }

  Widget _buildLocationField(BuildContext context) {
    return StrTextField(
      bloc.location,
      onChanged: bloc.onLocationChanged,
      hintText: "Location (Google Place link from Google maps share)",
    );
  }

  Widget _buildBioField(BuildContext context) {
    return StrTextField(
      bloc.bio,
      onChanged: bloc.onBioChanged,
      hintText: "Bio",
      maxLines: 3,
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return AppButton(
      text: "Update",
      background: theme.accentColor,
      onPressed: () async {
        if (await bloc.update()) {
          popPage(context);
        }
      },
    );
  }
}
