import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';

class ChangePasswordBloc extends BaseBloc {
  final _passwordSubject = BehaviorSubject<String>();
  Stream<String> get password => _passwordSubject.stream;
  Function(String) get onPasswordChanged => _passwordSubject.sink.add;

  final _confirmPasswordSubject = BehaviorSubject<String>();
  Stream<String> get confirmPassword => _confirmPasswordSubject.stream;
  Function(String) get onConfirmPasswordChanged => _confirmPasswordSubject.sink.add;

  final _loggedUserSubject = BehaviorSubject<bool>();
  Stream<bool> get loggedUser => _loggedUserSubject.stream;
  Function(bool) get _fetchedUser => _loggedUserSubject.sink.add;

  final String email;
  ChangePasswordBloc(this.email);

  Future<bool> update() async {
    final password = _passwordSubject.valueOrNull ?? "";
    final confirmPassword = _confirmPasswordSubject.valueOrNull ?? "";

    if (password.isEmpty) {
      this.sendException("Password is required");
      return false;
    }
    if (confirmPassword.isEmpty) {
      this.sendException("Confirm Password is required");
      return false;
    }
    if (password != confirmPassword) {
      this.sendException("Password doesn't match");
      return false;
    }

    try {
      loading(true);
      final isChanged = await ApiController.instance.updatePassword(email, password);
      if (isChanged) {
        final response = await AuthManager.instance.login(email, password);
        if (response.item1 != null) {
          _fetchedUser(response.item1.isAccountActivated);
          return true;
        } else {
          _fetchedUser(response.item2.isAccountActivated);
          return true;
        }
      }
      return false;
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
    await _passwordSubject.drain();
    _passwordSubject.close();

    await _confirmPasswordSubject.drain();
    _confirmPasswordSubject.close();

    await _loggedUserSubject.drain();
    _loggedUserSubject.close();
  }
}
