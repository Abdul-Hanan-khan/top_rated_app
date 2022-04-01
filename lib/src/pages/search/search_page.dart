import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/app/app_theme.dart';
import 'package:top_rated_app/src/app_widgets/venders_grid_view.dart';
import 'package:top_rated_app/src/pages/search/search_bloc.dart';
import 'package:top_rated_app/src/pages/vendor_detail/vendor_detail_page.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/utils/widget_utils.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ThemeData theme;
  BuildContext _context;
  SearchBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = new SearchBloc();
    bloc.error.listen((event) {
      UIUtils.showAdaptiveDialog(_context, "Error".tr(), event);
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
      appBar: _buildAppBar(context),
      body: Builder(
        builder: (context) {
          _context = context;
          return _buildBody(context);
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: _buildSearchField(),
      leading: WidgetUtils.getAdaptiveBackButton(context),
    );
  }

  Widget _buildSearchField() {
    final lineColor = AppColor.primaryTextColor;
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search...".tr(),
        hintStyle: theme.textTheme.bodyText1.copyWith(color: AppColor.primaryTextColor.withAlpha(150), fontSize: 18),
        filled: false,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: lineColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: lineColor),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: lineColor),
        ),
      ),
      cursorColor: theme.colorScheme.primary,
      cursorWidth: 1,
      style: theme.textTheme.bodyText1.copyWith(color: AppColor.primaryTextColor, fontSize: 18),
      textInputAction: TextInputAction.search,
      onChanged: (query) => bloc.onSearchTextChanged(query),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.margin),
      child: StreamBuilder<List<Place>>(
          stream: bloc.results,
          builder: (context, snapshot) {
            return Column(
              children: [
                Expanded(
                  child: VendorsGridView(
                    snapshot.data,
                    onItemClick: (item) {
                      pushPage(context, VendorDetailPage(place: item));
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
