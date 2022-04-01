import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_rated_app/src/pages/vendor_message/vendor_message_bloc.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/utils/widget_utils.dart';
import 'package:top_rated_app/src/sdk/widgets/app_button.dart';
import 'package:top_rated_app/src/sdk/widgets/screen_progress_loader.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/sdk/widgets/stream_text_field.dart';

class VendorMessagePage extends StatefulWidget {
  @override
  _VendorMessagePageState createState() => new _VendorMessagePageState();
}

class _VendorMessagePageState extends State<VendorMessagePage> {
  ThemeData theme;
  BuildContext _context;
  VendorMessageBloc bloc;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  File _selectedImage;

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    bloc = new VendorMessageBloc();
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
      title: Text("New Announcement".tr()),
      leading: WidgetUtils.getAdaptiveBackButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(Dimens.margin),
      children: [
        _buildImageCard(),
        Spacing.vertical,
        Align(child: _buildSelectImageButton()),
        Spacing.vertical,
        _buildNameField(context),
        Spacing.vertical,
        _buildMessageField(context),
        Spacing.vLarge,
        _buildSendButton(context),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return StrTextField(
      bloc.title,
      hintText: "Title".tr(),
      onChanged: bloc.onTitleChanged,
    );
  }

  Widget _buildMessageField(BuildContext context) {
    return StrTextField(
      bloc.message,
      hintText: "Message".tr(),
      maxLines: 5,
      onChanged: bloc.onMessageChanged,
    );
  }

  Widget _buildSelectImageButton() {
    return AppButton(
      text: "Select Image".tr(),
      height: 30,
      onPressed: () async {
        final image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            _selectedImage = File(image.path);
          });
        }
      },
    );
  }

  Widget _buildImageCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(WidgetConstants.cornerRadius),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(WidgetConstants.cornerRadius),
        ),
        child: _selectedImage != null
            ? Image.file(
                _selectedImage,
                fit: BoxFit.cover,
              )
            : Container(),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return AppButton(
      text: "Send".tr(),
      onPressed: () async {
        final message = await bloc.sendAnnouncements(image: _selectedImage);
        if (message != null) {
          UIUtils.showAdaptiveDialog(
            context,
            "Success".tr(),
            message,
            onPressed: () {
              popPage(_context);
            },
          );
        }
      },
    );
  }
}
