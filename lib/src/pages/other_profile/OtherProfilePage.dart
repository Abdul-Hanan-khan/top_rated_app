import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_rated_app/src/app/app_bloc.dart';
import 'package:top_rated_app/src/app/app_theme.dart';
import 'package:top_rated_app/src/pages/other_profile/OtherProfileBloc.dart';
import 'package:top_rated_app/src/pages/review_replies/review_replies_page.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/models/place_detail.dart';
import 'package:top_rated_app/src/sdk/models/rating_partial.dart';
import 'package:top_rated_app/src/sdk/models/user_detail.dart';
import 'package:top_rated_app/src/sdk/models/user_rating.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/utils/widget_utils.dart';
import 'package:top_rated_app/src/sdk/widgets/app_button.dart';
import 'package:top_rated_app/src/sdk/widgets/screen_progress_loader.dart';

class OtherProfilePage extends StatefulWidget {
  final dynamic userId;
  final String name;
  OtherProfilePage({this.userId, this.name});

  @override
  _OtherProfilePageState createState() => new _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  ThemeData theme;
  BuildContext _context;
  OtherProfileBloc bloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    bloc = new OtherProfileBloc(widget.userId);
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
      title: Text("User Profile".tr()),
      leading: WidgetUtils.getAdaptiveBackButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildTopCard(),
        Text(
          "Reviews".tr(),
          style: theme.textTheme.headline6,
        ),
        Expanded(child: _buildReviewsList(context)),
      ],
    );
  }

  StreamBuilder<UserDetail> _buildTopCard() {
    return StreamBuilder<UserDetail>(
        stream: bloc.userDetail,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? SizedBox()
              : Card(
                  margin: EdgeInsets.all(Dimens.margin),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.margin),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.name.tr(),
                          style: theme.textTheme.headline5.copyWith(color: theme.colorScheme.onSurface),
                        ),
                        Spacing.vMedium,
                        Text(
                          "Followers".tr() +": ${snapshot.data.followersCount}",
                          style: theme.textTheme.subtitle1.copyWith(color: theme.colorScheme.onSurface),
                        ),
                        Spacing.vertical,
                        _buildFollowButton(context, snapshot.data.isFollowing == 1),
                      ],
                    ),
                  ),
                );
        });
  }

  Widget _buildFollowButton(BuildContext context, bool isFollowing) {
    return AppButton(
      text: isFollowing ? "Unfollow" : "Follow",
      onPressed: () {
        bloc.follow(!isFollowing);
      },
    );
  }

  Widget _buildReviewsList(BuildContext context) {
    return StreamBuilder<List<UserRating>>(
        stream: bloc.reviews,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: EdgeInsets.all(Dimens.margin),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return _buildUserReviewItem(context, snapshot.data[index]);
                  },
                );
        });
  }

  Widget _buildUserReviewItem(BuildContext context, UserRating rating) {
    return Card(
      child: Padding(
        padding: EdgeInsets.fromLTRB(Dimens.margin, Dimens.margin, Dimens.margin, Dimens.margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rating.placeNameEng.tr(), style: theme.textTheme.subtitle2),
                    Text(rating.displayDate.tr(),
                        style: theme.textTheme.bodyText2.copyWith(color: theme.colorScheme.onBackground)),
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
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        _showReplyDialog(rating);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Text(
                          "Reply".tr(),
                          style: theme.textTheme.subtitle1,
                        ),
                      ),
                    ),
                    Spacing.vMedium,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Share.share(AppBloc.instance.userReviewShareMessage(rating));
                          },
                          child: Icon(Icons.share),
                        ),
                        Spacing.horizontal,
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                bloc.like(rating.getId(), !(rating.isLiked == "1"));
                              },
                              child: Icon(rating.isLiked == "0" ? Icons.favorite_border_outlined : Icons.favorite),
                            ),
                            Text("${rating.totalLikes}".tr())
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Spacing.vSmall,
            Text(rating.review.tr() ?? ""),
          ],
        ),
      ),
    );
  }

  TextEditingController _replyController;
  _showReplyDialog(UserRating rating) {
    _replyController = TextEditingController();
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
                      controller: _replyController,
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
                      final text = _replyController.text.trim();
                      if (text.isNotEmpty) {
                        bloc.reply(rating.getId(), text);
                      }
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
