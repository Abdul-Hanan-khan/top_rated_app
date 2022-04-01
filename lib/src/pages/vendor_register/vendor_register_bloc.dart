import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/models/category.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:top_rated_app/src/sdk/models/sub_category.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/base64_utils.dart';
import 'package:uuid/uuid.dart';

class VendorRegisterBloc extends BaseBloc {
  final _categoriesSubject = BehaviorSubject<List<Category>>();
  Stream<List<Category>> get categories => _categoriesSubject.stream;
  Function(List<Category>) get _fetchedCategories => _categoriesSubject.sink.add;

  final _subCategoriesSubject = BehaviorSubject<List<SubCategory>>();
  Stream<List<SubCategory>> get subCategories => _subCategoriesSubject.stream;
  Function(List<SubCategory>) get _fetchedSubCategories => _subCategoriesSubject.sink.add;

  final _nameEngSubject = BehaviorSubject<String>();
  Stream<String> get nameEng => _nameEngSubject.stream;
  Function(String) get onNameEngChanged => _nameEngSubject.sink.add;

  final _nameArbSubject = BehaviorSubject<String>();
  Stream<String> get nameArb => _nameArbSubject.stream;
  Function(String) get onNameArbChanged => _nameArbSubject.sink.add;

  final _emailSubject = BehaviorSubject<String>();
  Stream<String> get email => _emailSubject.stream;
  Function(String) get onEmailChanged => _emailSubject.sink.add;

  final _passwordSubject = BehaviorSubject<String>();
  Stream<String> get password => _passwordSubject.stream;
  Function(String) get onPasswordChanged => _passwordSubject.sink.add;

  final _confirmPasswordSubject = BehaviorSubject<String>();
  Stream<String> get confirmPassword => _confirmPasswordSubject.stream;
  Function(String) get onConfirmPasswordChanged => _confirmPasswordSubject.sink.add;

  final _phoneSubject = BehaviorSubject<String>();
  Stream<String> get phone => _phoneSubject.stream;
  Function(String) get onPhoneChanged => _phoneSubject.sink.add;

  final _addressSubject = BehaviorSubject<String>();
  Stream<String> get address => _addressSubject.stream;
  Function(String) get onAddressChanged => _addressSubject.sink.add;

  final _bioSubject = BehaviorSubject<String>();
  Stream<String> get bio => _bioSubject.stream;
  Function(String) get onBioChanged => _bioSubject.sink.add;

  final _websiteSubject = BehaviorSubject<String>();
  Stream<String> get website => _websiteSubject.stream;
  Function(String) get onWebsiteChanged => _websiteSubject.sink.add;

  final _locationSubject = BehaviorSubject<String>();
  Stream<String> get location => _locationSubject.stream;
  Function(String) get onLocationChanged => _locationSubject.sink.add;

  final _selectedSubCategorySubject = BehaviorSubject<SubCategory>();
  Stream<SubCategory> get selectedSubCategory => _selectedSubCategorySubject.stream;
  Function(SubCategory) get onSubCategoryChanged => _selectedSubCategorySubject.sink.add;

  VendorRegisterBloc() {
    _fetchCategories();
  }

  Future<Place> register(File image) async {
    final nameEng = _nameEngSubject.valueOrNull ?? "";
    final nameArb = _nameArbSubject.valueOrNull ?? "";
    final email = _emailSubject.valueOrNull ?? "";
    final password = _passwordSubject.valueOrNull ?? "";
    final confirmPassword = _confirmPasswordSubject.valueOrNull ?? "";
    final phone = _phoneSubject.valueOrNull ?? "";
    final address = _addressSubject.valueOrNull ?? "";
    final bio = _addressSubject.valueOrNull ?? "";
    final website = _websiteSubject.valueOrNull ?? "";
    final location = _locationSubject.valueOrNull ?? "";
    final subCategory = _selectedSubCategorySubject.valueOrNull;

    if (nameEng.isEmpty) {
      return this.sendException("Name English is required");
    }

    if (nameArb.isEmpty) {
      return this.sendException("Name Arabic is required");
    }

    if (email.isEmpty || !EmailValidator.validate(email)) {
      return this.sendException("Invalid Email");
    }
    if (password.isEmpty) {
      return this.sendException("Password is required");
    }
    if (confirmPassword.isEmpty) {
      return this.sendException("Confirm Password is required");
    }
    if (password != confirmPassword) {
      return this.sendException("Password doesn't match");
    }

    if (subCategory == null) {
      return this.sendException("SubCategory is Required");
    }

    final base64 = image != null ? await Base64Utils.convertToBase64(image) : "";
    final imageName = image != null ? Uuid().v1() : "";

    try {
      loading(true);
      final data = await AuthManager.instance.registerVendor(nameEng, nameArb, email, password, phone,
          subCategory.subId, address, bio, website, location, imageName, base64);
      return data;
    } catch (e) {
      sendException(e.toString());
      return null;
    } finally {
      loading(false);
    }
  }

  _fetchCategories() async {
    loading(true);
    try {
      final categories = await ApiController.instance.getCategories();
      _fetchedCategories(categories);
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
    }
  }

  selectCategory(Category category) {
    onSubCategoryChanged(null);
    _fetchedSubCategories(category.subCategories ?? []);
  }

  @override
  void dispose() async {
    super.dispose();

    await _nameEngSubject.drain();
    _nameEngSubject.close();

    await _nameArbSubject.drain();
    _nameArbSubject.close();

    await _emailSubject.drain();
    _emailSubject.close();

    await _passwordSubject.drain();
    _passwordSubject.close();

    await _confirmPasswordSubject.drain();
    _confirmPasswordSubject.close();

    await _phoneSubject.drain();
    _phoneSubject.close();

    await _addressSubject.drain();
    _addressSubject.close();

    await _websiteSubject.drain();
    _websiteSubject.close();

    await _bioSubject.drain();
    _bioSubject.close();

    await _categoriesSubject.drain();
    _categoriesSubject.close();

    await _subCategoriesSubject.drain();
    _subCategoriesSubject.close();

    await _selectedSubCategorySubject.drain();
    _selectedSubCategorySubject.close();

    await _locationSubject.drain();
    _locationSubject.close();
  }
}
