import 'package:flutter/material.dart';

import '../utils/textfield_utils.dart';

class StrTextField extends StatefulWidget {
  final Stream<String> stream;
  final Function(String) onChanged;
  final String hintText;
  final String labelText;
  final bool obsureText;
  final TextInputType keyboardType;
  final int maxLength;
  final int maxLines;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final bool readOnly;
  final InputBorder border;

  StrTextField(this.stream,
      {this.labelText,
      this.hintText,
      this.onChanged,
      this.obsureText = false,
      this.keyboardType,
      this.maxLength,
      this.maxLines,
      this.readOnly = false,
      this.prefixIcon,
      this.border,
      this.suffixIcon});

  @override
  _StrTextFieldState createState() => new _StrTextFieldState();
}

class _StrTextFieldState extends State<StrTextField> {
  TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: widget.stream,
        builder: (context, snapshot) {
          final data = snapshot.hasData ? snapshot.data : "";
          if (_textController == null && snapshot.hasData) {
            _textController = TextEditingController(text: data);
            _textController.selection = TextFieldUtils.getCursorPosition(_textController, data);
            _textController.selection = TextSelection.collapsed(offset: _textController.text.length);
          }
          return TextField(
            controller: _textController,
            decoration: InputDecoration(
                hintText: widget.hintText,
                labelText: widget.labelText,
                errorText: snapshot.error,
                border: widget.border,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon),
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            maxLines: widget.maxLines ?? 1,
            enabled: !widget.readOnly,
            obscureText: widget.obsureText,
            keyboardType: widget.keyboardType,
          );
        });
  }
}
