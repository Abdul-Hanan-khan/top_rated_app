import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  final _isLoadingSubject = BehaviorSubject<bool>();
  final _errorSubject = BehaviorSubject<String>();
  final _exceptionSubject = BehaviorSubject<String>();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  Stream<String> get error => _errorSubject.stream;

  Function(bool) get loading => _isLoadingSubject.sink.add;
  Function(String) get sendError => _errorSubject.sink.add;

  Stream<String> get exception => _exceptionSubject.stream;
  Function(String) get sendException => _exceptionSubject.sink.add;

  void dispose() async {
    await _isLoadingSubject.drain();
    _isLoadingSubject.close();
    await _errorSubject.drain();
    _errorSubject.close();
    await _exceptionSubject.drain();
    _exceptionSubject.close();
  }
}
