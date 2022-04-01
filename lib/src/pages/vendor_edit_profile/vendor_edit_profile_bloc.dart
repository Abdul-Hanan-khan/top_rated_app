import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/preference_keys.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:top_rated_app/src/sdk/models/place_detail.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/base64_utils.dart';
import 'package:top_rated_app/src/sdk/utils/pref_utils.dart';
import 'package:uuid/uuid.dart';

class VendorEditProfileBloc extends BaseBloc {
  final _nameEngSubject = BehaviorSubject<String>();
  Stream<String> get nameEng => _nameEngSubject.stream;
  Function(String) get onNameEngChanged => _nameEngSubject.sink.add;

  final _nameArbSubject = BehaviorSubject<String>();
  Stream<String> get nameArb => _nameArbSubject.stream;
  Function(String) get onNameArbChanged => _nameArbSubject.sink.add;

  final _emailSubject = BehaviorSubject<String>();
  Stream<String> get email => _emailSubject.stream;
  Function(String) get onEmailChanged => _emailSubject.sink.add;

  final _phoneSubject = BehaviorSubject<String>();
  Stream<String> get phone => _phoneSubject.stream;
  Function(String) get onPhoneChanged => _phoneSubject.sink.add;

  final _addressSubject = BehaviorSubject<String>();
  Stream<String> get address => _addressSubject.stream;
  Function(String) get onAddressChanged => _addressSubject.sink.add;

  final _citySubject = BehaviorSubject<String>();
  Stream<String> get city => _citySubject.stream;
  Function(String) get onCityChanged => _citySubject.sink.add;

  final _bioSubject = BehaviorSubject<String>();
  Stream<String> get bio => _bioSubject.stream;
  Function(String) get onBioChanged => _bioSubject.sink.add;

  final _websiteSubject = BehaviorSubject<String>();
  Stream<String> get website => _websiteSubject.stream;
  Function(String) get onWebsiteChanged => _websiteSubject.sink.add;

  final _locationSubject = BehaviorSubject<String>();
  Stream<String> get location => _locationSubject.stream;
  Function(String) get onLocationChanged => _locationSubject.sink.add;

  final _imagePathSubject = BehaviorSubject<String>();
  Stream<String> get imagePath => _imagePathSubject.stream;
  Function(String) get _onImagePathChanged => _imagePathSubject.sink.add;

  PlaceDetail _detail;

  VendorEditProfileBloc() {
    fetchDetail(AuthManager.instance.place);
    if (AuthManager.instance.place.image != null && AuthManager.instance.place.image.isNotEmpty)
      _onImagePathChanged("${AppConstants.imagePlaceBaseUrl}${AuthManager.instance.place.image}");
  }

  fetchDetail(Place place) async {
    try {
      loading(true);
      _detail = await ApiController.instance.getPlaceDetail(place.getId());

      onNameArbChanged(place.placeNameAr);
      onNameEngChanged(place.placeNameEng);
      onEmailChanged(place.email);
      onAddressChanged(_detail.address);
      onCityChanged(place.city);

      onPhoneChanged(_detail.phone);
      onLocationChanged(_detail.location);
      onWebsiteChanged(_detail.website);
      if (_detail.bio?.trim()?.isNotEmpty == true) onBioChanged(_detail.bio);
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
    }
  }

  Future<void> updateImage(File image) async {
    final base64 = image != null ? await Base64Utils.convertToBase64(image) : "";
    final imageName = image != null ? Uuid().v1() : "";

    try {
      loading(true);
      final path = await ApiController.instance.updatePlaceImage(imageName, base64);
      if (path != null) {
        _onImagePathChanged("${AppConstants.imagePlaceBaseUrl}$path");
        AuthManager.instance.place.image = path;
      }
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
    }
  }

  Future<bool> update() async {
    final nameEng = _nameEngSubject.valueOrNull ?? "";
    final nameArb = _nameArbSubject.valueOrNull ?? "";
    final email = _emailSubject.valueOrNull ?? "";
    final phone = _phoneSubject.valueOrNull ?? "";
    final address = _addressSubject.valueOrNull ?? "";
    final bio = _bioSubject.valueOrNull ?? "";
    final city = _citySubject.valueOrNull ?? "";
    final website = _websiteSubject.valueOrNull ?? "";
    final location = _locationSubject.valueOrNull ?? "";

    if (nameEng.isEmpty) {
      return this.sendException("Name English is required");
    }

    if (nameArb.isEmpty) {
      return this.sendException("Name Arabic is required");
    }

    if (email.isEmpty || !EmailValidator.validate(email)) {
      return this.sendException("Invalid Email");
    }

    var place = AuthManager.instance.place;
    place.placeNameEng = nameEng;
    place.placeNameAr = nameArb;
    place.email = email;

    try {
      loading(true);
      await ApiController.instance.updatePlace(place, address, phone, city, location, website, bio);
      PreferenceUtils.saveString(PreferenceKeys.EMAIL, email);
      return true;
    } catch (e) {
      sendException(e.toString());
      return false;
    } finally {
      loading(false);
    }
  }

  @override
  void dispose() async {
    super.dispose();

    await _nameEngSubject.drain();
    _nameEngSubject.close();

    await _nameArbSubject.drain();
    _nameArbSubject.close();

    await _phoneSubject.drain();
    _phoneSubject.close();

    await _addressSubject.drain();
    _addressSubject.close();

    await _websiteSubject.drain();
    _websiteSubject.close();

    await _bioSubject.drain();
    _bioSubject.close();

    await _locationSubject.drain();
    _locationSubject.close();

    await _citySubject.drain();
    _citySubject.close();

    await _imagePathSubject.drain();
    _imagePathSubject.close();
  }
}
