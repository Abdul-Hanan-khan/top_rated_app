import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


import 'package:top_rated_app/src/pages/main/main_page.dart';
import 'package:top_rated_app/testing_class.dart';

import '../../app_widgets/venders_grid_view.dart';
import '../../sdk/constants/dimens.dart';
import '../../sdk/constants/spacing.dart';
import '../../sdk/models/category.dart';
import '../../sdk/models/place.dart';
import '../../sdk/models/sub_category.dart';
import '../../sdk/networking/auth_manager.dart';
import '../../sdk/utils/navigation_utils.dart';
import '../../sdk/utils/ui_utils.dart';
import '../../sdk/widgets/category_item.dart';
import '../../sdk/widgets/subcategory_item.dart';
import '../vendor_detail/vendor_detail_page.dart';
import 'home_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  ThemeData theme;
  BuildContext _context;
  HomeBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = new HomeBloc();
    bloc.error.listen((event) {
      UIUtils.showAdaptiveDialog(_context, "Error", event);
    });
    bloc.exception.listen((event) {
      UIUtils.showAdaptiveDialog(_context, "Error", event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Builder(
        builder: (context) {
          _context = context;
          return _buildBody(context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        child: Icon(Icons.language_outlined,),
        onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>TestingClass()));
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>TestHome()));
          // Get.to(TestingClass());

        }

        // => Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => LanguagePage()),
        // ),
      ),
    );
  }



  onFilterClick() {
    _showSortDialog(context);
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Spacing.vertical,
        StreamBuilder<List<Category>>(
            stream: bloc.categories,
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      height: 80,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final category = snapshot.data[index];
                          return CategoryItem(
                            category: category,
                            isSelected: bloc.selectedCategory.id == category.id,
                            onClick: () {
                              bloc.selectCategory(category);
                            },
                          );
                        },
                      ),
                    );
            }),
        Container(
          color: theme.colorScheme.surface,
          height: 80,
          child: Center(
            child: StreamBuilder<List<SubCategory>>(
                stream: bloc.subCategories,
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? SizedBox()
                      : ListView.builder(
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final subCategory = snapshot.data[index];
                            return SubCategoryItem(
                              subCategory: subCategory,
                              isSelected: subCategory.subId == bloc.selectedSubCategory?.subId,
                              onClick: () {
                                bloc.selectSubCategory(subCategory);
                              },
                            );
                          },
                        );
                }),
          ),
        ),
        Expanded(
          child: Container(
            color: theme.colorScheme.surface,
            child: Container(
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.fromLTRB(Dimens.margin, Dimens.margin, Dimens.margin, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimens.margin),
                    topRight: Radius.circular(
                      Dimens.margin,
                    )),
                color: theme.colorScheme.background,
              ),
              child: StreamBuilder<List<Place>>(
                  stream: bloc.places,
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(child: CircularProgressIndicator())
                        : VendorsGridView(
                            snapshot.data,
                            onItemClick: (item) {
                              if (AuthManager.instance.isUserAccount)
                                pushPage(
                                    context,
                                    VendorDetailPage(
                                      place: item,
                                    ));
                            },
                          );
                  }),
            ),
          ),
        )
      ],
    );
  }

  _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: Dimens.margin, right: Dimens.margin, top: Dimens.margin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sort".tr(),
                      style: theme.textTheme.headline6.copyWith(color: theme.accentColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sort by Rating:".tr()),
                        StreamBuilder<bool>(
                            stream: bloc.sortByRating,
                            initialData: true,
                            builder: (context, snapshot) {
                              return Checkbox(
                                value: snapshot.data,
                                onChanged: bloc.onSortByRatingChanged,
                              );
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Area:".tr()),
                        StreamBuilder<String>(
                            stream: bloc.selectCity,
                            builder: (context, snapshot) {
                              return DropdownButton<String>(
                                value: snapshot.data,
                                items: bloc.cities.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.name,
                                    child: new Text(value.name.tr()),
                                  );
                                }).toList(),
                                onChanged: (name) {
                                  bloc.onCityNameSelected(name);
                                },
                              );
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      bloc.onClearFilter();
                      popPage(context);
                    },
                    child: Text(
                      "Clear".tr(),
                      style: theme.textTheme.subtitle1,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      bloc.filter();
                      popPage(context);
                    },
                    child: Text(
                      "Apply".tr(),
                      style: theme.textTheme.subtitle1.copyWith(color: theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}



