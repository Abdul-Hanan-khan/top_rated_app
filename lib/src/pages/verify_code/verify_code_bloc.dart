import 'dart:async';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/constants/preference_keys.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';
import 'package:top_rated_app/src/sdk/utils/pref_utils.dart';

class VerifyCodeBloc extends BaseBloc {
  final _resendCounterSubject = BehaviorSubject<String>();
  Stream<String> get resendCounter => _resendCounterSubject.stream;
  Function(String) get resendCounterSink => _resendCounterSubject.sink.add;

  final _verificationCodeSubject = BehaviorSubject<String>();
  Stream<String> get verificationCode => _verificationCodeSubject.stream;
  Function(String) get verificationCodeSink => _verificationCodeSubject.sink.add;

  Timer _timer;
  final _totalTimer = 120; // Seconds
  var _timerCounter = 0;
  String _email;

  VerifyCodeBloc(String email) {
    _resetTimer();
    _email = email;
    if (email == null) _sendCode();
  }

  void _resetTimer() {
    _timerCounter = _totalTimer;
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (_timerCounter == 0) return timer.cancel();
        _timerCounter -= 1;
        int minute = _timerCounter % 3600 ~/ 60;
        int second = _timerCounter % 60;
        resendCounterSink("${_formatTime(minute)}:${_formatTime(second)}");
      },
    );
  }

  String _formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  Future<void> _sendCode() async {
    final email = await PreferenceUtils.getString(PreferenceKeys.EMAIL, defaultValue: "");
    final password = await PreferenceUtils.getString(PreferenceKeys.PASSWORD, defaultValue: "");
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await AuthManager.instance.sendActivationCode(email, password);
      } catch (e) {
        sendError(e.toString());
      }
    }
  }

  Future<bool> onVerifyAction() async {
    final email = _email ?? await PreferenceUtils.getString(PreferenceKeys.EMAIL, defaultValue: "");
    final code = _verificationCodeSubject.valueOrNull ?? "";
    if (code.isEmpty) {
      sendError("Invalid code".tr());
      return false;
    }
    try {
      loading(true);
      final isVerified = await AuthManager.instance.verifyActivationCode(email, code);
      if (isVerified) {
        return true;
      } else {
        sendException("Invalid code".tr());
        return false;
      }
    } catch (e) {
      sendException("Invalid code".tr());
      return false;
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

  void onResendAction() {
    if (_timerCounter != 0) return;
    _resetTimer();
    if (_email != null)
      _sendCode();
    else
      sendResetPasswordCode(_email);
  }

  @override
  void dispose() async {
    super.dispose();
    await _resendCounterSubject.drain();
    _resendCounterSubject.close();
    await _verificationCodeSubject.drain();
    _verificationCodeSubject.close();
  }
}
