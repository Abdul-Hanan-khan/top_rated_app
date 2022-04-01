import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/models/user_detail.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/base64_utils.dart';
import 'package:top_rated_app/src/sdk/utils/date_utils.dart';
import 'package:uuid/uuid.dart';

class ProfileBloc extends BaseBloc {
  UserDetail _userDetail;

  final _nameSubject = BehaviorSubject<String>();
  Stream<String> get name => _nameSubject.stream;
  Function(String) get onNameChanged => _nameSubject.sink.add;

  final _emailSubject = BehaviorSubject<String>();
  Stream<String> get email => _emailSubject.stream;
  Function(String) get onEmailChanged => _emailSubject.sink.add;

  final _phoneSubject = BehaviorSubject<String>();
  Stream<String> get phone => _phoneSubject.stream;
  Function(String) get onPhoneChanged => _phoneSubject.sink.add;

  final _addressSubject = BehaviorSubject<String>();
  Stream<String> get address => _addressSubject.stream;
  Function(String) get onAddressChanged => _addressSubject.sink.add;

  final _genderSubject = BehaviorSubject<String>();
  Stream<String> get gender => _genderSubject.stream;
  Function(String) get onGenderChanged => _genderSubject.sink.add;

  final _dobSubject = BehaviorSubject<DateTime>();
  Stream<DateTime> get dob => _dobSubject.stream;
  Function(DateTime) get onDobChanged => _dobSubject.sink.add;

  final _detailSubject = BehaviorSubject<UserDetail>();
  Stream<UserDetail> get detail => _detailSubject.stream;
  Function(UserDetail) get _onDetailChanged => _detailSubject.sink.add;

  final _imagePathSubject = BehaviorSubject<String>();
  Stream<String> get imagePath => _imagePathSubject.stream;
  Function(String) get _onImagePathChanged => _imagePathSubject.sink.add;

  final genders = ["Male", "Female"];

  ProfileBloc() {
    final user = AuthManager.instance.user;
    if (user != null) {
      onNameChanged(user.fullName);
      onEmailChanged(user.email);
      if (user.path != null && user.path.isNotEmpty)
        _onImagePathChanged("${AppConstants.imageUserBaseUrl}${user.path}");
    }
    fetchUserDetail();
  }

  fetchUserDetail() async {
    try {
      loading(true);
      _userDetail = await ApiController.instance.getUserDetail(id: AuthManager.instance.user.id);
      onPhoneChanged(_userDetail.phone);
      onAddressChanged(_userDetail.address);
      _onDetailChanged(_userDetail);
      if (_userDetail.birthdate != null && _userDetail.birthdate.isNotEmpty) {
        onDobChanged(DateUtil.getDateFromString(_userDetail.birthdate, "dd-MM-yyyy") ?? null);
      }
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
    }
  }

  Future<bool> save() async {
    final name = _nameSubject.valueOrNull ?? "";
    final email = _emailSubject.valueOrNull ?? "";
    final phone = _phoneSubject.valueOrNull ?? "";
    final address = _addressSubject.valueOrNull ?? "";
    final dob = _dobSubject.valueOrNull;

    if (name.isEmpty) {
      sendException("Name is required");
      return false;
    }

    if (email.isEmpty) {
      sendException("Email is required");
      return false;
    }

    final parts = name.split(" ");
    if (parts.length > 1) {
      AuthManager.instance.user.firstName = parts[0];
      AuthManager.instance.user.lastName = parts[1];
    } else {
      AuthManager.instance.user.firstName = parts[0];
      AuthManager.instance.user.lastName = "";
    }

    AuthManager.instance.user.email = email;

    _userDetail.phone = phone;
    _userDetail.address = address;

    if (dob != null) {
      _userDetail.birthdate = DateUtil.getFormattedDate(dob, "dd-MM-yyyy");
    }

    try {
      loading(true);
      final isSuccess = await ApiController.instance.updateUserDetail(AuthManager.instance.user, _userDetail);
      return isSuccess;
    } catch (e) {
      // sendException(e.toString());
      return false;
    } finally {
      loading(false);
    }
  }

  Future<void> updateImage(File image) async {
    final base64 = image != null ? await Base64Utils.convertToBase64(image) : "";
    final imageName = image != null ? Uuid().v1() : "";

    try {
      loading(true);
      final path = await ApiController.instance.updateUserImage(imageName, base64);
      if (path != null) {
        _onImagePathChanged("${AppConstants.imageUserBaseUrl}$path");
        AuthManager.instance.user.path = path;
      }
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _nameSubject.drain();
    _nameSubject.close();

    await _emailSubject.drain();
    _emailSubject.close();

    await _phoneSubject.drain();
    _phoneSubject.close();

    await _addressSubject.drain();
    _addressSubject.close();

    await _genderSubject.drain();
    _genderSubject.close();

    await _dobSubject.drain();
    _dobSubject.close();

    await _detailSubject.drain();
    _detailSubject.close();

    await _imagePathSubject.drain();
    _imagePathSubject.close();
  }
}
