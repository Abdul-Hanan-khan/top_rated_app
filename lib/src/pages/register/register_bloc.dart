import 'package:email_validator/email_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/models/user.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';

class RegisterBloc extends BaseBloc {
  final _firstNameSubject = BehaviorSubject<String>();
  Stream<String> get firstName => _firstNameSubject.stream;
  Function(String) get firstNameSink => _firstNameSubject.sink.add;

  final _lastNameSubject = BehaviorSubject<String>();
  Stream<String> get lastName => _lastNameSubject.stream;
  Function(String) get lastNameSink => _lastNameSubject.sink.add;

  final _emailSubject = BehaviorSubject<String>();
  Stream<String> get email => _emailSubject.stream;
  Function(String) get emailSink => _emailSubject.sink.add;

  final _passwordSubject = BehaviorSubject<String>();
  Stream<String> get password => _passwordSubject.stream;
  Function(String) get passwordSink => _passwordSubject.sink.add;

  final _confirmPasswordSubject = BehaviorSubject<String>();
  Stream<String> get confirmPassword => _confirmPasswordSubject.stream;
  Function(String) get confirmPasswordSink => _confirmPasswordSubject.sink.add;

  Future<User> register() async {
    final firstName = _firstNameSubject.valueOrNull ?? "";
    final lastName = _lastNameSubject.valueOrNull ?? "";
    final email = _emailSubject.valueOrNull ?? "";
    final password = _passwordSubject.valueOrNull ?? "";
    final confirmPassword = _confirmPasswordSubject.valueOrNull ?? "";

    if (firstName.isEmpty) {
      return this.sendException("First Name is required");
    }

    if (lastName.isEmpty) {
      return this.sendException("Last Name is required");
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

    try {
      loading(true);
      final user = await AuthManager.instance.register(firstName, lastName, email, password);
      return user;
    } catch (e) {
      print(e);
      this.sendException("Registration failed");
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
    await _firstNameSubject.drain();
    _firstNameSubject.close();
    await _lastNameSubject.drain();
    _lastNameSubject.close();
    await _confirmPasswordSubject.drain();
    _confirmPasswordSubject.close();
  }
}
