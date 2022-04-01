import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/pages/add_review/add_review_bloc.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:top_rated_app/src/sdk/models/rating_type.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/utils/widget_utils.dart';
import 'package:top_rated_app/src/sdk/widgets/app_button.dart';
import 'package:top_rated_app/src/sdk/widgets/screen_progress_loader.dart';
import 'package:top_rated_app/src/sdk/widgets/stream_text_field.dart';

class AddReviewPage extends StatefulWidget {
  final Place place;

  AddReviewPage(this.place);

  @override
  _AddReviewPageState createState() => new _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  ThemeData theme;
  BuildContext _context;
  AddReviewBloc bloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    bloc = new AddReviewBloc();
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
          appBar: _buildAppBar(context),
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

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Rate The Place".tr()),
      leading: WidgetUtils.getAdaptiveBackButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.margin),
      child: Column(
        children: [
          StreamBuilder<List<RatingType>>(
            stream: bloc.types,
            initialData: [],
            builder: (context, snapshot) {
              return Card(
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.margin),
                  child: Column(
                    children: [
                      for (var rating in snapshot.data) _buildRatingRow(rating),
                    ],
                  ),
                ),
              );
            },
          ),
          Spacing.vertical,
          StrTextField(
            bloc.review,
            hintText: "What's the reason behind your ratings?",
            onChanged: bloc.onReviewChanged,
            maxLines: 6,
          ),
          Spacing.vertical,
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildRatingRow(RatingType type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          type.nameEng.tr(),
          style: theme.textTheme.subtitle1,
        ),
        RatingBar.builder(
          initialRating: 0,
          itemCount: 5,
          itemSize: 30,
          unratedColor: Theme.of(context).backgroundColor,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Theme.of(context).accentColor,
          ),
          onRatingUpdate: (rating) {
            bloc.updateRating(type.getId(), rating);
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return AppButton(
      text: "Submit",
      onPressed: () async {
        if (await bloc.submitRating(widget.place)) {
          popPage(context);
        }
      },
    );
  }
}
