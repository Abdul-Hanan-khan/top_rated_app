import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:top_rated_app/src/app/app_theme.dart';
import 'package:top_rated_app/src/sdk/constants/app_constants.dart';
import 'package:top_rated_app/src/sdk/constants/dimens.dart';
import 'package:top_rated_app/src/sdk/models/category.dart';
import 'package:top_rated_app/static_vars.dart';

class CategoryItem extends StatelessWidget {
  final bool isSelected;
  final Category category;

  final Function() onClick;


  const CategoryItem({
    Key key,
    @required this.category,
    this.isSelected = false,
    @required this.onClick,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 80,
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimens.margin),
                    topRight: Radius.circular(
                      Dimens.margin,
                    )),
                color: Colors.white,
              ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(6, 6, 6, 2),
              padding: EdgeInsets.all(6),
              width: 50,
              height: 50,
              child: ClipOval(
                child: Image.network(
                  AppConstants.imageCategoryBaseUrl + category.iconPath,
                  width: 24,
                  height: 24,
                  color: isSelected ? Colors.white : AppColor.primaryTextColor,
                ),
              ),
              // child: Icon(
              //   FontAwesomeIcons.personBooth,
              //   color: isSelected ? Colors.white : AppColor.primaryTextColor,
              // ),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.bottomCenter,
                        colors: [theme.accentColor, theme.primaryColor],
                        transform: GradientRotation(90),
                      )
                    : null,
                border: isSelected
                    ? null
                    : Border.all(
                        color: AppColor.primaryTextColor,
                      ),
                borderRadius: BorderRadius.circular(Dimens.margin),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                StaticVars.localeStatus?
                category.nameAr.tr()
                    :category.nameEng.tr(),
                style: theme.textTheme.subtitle2.copyWith(
                  color: isSelected ? theme.primaryColor : AppColor.primaryTextColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
