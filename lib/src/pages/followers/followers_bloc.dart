import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/models/user.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';

class FollowersBloc extends BaseBloc {
  final _followersSubject = BehaviorSubject<List<User>>();
  Stream<List<User>> get followers => _followersSubject.stream;
  Function(List<User>) get _fetchedFollowers => _followersSubject.sink.add;

  bool isFollowers = true;

  FollowersBloc(bool isFollowers) {
    this.isFollowers = isFollowers;
    fetchData();
  }

  fetchData() async {
    final id = AuthManager.instance.user.id;
    try {
      final list = isFollowers
          ? await ApiController.instance.getFollowersList(id)
          : await ApiController.instance.getFollowingList(id);
      _fetchedFollowers(list);
    } catch (e) {
      sendException(e.toString());
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _followersSubject.drain();
    _followersSubject.close();
  }
}
