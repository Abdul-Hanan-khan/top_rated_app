import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_rated_app/src/app/app_bloc.dart';
import 'package:top_rated_app/src/pages/add_review/add_review_page.dart';
import 'package:top_rated_app/src/pages/other_profile/OtherProfilePage.dart';
import 'package:top_rated_app/src/pages/review_replies/review_replies_page.dart';
import 'package:top_rated_app/src/pages/vendor_detail/vendor_detail_bloc.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/sdk/models/place_detail.dart';
import 'package:top_rated_app/src/sdk/models/rating_partial.dart';
import 'package:top_rated_app/src/sdk/utils/intent_utils.dart';
import 'package:top_rated_app/src/sdk/utils/navigation_utils.dart';
import 'package:top_rated_app/src/sdk/utils/ui_utils.dart';
import 'package:top_rated_app/src/sdk/utils/widget_utils.dart';
import 'package:top_rated_app/src/sdk/widgets/app_button.dart';
import 'package:top_rated_app/src/sdk/widgets/screen_progress_loader.dart';
import 'dart:math' as math;

import 'package:top_rated_app/static_vars.dart';

class VendorDetailPage extends StatefulWidget {
  final Place place;
  VendorDetailPage({@required this.place});
  @override
  _VendorDetailPageState createState() => new _VendorDetailPageState();
}

class _VendorDetailPageState extends State<VendorDetailPage> {
  ThemeData theme;
  BuildContext _context;
  VendorDetailBloc bloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  initBloc() {
    bloc = new VendorDetailBloc(widget.place);
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
      centerTitle: true,
      title: Text(StaticVars.localeStatus ==false? widget.place.placeNameEng.tr(): widget.place.placeNameAr.tr(),style: TextStyle(color: Colors.grey),),
      leading: WidgetUtils.getAdaptiveBackButton(context),
      actions: [
        StreamBuilder<PlaceDetail>(
            stream: bloc.detail,
            builder: (context, snapshot) {
              return IconButton(
                onPressed: () {
                  if (snapshot.data.isFavourite == 1) {
                    bloc.favorite(false);
                  } else {
                    bloc.favorite(true);
                  }
                },
                icon: Icon(
                  !snapshot.hasData
                      ? Icons.favorite_border
                      : snapshot.data.isFavourite == 1
                          ? Icons.favorite
                          : Icons.favorite_border,
                  color: Theme.of(context).primaryColor,
                ),
              );
            }),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: IconButton(
              onPressed: () {
                final detail = bloc.placeDetail;
                if (detail != null) Share.share(AppBloc.instance.placeShareMessage(widget.place, detail));
              },
              icon: Icon(
                Icons.reply,
                color: Theme.of(context).primaryColor,
              )),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<PlaceDetail>(
        stream: bloc.detail,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? SizedBox()
              : ListView(
                  padding: EdgeInsets.all(Dimens.margin),
                  children: [
                    _buildImages(context, snapshot.data),
                    Spacing.vertical,
                    _buildContactInfo(context, snapshot.data),
                    Spacing.vertical,
                    _buildRatingSection(context, snapshot.data),
                    Spacing.vertical,
                    _buildReviewsHeader(),
                    Spacing.vertical,
                    _buildReviewsList(context, snapshot.data),
                  ],
                );
        });
  }

  Widget _buildImages(BuildContext context, PlaceDetail detail) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(WidgetConstants.cornerRadius),
      ),
      child: CarouselSlider(
          items: [
            for (var image in detail.images)
              Image.network(
                AppConstants.imagePlaceBaseUrl + image.imagePath,
                fit: BoxFit.cover,
              ),
          ],
          options: CarouselOptions(
              height: 200,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: false,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal)),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(WidgetConstants.cornerRadius),
      child: Image.asset(
        "assets/images/clinic.jpg",
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, PlaceDetail detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.margin),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (detail.phone != null && detail.phone.isNotEmpty) {
                        IntentUtils.initCall(detail.phone);
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.margin),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          colors: [theme.accentColor, theme.primaryColor],
                          transform: GradientRotation(90),
                        ),
                      ),
                      child: Icon(
                        Icons.phone,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Spacing.vSmall,
                  Text(
                    "Phone".tr()+":",
                    style: theme.textTheme.subtitle2,
                  ),
                  Text(detail.phone.tr() ?? "--"),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (bloc.getLocationURL().isNotEmpty) IntentUtils.openBrowser(bloc.getLocationURL());
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.margin),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          colors: [theme.accentColor, theme.primaryColor],
                          transform: GradientRotation(90),
                        ),
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Spacing.vSmall,
                  Text(
                    "Address".tr()+":",
                    style: theme.textTheme.subtitle2,
                  ),
                  Text(
                    widget.place.address.tr() ?? "--",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection(BuildContext context, PlaceDetail detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.margin),
        child: Column(
          children: [
            Text(
              "${detail.getOverallRating()}".tr(),
              style: theme.textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
            ),
            RatingBar.builder(
              initialRating: detail.getOverallRating(),
              itemCount: 5,
              itemSize: 36,
              allowHalfRating: true,
              ignoreGestures: true,
              unratedColor: Theme.of(context).backgroundColor,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Theme.of(context).accentColor,
              ),
              onRatingUpdate: (rating) {},
            ),
            Text(
              "Based on".tr()+"${detail.reviewCount} " + "reviews".tr(),
              style: theme.textTheme.subtitle2,
            ),
            Spacing.vMedium,
            for (var rating in detail.averageRatings)
              Column(
                children: [
                  Spacing.vSmall,
                  _buildRatingRow(rating.nameEnglish, rating.getAverageRating()),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(String text, double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text.tr(),
          style: theme.textTheme.subtitle2,
        ),
        RatingBar.builder(
          initialRating: rating,
          itemCount: 5,
          itemSize: 24,
          ignoreGestures: true,
          unratedColor: Theme.of(context).backgroundColor,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Theme.of(context).accentColor,
          ),
          onRatingUpdate: (rating) {},
        ),
      ],
    );
  }

  Widget _buildReviewsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Last Reviews".tr(),
          style: theme.textTheme.headline6,
        ),
        AppButton(
          icon: Icons.add,
          text: "Add Review".tr(),
          height: 30,
          foreground: theme.colorScheme.onPrimary,
          elevation: 0,
          onPressed: () {
            pushPage(context, AddReviewPage(widget.place));
          },
        ),
      ],
    );
  }

  Widget _buildReviewsList(BuildContext context, PlaceDetail detail) {
    return ListView.builder(
      itemCount: detail.ratings.length,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _buildUserReviewItem(context, detail.ratings[index], detail);
      },
    );
  }

  Widget _buildUserReviewItem(BuildContext context, RatingPartial rating, PlaceDetail detail) {
    return GestureDetector(
      onTap: () async {
        await pushPage(context, OtherProfilePage(userId: rating.userId, name: rating.name));
        bloc.fetchDetail(widget.place);
      },
      child: Card(
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
                      Text(rating.name.tr(), style: theme.textTheme.subtitle2),
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
                              Share.share(AppBloc.instance.reviewShareMessage(rating));
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
              if (rating.replies?.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacing.vSmall,
                    Divider(),
                    Spacing.vSmall,
                    Text(rating.review.tr() ?? ""),
                    InkWell(
                      onTap: () {
                        pushPage(_context, ReviewRepliesPage(rating));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          "⎯⎯  View ${rating.replies.length} Replies".tr(),
                          style: theme.textTheme.subtitle1,
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController _replyController;
  _showReplyDialog(RatingPartial rating) {
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
