import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';
import 'package:top_rated_app/src/sdk/networking/auth_manager.dart';

class FavoritesBloc extends BaseBloc {
  final _placesSubject = BehaviorSubject<List<Place>>();
  Stream<List<Place>> get places => _placesSubject.stream;
  Function(List<Place>) get _fetchedPlaces => _placesSubject.sink.add;

  FavoritesBloc() {
    fetchFavoritePlaces();
  }

  fetchFavoritePlaces() async {
    try {
      loading(true);
      final places = await ApiController.instance.getFavoritePlaces(AuthManager.instance.user.id);
      _fetchedPlaces(places);
    } catch (e) {
      _fetchedPlaces([]);
    } finally {
      loading(false);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _placesSubject.drain();
    _placesSubject.close();
  }
}
