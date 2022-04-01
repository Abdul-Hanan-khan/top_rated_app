import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:top_rated_app/src/pages/review_replies/review_replies_bloc.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/models/rating_partial.dart';
import 'package:top_rated_app/src/sdk/models/reply.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/utils/widget_utils.dart';
import 'package:top_rated_app/src/sdk/widgets/screen_progress_loader.dart';

class ReviewRepliesPage extends StatefulWidget {
  final RatingPartial review;

  ReviewRepliesPage(this.review);

  @override
  _ReviewRepliesPageState createState() => new _ReviewRepliesPageState();
}

class _ReviewRepliesPageState extends State<ReviewRepliesPage> {
  ThemeData theme;
  BuildContext _context;
  ReviewRepliesBloc bloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    bloc = new ReviewRepliesBloc();
    bloc.isLoading.listen((event) {
      setState(() {
        _isLoading = event;
      });
    });

    bloc.exception.listen((event) {
      UIUtils.showAdaptiveDialog(_context, "Error".tr(), event);
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
      title: Text("Review Replies".tr()),
      leading: WidgetUtils.getAdaptiveBackButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReviewItem(context, widget.review),
          Spacing.vertical,
          Text(
            "Replies".tr(),
            style: theme.textTheme.headline6,
          ),
          Spacing.vertical,
          Expanded(
            child: _buildReplies(context),
          )
        ],
      ),
    );
  }

  Widget _buildReviewItem(BuildContext context, RatingPartial rating) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Dimens.margin, Dimens.margin, Dimens.margin, Dimens.margin_medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rating.name.tr(), style: theme.textTheme.subtitle2),
                    Text(rating.displayDate.tr(),
                        style: theme.textTheme.bodyText2.copyWith(color: theme.colorScheme.onBackground)),
                  ],
                ),
                // InkWell(
                //   onTap: () {
                //     _showReplyDialog();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                //     child: Text(
                //       "Reply",
                //       style: theme.textTheme.subtitle1,
                //     ),
                //   ),
                // ),
              ],
            ),
            RatingBar.builder(
              initialRating: rating.getAverageRating() ?? 0,
              itemCount: 5,
              itemSize: 20,
              ignoreGestures: true,
              unratedColor: Theme.of(context).backgroundColor,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Theme.of(context).accentColor,
              ),
              onRatingUpdate: (rating) {},
            ),
            if (rating.review?.trim()?.isNotEmpty == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacing.vSmall,
                  Divider(),
                  Spacing.vSmall,
                  Text(
                    rating.review.tr() ?? "".tr(),
                    style: theme.textTheme.subtitle1,
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildReplies(BuildContext context) {
    return ListView.builder(
      itemCount: widget.review.replies.length,
      itemBuilder: (context, index) {
        return _buildReplyItem(context, widget.review.replies[index]);
      },
    );
  }

  Widget _buildReplyItem(BuildContext context, Reply reply) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: Dimens.margin_small),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Dimens.margin, Dimens.margin, Dimens.margin, Dimens.margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reply.name.tr(), style: theme.textTheme.subtitle2),
            Text(reply.displayDate.tr(), style: theme.textTheme.bodyText2.copyWith(color: theme.colorScheme.onBackground)),
            Text(
              reply.text.tr(),
              style: theme.textTheme.bodyText1,
            )
          ],
        ),
      ),
    );
  }

  _showReplyDialog() {
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
                      "Reply".tr(),
                      style: theme.textTheme.headline6.copyWith(color: theme.accentColor),
                    ),
                    Spacing.vMedium,
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.vMedium,
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      popPage(context);
                    },
                    child: Text(
                      "Send".tr(),
                      style: theme.textTheme.subtitle1.copyWith(color: theme.primaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      popPage(context);
                    },
                    child: Text(
                      "Cancel".tr(),
                      style: theme.textTheme.subtitle1,
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
