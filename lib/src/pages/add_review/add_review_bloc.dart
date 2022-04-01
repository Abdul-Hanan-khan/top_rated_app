import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:top_rated_app/src/sdk/models/rating_type.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';

class AddReviewBloc extends BaseBloc {
  AddReviewBloc() {
    _fetchRatingTypes();
  }

  Map<String, double> _ratings = new HashMap();

  final _typesSubject = BehaviorSubject<List<RatingType>>();
  Stream<List<RatingType>> get types => _typesSubject.stream;
  Function(List<RatingType>) get _onTypesFetched => _typesSubject.sink.add;

  final _reviewSubject = BehaviorSubject<String>();
  Stream<String> get review => _reviewSubject.stream;
  Function(String) get onReviewChanged => _reviewSubject.sink.add;

  void _fetchRatingTypes() async {
    try {
      loading(true);
      final types = await ApiController.instance.getRatingTypes();
      types.forEach((element) => updateRating(element.getId(), 0));
      _onTypesFetched(types);
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
    }
  }

  void updateRating(int id, double rating) {
    final key = "$id";
    if (_ratings.containsKey(key)) {
      _ratings[key] = rating;
    } else {
      _ratings.putIfAbsent(key, () => rating);
    }
  }

  Future<bool> submitRating(Place place) async {
    final review = _reviewSubject.valueOrNull ?? "";
    try {
      loading(true);
      return await ApiController.instance.postUserReview(place.getId(), AuthManager.instance.user.id, review, _ratings);
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
    }
    return false;
  }

  @override
  void dispose() async {
    super.dispose();
    await _reviewSubject.drain();
    _reviewSubject.close();
    await _typesSubject.drain();
    _typesSubject.close();
  }
}
