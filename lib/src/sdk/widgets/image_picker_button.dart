import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/app_theme.dart';
import '../constants/app_constants.dart';
import 'selected_images.dart';

class ImagePickerButton extends StatelessWidget {
  final Function(File) onImageSelected;
  final ImagePickerSource source;

  ImagePickerButton({
    @required this.onImageSelected,
    this.source = ImagePickerSource.gallery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: AppColor.textFieldFill,
          borderRadius: BorderRadius.circular(WidgetConstants.cornerRadius)),
      child: IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.grey,
          size: 24,
        ),
        onPressed: () async {
          final picker = ImagePicker();

          ImageSource imageSource = ImageSource.gallery;
          if (source == ImagePickerSource.camera) {
            imageSource = ImageSource.camera;
          }

          final pickedFile = await picker.getImage(source: imageSource);
          if (pickedFile != null) {
            onImageSelected(File(pickedFile.path));
          }
        },
      ),
    );
  }
}
