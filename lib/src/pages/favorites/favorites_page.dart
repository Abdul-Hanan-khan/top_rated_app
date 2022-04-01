import 'package:flutter/material.dart';
import 'package:top_rated_app/src/app_widgets/venders_grid_view.dart';
import 'package:top_rated_app/src/pages/favorites/favorites_bloc.dart';
import 'package:top_rated_app/src/pages/vendor_detail/vendor_detail_page.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/widgets/screen_progress_loader.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => new _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  ThemeData theme;
  BuildContext _context;
  FavoritesBloc bloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    bloc = new FavoritesBloc();
    bloc.isLoading.listen((event) {
      setState(() {
        _isLoading = event;
      });
    });

    bloc.exception.listen((event) {
      UIUtils.showAdaptiveDialog(_context, "Error", event);
    });
    bloc.error.listen((event) {
      UIUtils.showError(_context, event);
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
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Builder(
            builder: (context) {
              _context = context;
              return _buildBody(context);
            },
          ),
        ),
        _isLoading ? ScreenProgressLoader() : SizedBox(),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.fetchFavoritePlaces();
      },
      child: Padding(
        padding: EdgeInsets.all(Dimens.margin),
        child: StreamBuilder<List<Place>>(
            stream: bloc.places,
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SizedBox()
                  : Column(
                      children: [
                        Expanded(
                          child: VendorsGridView(
                            snapshot.data,
                            onItemClick: (item) async {
                              await pushPage(context, VendorDetailPage(place: item));
                              bloc.fetchFavoritePlaces();
                            },
                          ),
                        ),
                      ],
                    );
            }),
      ),
    );
  }
}
