import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_rated_app/src/pages/verify_code/verify_code_page.dart';
import 'package:top_rated_app/src/sdk/utils/intent_utils.dart';

import '../../sdk/constants/app_constants.dart';
import '../../sdk/constants/dimens.dart';
import '../../sdk/constants/spacing.dart';
import '../../sdk/models/category.dart';
import '../../sdk/models/sub_category.dart';
import '../../sdk/utils/navigation_utils.dart';
import '../../sdk/utils/ui_utils.dart';
import '../../sdk/widgets/app_button.dart';
import '../../sdk/widgets/screen_progress_loader.dart';
import '../../sdk/widgets/stream_text_field.dart';
import 'vendor_register_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
class VendorRegisterPage extends StatefulWidget {
  @override
  _VendorRegisterPageState createState() => new _VendorRegisterPageState();
}

class _VendorRegisterPageState extends State<VendorRegisterPage> {
  ThemeData theme;
  BuildContext _context;
  VendorRegisterBloc bloc;
  bool _isLoading = false;
  ImagePicker _picker = ImagePicker();
  File _selectedImage = null;
  var isOtherSubCategory = false;

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    bloc = new VendorRegisterBloc();
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
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(Dimens.margin),
        children: [
          _buildImage(context),
          Spacing.vertical,
          _buildNameEngField(context),
          Spacing.vertical,
          _buildNameArbField(context),
          Spacing.vertical,
          _buildEmailField(context),
          Spacing.vertical,
          _buildPasswordField(context),
          Spacing.vertical,
          _buildConfirmPasswordField(context),
          Spacing.vertical,
          _buildAddressField(context),
          Spacing.vertical,
          _buildPhoneField(context),
          Spacing.vertical,
          _buildLocationField(context),
          Spacing.vertical,
          _buildWebsiteField(context),
          Spacing.vertical,
          _buildBioField(context),
          Spacing.vertical,
          _buildCategoriesField(context),
          Spacing.vertical,
          _buildSubCategoriesField(context),
          StreamBuilder<SubCategory>(
              stream: bloc.selectedSubCategory,
              builder: (context, snapshot) {
                if (snapshot.hasData && (snapshot.data.nameEng.compareTo("Other") == 0))
                  return _buildContactUs(context);
                else
                  return SizedBox();
              }),
          Spacing.vertical,
          Row(
            children: [
              Expanded(child: _buildRegisterButton(context)),
            ],
          ),
          _buildBackButton(context),
        ],
      ),
    );
  }

  Widget _buildContactUs(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          IntentUtils.initMail("toprated@gmail.com".tr(), "Unavaiable Category".tr(), "");
        },
        child: RichText(
            text: TextSpan(style: theme.textTheme.subtitle2, children: [
          TextSpan(text: "Can't see your category".tr()+" ?"),
          TextSpan(text: "Contact Us".tr(), style: TextStyle(color: theme.primaryColor)),
        ])),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () async {
          final image = await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            setState(() {
              _selectedImage = File(image.path);
            });
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
              color: Colors.grey,
              child: _selectedImage == null
                  ? SizedBox()
                  : Image.file(
                      _selectedImage,
                      fit: BoxFit.cover,
                    ),
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
      hintText: "Email".tr(),
      onChanged: bloc.onEmailChanged,
      keyboardType: TextInputType.emailAddress,
    );
  }

  var _showPassword = false;
  Widget _buildPasswordField(BuildContext context) {
    return StrTextField(
      bloc.password,
      hintText: "Password".tr(),
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

  Widget _buildAddressField(BuildContext context) {
    return StrTextField(
      bloc.address,
      onChanged: bloc.onAddressChanged,
      hintText: "Address".tr(),
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return StrTextField(
      bloc.phone,
      onChanged: bloc.onPhoneChanged,
      hintText: "Phone".tr(),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildWebsiteField(BuildContext context) {
    return StrTextField(
      bloc.website,
      onChanged: bloc.onWebsiteChanged,
      hintText: "Website".tr(),
    );
  }

  Widget _buildLocationField(BuildContext context) {
    return StrTextField(
      bloc.location,
      onChanged: bloc.onLocationChanged,
      hintText: "Location (Google Place link from Google maps share)".tr(),
    );
  }

  Widget _buildCategoriesField(BuildContext context) {
    return StreamBuilder<List<Category>>(
        stream: bloc.categories,
        initialData: [],
        builder: (context, snapshot) {
          return DropdownButtonFormField(
            isExpanded: true,
            value: null,
            decoration: InputDecoration(
              hintText: "Category".tr(),
            ),
            items: snapshot.data
                .map(
                  (value) => DropdownMenuItem<Category>(
                    value: value,
                    child: Text(value.nameEng.tr()),
                  ),
                )
                .toList(),
            isDense: true,
            onChanged: bloc.selectCategory,
          );
        });
  }

  Widget _buildSubCategoriesField(BuildContext context) {
    return StreamBuilder<List<SubCategory>>(
        stream: bloc.subCategories,
        initialData: [],
        builder: (context, snapshot) {
          return StreamBuilder<SubCategory>(
              stream: bloc.selectedSubCategory,
              builder: (context, subSnapShot) {
                return DropdownButtonFormField(
                  isExpanded: true,
                  value: subSnapShot.data ?? null,
                  decoration: InputDecoration(
                    hintText: "Sub Category".tr(),
                  ),
                  items: snapshot.data
                      .map(
                        (value) => DropdownMenuItem<SubCategory>(
                          value: value,
                          child: Text(value.nameEng.tr()),
                        ),
                      )
                      .toList(),
                  isDense: true,
                  onChanged: bloc.onSubCategoryChanged,
                );
              });
        });
  }

  Widget _buildBioField(BuildContext context) {
    return StrTextField(
      bloc.bio,
      onChanged: bloc.onBioChanged,
      hintText: "Bio".tr(),
      maxLines: 3,
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return AppButton(
      text: "Sign up as Vendor".tr(),
      background: theme.accentColor,
      onPressed: () async {
        final vendor = await bloc.register(_selectedImage);
        if (vendor == null) {
          UIUtils.showAdaptiveDialog(
            _context,
            "Success".tr(),
            "Thanks for signing up. Check your email address for verification code".tr(),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(Routes.verification);
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
        TextSpan(text: "Already have an Account".tr()+" ?"),
        TextSpan(text: "Sign in".tr(), style: TextStyle(color: theme.primaryColor)),
      ])),
    );
  }
}
