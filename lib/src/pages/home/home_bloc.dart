import 'package:rxdart/rxdart.dart';
import 'package:top_rated_app/src/app/app_bloc.dart';
import 'package:top_rated_app/src/sdk/base/bloc_base.dart';
import 'package:top_rated_app/src/sdk/models/category.dart';
import 'package:top_rated_app/src/sdk/models/city.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:top_rated_app/src/sdk/models/sub_category.dart';
import 'package:top_rated_app/src/sdk/networking/api_controller.dart';

class HomeBloc extends BaseBloc {
  final _categoriesSubject = BehaviorSubject<List<Category>>();
  Stream<List<Category>> get categories => _categoriesSubject.stream;
  Function(List<Category>) get _fetchedCategories => _categoriesSubject.sink.add;

  final _subCategoriesSubject = BehaviorSubject<List<SubCategory>>();
  Stream<List<SubCategory>> get subCategories => _subCategoriesSubject.stream;
  Function(List<SubCategory>) get _fetchedSubCategories => _subCategoriesSubject.sink.add;

  final _placesSubject = BehaviorSubject<List<Place>>();
  Stream<List<Place>> get places => _placesSubject.stream;
  Function(List<Place>) get _fetchedPlaces => _placesSubject.sink.add;

  final _selectCitySubject = BehaviorSubject<String>();
  Stream<String> get selectCity => _selectCitySubject.stream;
  Function(String) get _onSelectedCityChanged => _selectCitySubject.sink.add;

  final _sortByRatingSubject = BehaviorSubject<bool>();
  Stream<bool> get sortByRating => _sortByRatingSubject.stream;
  Function(bool) get onSortByRatingChanged => _sortByRatingSubject.sink.add;

  Category _selectedCategory;
  SubCategory _selectedSubCategory;
  List<City> cities;

  List<Place> _allPlaces;
  String _selectedCity;

  HomeBloc() {
    _fetchCategories();
    _fetchCities();
  }

  _fetchCategories() async {
    try {
      final categories = await ApiController.instance.getCategories();
      categories.removeWhere((element) => element.id == 34);
      _fetchedCategories(categories);
      if (categories.isNotEmpty) selectCategory(categories.first);
    } catch (e) {
      sendException(e.toString());
    }
  }

  _fetchCities() async {
    try {
      this.cities = await ApiController.instance.getCities();
    } catch (e) {
      sendException(e.toString());
    }
  }

  selectCategory(Category category) {
    _selectedCategory = category;
    _fetchedCategories(_categoriesSubject.valueOrNull ?? []);
    _fetchedSubCategories(_selectedCategory.subCategories);
    if (_selectedCategory.subCategories.isNotEmpty) {
      selectSubCategory(_selectedCategory.subCategories.first);
    }
  }

  selectSubCategory(SubCategory subCategory) {
    _selectedSubCategory = subCategory;
    _fetchedSubCategories(_selectedCategory.subCategories);
    _fetchPlaces();
  }

  _fetchPlaces() async {
    try {
      _fetchedPlaces(null);
      _allPlaces = await ApiController.instance.getPlaces(_selectedSubCategory.subId);
      AppBloc.instance.places = _allPlaces;
      filter();
    } catch (e) {
      sendException(e.toString());
      _fetchedPlaces([]);
    }
  }

  Category get selectedCategory {
    return _selectedCategory;
  }

  SubCategory get selectedSubCategory {
    return _selectedSubCategory;
  }

  onCityNameSelected(String cityName) {
    _selectedCity = cityName;
    _onSelectedCityChanged(cityName);
  }

  filter() {
    List<Place> places;
    if (_selectedCity != null) {
      places = _allPlaces
          .where((element) => (element.city.toLowerCase() ?? "").compareTo(_selectedCity.toLowerCase()) == 0)
          .toList();
    } else {
      places = _allPlaces.toList();
    }

    final sort = _sortByRatingSubject.valueOrNull ?? true;
    if (sort)
      places.sort((p1, p2) {
        return p2.getOverallrating().compareTo(p1.getOverallrating());
      });

    _fetchedPlaces(places);
  }

  onClearFilter() {
    _selectedCity = null;
    filter();
  }

  @override
  void dispose() async {
    super.dispose();
    await _categoriesSubject.drain();
    _categoriesSubject.close();
    await _subCategoriesSubject.drain();
    _subCategoriesSubject.close();
    await _placesSubject.drain();
    _placesSubject.close();
    await _selectCitySubject.drain();
    _selectCitySubject.close();
    await _sortByRatingSubject.drain();
    _sortByRatingSubject.close();
  }
}
