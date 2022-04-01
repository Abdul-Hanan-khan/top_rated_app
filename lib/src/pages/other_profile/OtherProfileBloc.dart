import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/models/user.dart';
import 'package:top_rated_app/src/sdk/models/user_detail.dart';
import 'package:top_rated_app/src/sdk/models/user_rating.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';

class OtherProfileBloc extends BaseBloc {
  final _userDetailSubject = BehaviorSubject<UserDetail>();
  Stream<UserDetail> get userDetail => _userDetailSubject.stream;
  Function(UserDetail) get _onDetailFetched => _userDetailSubject.sink.add;

  final _reviewsSubject = BehaviorSubject<List<UserRating>>();
  Stream<List<UserRating>> get reviews => _reviewsSubject.stream;
  Function(List<UserRating>) get _onReviewsFetched => _reviewsSubject.sink.add;

  int _userId;

  OtherProfileBloc(dynamic id) {
    if (id is String) {
      _userId = int.tryParse(id) ?? 0;
    } else if (id is int) {
      _userId = id as int;
    }
    _fetchUserDetail(_userId);
    _fetchUserReviews(_userId);
  }

  _fetchUserDetail(int id) async {
    try {
      loading(true);
      final detail = await ApiController.instance.getUserDetail(id: id);
      _onDetailFetched(detail);
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
    }
  }

  _fetchUserReviews(int id) async {
    try {
      final reviews = await ApiController.instance.getUserReviews(id);
      _onReviewsFetched(reviews);
    } catch (e) {
      sendException(e.toString());
    }
  }

  Future<bool> follow(bool isFollow) async {
    final follower = AuthManager.instance.user.id;
    try {
      loading(true);
      final success = await ApiController.instance.follow(follower, _userId, isFollow);
      return success;
    } catch (e) {
      sendException(e.toString());
      return false;
    } finally {
      loading(false);
      _fetchUserDetail(_userId);
    }
  }

  reply(int ratingId, String text) async {
    try {
      loading(true);
      await ApiController.instance.replyOnReview(ratingId, AuthManager.instance.user.id, text);
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
      _fetchUserReviews(_userId);
    }
  }

  like(int ratingId, bool isLike) async {
    try {
      loading(true);
      await ApiController.instance.like(ratingId, isLike);
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
      _fetchUserReviews(_userId);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _userDetailSubject.drain();
    _userDetailSubject.close();
    await _reviewsSubject.drain();
    _reviewsSubject.close();
  }
}
