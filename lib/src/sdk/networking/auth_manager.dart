import 'dart:convert';
import 'dart:io';

import 'package:top_rated_app/src/sdk/constants/preference_keys.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:top_rated_app/src/sdk/models/user.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/utils/pref_utils.dart';
import 'package:tuple/tuple.dart';

class AuthManager {
  AuthManager._privateConstructor();
  static final AuthManager _instance = AuthManager._privateConstructor();
  static AuthManager get instance => _instance;
  User _user;
  Place _place;

  Future<Tuple2<User, Place>> login(String email, String password) async {
    try {
      final response = await ApiController.instance.login(email, password);
      if (response != null) {
        PreferenceUtils.saveString(PreferenceKeys.EMAIL, email);
        PreferenceUtils.saveString(PreferenceKeys.PASSWORD, password);
        if (response.item1 != null) {
          final user = response.item1;
          if (user.isAccountActivated) {
            PreferenceUtils.saveBool(PreferenceKeys.IS_USER_LOGGED_IN, true);
          } else {
            PreferenceUtils.saveBool(PreferenceKeys.IS_USER_LOGGED_IN, false);
          }
          _user = user;
        } else {
          final place = response.item2;
          if (place.isAccountActivated) {
            PreferenceUtils.saveBool(PreferenceKeys.IS_USER_LOGGED_IN, true);
          } else {
            PreferenceUtils.saveBool(PreferenceKeys.IS_USER_LOGGED_IN, false);
          }
          PreferenceUtils.saveBool(PreferenceKeys.IS_VENDOR, true);
          _place = place;
        }
      }
      return Tuple2(_user, _place);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<User> register(String firstName, String lastName, String email, String password) async {
    try {
      final user = await ApiController.instance.register(firstName, lastName, email, password);
      if (user != null) {
        PreferenceUtils.saveString(PreferenceKeys.EMAIL, email);
        PreferenceUtils.saveString(PreferenceKeys.PASSWORD, password);
        PreferenceUtils.saveBool(PreferenceKeys.IS_VENDOR, false);
      }
      return user;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<Place> registerVendor(
      String nameEng,
      String nameArb,
      String email,
      String password,
      String phone,
      int subCategoryId,
      String address,
      String bio,
      String website,
      String location,
      String imageName,
      String imageBase64) async {
    try {
      final place = await ApiController.instance.registerVendor(nameEng, nameArb, email, password, phone, subCategoryId,
          address, bio, website, location, imageName, imageBase64);
      if (place != null) {
        PreferenceUtils.saveString(PreferenceKeys.EMAIL, email);
        PreferenceUtils.saveString(PreferenceKeys.PASSWORD, password);
        PreferenceUtils.saveBool(PreferenceKeys.IS_VENDOR, true);
      }
      return place;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> sendActivationCode(String email, String password) async {
    try {
      final isSuccess = await ApiController.instance.sendActivationCode(email, password);
      return isSuccess;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> verifyActivationCode(String email, String code) async {
    try {
      final status = await ApiController.instance.verifyActivationCode(email, code);
      return status == UserStatus.active;
    } catch (e) {
      throw (e.toString());
    }
  }

  void logout() async {
    _user = null;
    _place = null;
    PreferenceUtils.saveBool(PreferenceKeys.IS_USER_LOGGED_IN, false);
    PreferenceUtils.remove(PreferenceKeys.IS_VENDOR);
    await PreferenceUtils.remove(PreferenceKeys.EMAIL);
    await PreferenceUtils.remove(PreferenceKeys.PASSWORD);
  }

  User get user => _user;
  Place get place => _place;

  Future<Map<String, String>> getAuthHeaders() async {
    final email = await PreferenceUtils.getString(PreferenceKeys.EMAIL);
    final password = await PreferenceUtils.getString(PreferenceKeys.PASSWORD);
    final credentials = '$email:$password';
    final stringToBase64 = utf8.fuse(base64);
    final encodedCredentials = stringToBase64.encode(credentials);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Basic $encodedCredentials",
    };
    return headers;
  }

  Future<bool> isLoggedIn() {
    return PreferenceUtils.getBool(PreferenceKeys.IS_USER_LOGGED_IN, defaultValue: false);
  }

  bool get isUserAccount => _user != null;
}
