import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/app/app_theme.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/models/sub_category.dart';
import 'package:top_rated_app/static_vars.dart';

class SubCategoryItem extends StatelessWidget {
  final SubCategory subCategory;
  final bool isSelected;
  final Function() onClick;


  const SubCategoryItem({
    Key key,
    this.subCategory,
    this.isSelected = false,
    @required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = isSelected ? theme.accentColor : AppColor.primaryTextColor;

    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 84,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                  Dimens.margin_medium, Dimens.margin_medium, Dimens.margin_medium, Dimens.margin_xsmall),
              width: 40,
              height: 40,
              // child: Icon(
              //   FontAwesomeIcons.teethOpen,
              //   color: color,
              // ),
              child: Image.network(
                AppConstants.imageCategoryBaseUrl + subCategory.iconPath,
                width: 24,
                height: 24,
                color: isSelected ? theme.accentColor : AppColor.primaryTextColor,
              ),
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: color,
              //   ),
              //   borderRadius: BorderRadius.circular(12),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                StaticVars.localeStatus?subCategory.nameAr: subCategory.nameEng.tr(),
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.subtitle2.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
