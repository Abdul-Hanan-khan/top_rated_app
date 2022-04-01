import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:tuple/tuple.dart';

class VendorProfileBloc extends BaseBloc {
  final _dataSubject = BehaviorSubject<List<Tuple3<String, String, String>>>();
  Stream<List<Tuple3<String, String, String>>> get data => _dataSubject.stream;
  Function(List<Tuple3<String, String, String>>) get _onStatsFetched => _dataSubject.sink.add;

  VendorProfileBloc() {
    fetchStats();
  }

  fetchStats() async {
    try {
      loading(true);
      final stats = await ApiController.instance.getVendorStats();

      _onStatsFetched([
        Tuple3("rating.png", "Our Rating".tr(), "${stats.placeRating}"),
        Tuple3("review.png", "Last Reviews".tr(), stats.placeReviews),
        Tuple3("rated.png", "Category best rated".tr(), stats.bestRatedPlaces),
        Tuple3("reviews.png", "Reviews in category".tr(), stats.categoryReviews),
        Tuple3("downloads.png", "Store Downloads".tr(), stats.totalDownloads),
        Tuple3("reviewsapp.png", "Reviews on App".tr(), stats.totalReviews),
      ]);
    } catch (e) {
      sendError(e.toString());
    } finally {
      loading(false);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _dataSubject.drain();
    _dataSubject.close();
  }
}
