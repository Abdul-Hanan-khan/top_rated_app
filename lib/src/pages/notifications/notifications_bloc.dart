import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/models/message.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';

class NotificationsBloc extends BaseBloc {
  final _notificationsSubject = BehaviorSubject<List<Message>>();
  Stream<List<Message>> get notifications => _notificationsSubject.stream;
  Function(List<Message>) get _fetchedNotifications => _notificationsSubject.sink.add;

  NotificationsBloc() {
    fetchNotifications();
  }

  fetchNotifications() async {
    try {
      final objs = await ApiController.instance.getNotifications();
      _fetchedNotifications(objs);
    } catch (e) {
      _notificationsSubject.addError(e.toString());
      sendException(e.toString());
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _notificationsSubject.drain();
    _notificationsSubject.close();
  }
}
