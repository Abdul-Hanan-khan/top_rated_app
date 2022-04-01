import 'dart:io';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/utils/base64_utils.dart';
import 'package:uuid/uuid.dart';

class VendorMessageBloc extends BaseBloc {
  final _titleSubject = BehaviorSubject<String>();
  Stream<String> get title => _titleSubject.stream;
  Function(String) get onTitleChanged => _titleSubject.sink.add;

  final _messageSubject = BehaviorSubject<String>();
  Stream<String> get message => _messageSubject.stream;
  Function(String) get onMessageChanged => _messageSubject.sink.add;

  Future<String> sendAnnouncements({File image}) async {
    final title = _titleSubject.valueOrNull ?? "";
    final message = _messageSubject.valueOrNull ?? "";

    if (title.isEmpty) {
      sendException("Title is required".tr());
      return null;
    }

    if (message.isEmpty) {
      sendException("Message is required".tr());
      return null;
    }

    final base64 = image != null ? await Base64Utils.convertToBase64(image) : "";
    final imageName = image != null ? Uuid().v1() : "";

    try {
      loading(true);
      return await ApiController.instance.message(title, message, imageBase64: base64, imageName: imageName);
    } catch (e) {
      sendException(e.toString());
      return null;
    } finally {
      loading(false);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _titleSubject.drain();
    _titleSubject.close();
    await _messageSubject.drain();
    _messageSubject.close();
  }
}
