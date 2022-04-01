import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/app/app_bloc.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';

class SearchBloc extends BaseBloc {
  final _resultsSubject = BehaviorSubject<List<Place>>();
  Stream<List<Place>> get results => _resultsSubject.stream;
  Function(List<Place>) get _fetchedResults => _resultsSubject.sink.add;

  SearchBloc() {
    _fetchedResults(AppBloc.instance.places);
  }

  void onSearchTextChanged(String text) {
    final lower = text.toLowerCase();
    final filters = AppBloc.instance.places
        .where((element) => element.placeNameEng.toLowerCase().contains(lower) || element.placeNameAr.contains(lower))
        .toList();
    _fetchedResults(filters);
  }

  @override
  void dispose() async {
    super.dispose();
    await _resultsSubject.drain();
    _resultsSubject.close();
  }
}
