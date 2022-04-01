import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../constants/dimens.dart';
import 'image_picker_button.dart';

enum ImagePickerSource {
  gallery,
  camera,
  both
}

class SelectedImages extends StatefulWidget {
  final int limit;
  final ImagePickerSource source;
  _SelectedImagesState state;

  SelectedImages({this.limit = 1, this.source = ImagePickerSource.gallery});

  @override
  _SelectedImagesState createState() {
    this.state = new _SelectedImagesState();
    return state;
  }
}

class _SelectedImagesState extends State<SelectedImages> {
  List<File> _selectedImages = [];
  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: Dimens.margin_medium,
      runSpacing: Dimens.margin_medium,
      children: <Widget>[
        for (File file in _selectedImages)
          ClipRRect(
            borderRadius: BorderRadius.circular(WidgetConstants.cornerRadius),
            child: Image.file(
              file,
              width: 50,
              height: 50,
              fit: BoxFit.fill,
            ),
          ),
        ImagePickerButton(
          source: this.widget.source,
          onImageSelected: (image) {
            setState(() {
              if (_selectedImages.length >= widget.limit)
                _selectedImages.removeLast();
              _selectedImages.add(image);
            });
          },
        ),
      ],
    );
  }

  List<File> get images => _selectedImages;
}
