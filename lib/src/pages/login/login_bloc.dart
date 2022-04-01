import 'package:email_validator/email_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/constants/preference_keys.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/utils/pref_utils.dart';

import '../../sdk/base/bloc_base.dart';
import '../../sdk/models/user.dart';
import '../../sdk/networking/auth_manager.dart';

class LoginBloc extends BaseBloc {
  LoginBloc() {
    checkLoginStatus();
  }

  final _emailSubject = BehaviorSubject<String>();
  Stream<String> get email => _emailSubject.stream;
  Function(String) get emailSink => _emailSubject.sink.add;

  final _passwordSubject = BehaviorSubject<String>();
  Stream<String> get password => _passwordSubject.stream;
  Function(String) get passwordSink => _passwordSubject.sink.add;

  final _loggedUserSubject = BehaviorSubject<bool>();
  Stream<bool> get loggedUser => _loggedUserSubject.stream;
  Function(bool) get _fetchedUser => _loggedUserSubject.sink.add;

  final _emailNotVerifiedSubject = BehaviorSubject<bool>();
  Stream<bool> get emailNotVerified => _emailNotVerifiedSubject.stream;
  Function(bool) get emailNotVerifiedSink => _emailNotVerifiedSubject.sink.add;

  Future<void> login() async {
    final email = _emailSubject.valueOrNull ?? "";
    final password = _passwordSubject.valueOrNull ?? "";

    if (email.isEmpty || !EmailValidator.validate(email)) {
      return this.sendException("Invalid Email");
    }
    if (password.isEmpty) {
      return this.sendException("Password is required");
    }

    return _performLogin(email, password);
  }

  void checkLoginStatus() async {
    if (await AuthManager.instance.isLoggedIn()) {
      _performLogin(
        await PreferenceUtils.getString(PreferenceKeys.EMAIL),
        await PreferenceUtils.getString(PreferenceKeys.PASSWORD),
      );
    }
  }

  Future<void> _performLogin(email, password) async {
    try {
      loading(true);
      final response = await AuthManager.instance.login(email, password);
      if (response.item1 != null) {
        _fetchedUser(response.item1.isAccountActivated);
        return response.item1.isAccountActivated;
      } else {
        final place = response.item2;
        if (place.emailStatus.toLowerCase().compareTo("unverified") == 0) {
          emailNotVerifiedSink(true);
        } else if (place.isAccountActivated) {
          _fetchedUser(place.isAccountActivated);
        } else {
          this.sendException(
              "Your account isn't activated by the team yet. We will revert to you within 36 hours via email.");
        }
      }
    } catch (e) {
      print(e);
      this.sendException(e);
    } finally {
      loading(false);
    }
  }

  Future<bool> sendResetPasswordCode(String email) async {
    try {
      loading(true);
      final response = await ApiController.instance.resetPassword(email);
      return response;
    } catch (e) {
      print(e);
      this.sendException(e.toString());
      return null;
    } finally {
      loading(false);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _emailSubject.drain();
    _emailSubject.close();
    await _passwordSubject.drain();
    _passwordSubject.close();
    await _loggedUserSubject.drain();
    _loggedUserSubject.close();
    await _emailNotVerifiedSubject.drain();
    _emailNotVerifiedSubject.close();
  }
}
