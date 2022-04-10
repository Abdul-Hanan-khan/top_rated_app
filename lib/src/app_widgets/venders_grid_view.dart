import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/constants/spacing.dart';
import 'package:top_rated_app/src/sdk/models/place.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/static_vars.dart';

class VendorsGridView extends StatelessWidget {
  final List<Place> places;
  final Function(Place) onItemClick;

  VendorsGridView(this.places, {@required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: places.length,
      itemBuilder: (context, index) {
        return VendorItem(places[index], onTap: onItemClick);
      },
    );
  }
}

class VendorItem extends StatelessWidget {
  final Function(Place) onTap;
  final Place place;

  VendorItem(
    this.place, {
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onTap(place);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacing.vMedium,
            Expanded(
              child: Image.network(
                AppConstants.imagePlaceBaseUrl + place.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.margin, vertical: Dimens.margin_medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Text(
                     StaticVars.localeStatus ==false?   place.placeNameEng.tr():place.placeNameAr.tr(),
                    style: Theme.of(context).textTheme.subtitle1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  RatingBar.builder(
                    initialRating: place.getOverallrating(),
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
            )
          ],
        ),
      ),
    );
  }
}
