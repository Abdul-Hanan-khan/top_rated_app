import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:top_rated_app/src/sdk/models/place_detail.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';

class VendorDetailBloc extends BaseBloc {
  final _detailSubject = BehaviorSubject<PlaceDetail>();
  Stream<PlaceDetail> get detail => _detailSubject.stream;
  Function(PlaceDetail) get _fetchedDetail => _detailSubject.sink.add;

  Place _place;
  PlaceDetail _detail;

  VendorDetailBloc(Place place) {
    _place = place;
    fetchDetail(place);
  }

  fetchDetail(Place place) async {
    try {
      loading(true);
      _detail = await ApiController.instance.getPlaceDetail(place.getId());
      _fetchedDetail(_detail);
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
    }
  }

  String getLocationURL() {
    return _detail.location.tr() ?? "";
  }

  reply(int ratingId, String text) async {
    try {
      loading(true);
      await ApiController.instance.replyOnReview(ratingId, AuthManager.instance.user.id, text);
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
      fetchDetail(_place);
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
      fetchDetail(_place);
    }
  }

  favorite(bool isFavorite) async {
    try {
      loading(true);
      await ApiController.instance.favorite(_place.getId(), isFavorite);
    } catch (e) {
      sendException(e.toString());
    } finally {
      loading(false);
      fetchDetail(_place);
    }
  }

  PlaceDetail get placeDetail {
    return _detailSubject.valueOrNull;
  }

  @override
  void dispose() async {
    super.dispose();
    await _detailSubject.drain();
    _detailSubject.close();
  }
}
